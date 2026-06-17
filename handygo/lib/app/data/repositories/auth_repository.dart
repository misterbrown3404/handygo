import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../providers/api_client.dart';
import '../../core/constant/api_constants.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['access_token'] ?? json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

class AuthRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<AuthResponse> login(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await apiClient.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
        'role': 'customer',
      },
    );
  }

  Future<UserModel> getMe() async {
    final response = await apiClient.get(ApiConstants.me);
    return UserModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await apiClient.post(ApiConstants.logout);
  }

  Future<void> updateFcmToken(String token) async {
    await apiClient.post(ApiConstants.fcmToken, data: {'fcm_token': token});
  }

  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final String? idToken = await userCredential.user?.getIdToken();

    if (idToken == null) throw Exception('Failed to get Firebase ID Token');

    final response = await apiClient.post(
      '/auth/social',
      data: {'provider': 'google', 'token': idToken},
    );

    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final response = await apiClient.post(
      '/auth/social',
      data: {
        'provider': 'apple',
        'token': credential.identityToken,
        'name': credential.givenName != null
            ? "${credential.givenName} ${credential.familyName}"
            : null,
        'email': credential.email,
      },
    );

    return AuthResponse.fromJson(response.data);
  }
}