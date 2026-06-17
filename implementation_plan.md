# HandyGo Worker App — Production Readiness Plan

## Goal
Make the Worker app fully production-ready: connect all endpoints, implement missing screens (forgot password, edit profile, change password), remove all dummy data, enforce input validation everywhere, and ensure backend rate limiting is correctly scoped.

---

## Audit Summary

### Flutter — Issues Found
| Issue | Location | Priority |
|---|---|---|
| Profile page uses 100% dummy data (name, rating, jobs, avatar) | `profile_controller.dart`, `profile_view.dart` | 🔴 Critical |
| "Edit Profile" menu item tap is empty `() {}` | `profile_view.dart:34` | 🔴 Critical |
| "Sign Out" button has empty `() {}` handler | `profile_view.dart:70` | 🔴 Critical |
| "Forgot Password?" button has empty `() {}` handler | `login_view.dart:94` | 🔴 Critical |
| Signup flow does NOT call the backend `/auth/register` | `auth_controller.dart:83` | 🔴 Critical |
| KYC submission does NOT call `/kyc/submit` | `auth_controller.dart:87` | 🔴 Critical |
| "Notifications" menu item is dead | `profile_view.dart:43` | 🟡 Medium |
| "My Services" menu item is dead | `profile_view.dart:59` | 🟡 Medium |
| Dashboard avatar is a hardcoded local asset | `dashboard_view.dart:103` | 🟡 Medium |
| Profile page avatar is a hardcoded local asset | `profile_view.dart:137` | 🟡 Medium |
| Profile stats (rating, jobs, exp) are hardcoded | `profile_view.dart:201-208` | 🔴 Critical |
| `TransactionModel.fromJson` uses broken string interpolation for `job_id` and `date` | `transaction_model.dart:23,27` | 🔴 Critical |
| `ApiClient` missing `put` and `patch` methods | `api_client.dart` | 🔴 Critical |
| No profile repository exists | - | 🔴 Critical |

### Backend — Issues Found
| Issue | Location | Priority |
|---|---|---|
| `ProfileController` does not update worker's `bio` / `specialty` fields | `ProfileController.php:31` | 🟡 Medium |
| Rate limiting is already applied to `/auth/*` (10 req/min) ✅ | `api.php:35` | ✅ OK |
| `WorkerController@toggleStatus` uses `is_available` but returns `WorkerResource` — check field name consistency | `WorkerController.php:107` | 🟡 Medium |

---

## Proposed Changes

### 1. Backend — ProfileController fix & worker profile fields

#### [MODIFY] [ProfileController.php](file:///Users/annur-dev/Flutter-work/handyGo/backend/app/Http/Controllers/ProfileController.php)
- Add `bio` and `specialty` to the validated update fields so the worker can update their professional info.

---

### 2. Flutter Data Layer

#### [MODIFY] [transaction_model.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/data/models/transaction_model.dart)
- Fix broken string interpolation: `'$json[job_id]'` → `json['job_id'].toString()` and same for `date`.
- Add safe null checking.

#### [MODIFY] [api_client.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/data/providers/api_client.dart)
- Add `put()` and `delete()` methods needed by profile update.

#### [NEW] [profile_repository.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/data/repositories/profile_repository.dart)
- `getProfile()` → calls `GET /auth/me`, returns user map.
- `updateProfile({name, phone, bio, specialty})` → calls `POST /profile/update`.
- `updateAvatar(File file)` → calls `POST /profile/avatar` as multipart.
- `changePassword({currentPassword, newPassword, confirmation})` → calls `PUT /auth/change-password`.

---

### 3. Flutter Auth — Complete Missing Flows

#### [MODIFY] [auth_controller.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/auth/controllers/auth_controller.dart)
- Add real `signup()` implementation: calls `POST /auth/register` with role=worker.
- Add real `submitKyc()` implementation: calls `POST /kyc/submit` after validation.
- Add `forgotPassword(email)` → `POST /auth/forgot-password`.
- Add `verifyOtp(email, otp)` → `POST /auth/verify-otp`.
- Add `resetPassword(email, otp, newPassword, confirmation)` → `POST /auth/reset-password`.
- Add new TextEditingControllers for email, OTP, new password, confirm password.
- Add `logout()` method: calls `POST /auth/logout`, clears storage, redirects to login.

#### [NEW] [forgot_password_view.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/auth/views/forgot_password_view.dart)
- 3-step flow: Enter Email → Enter OTP → Reset Password.
- Uses `PageView` or internal step counter controlled by `AuthController`.
- All input fields validated before proceeding.
- Loading and error states handled per step.

---

### 4. Flutter Profile — Full Real Implementation

#### [MODIFY] [profile_controller.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/profile/controllers/profile_controller.dart)
- Remove all dummy data.
- `onInit()`: load cached user from `GetStorage`. Then call `fetchProfile()` from API.
- Expose reactive: `name`, `phone`, `email`, `avatar`, `rating`, `jobsDone`, `specialty`, `bio`.
- Add `logout()` method (calls repo, clears storage).
- Inject `ProfileRepository`.

#### [MODIFY] [profile_view.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/profile/views/profile_view.dart)
- Load real name, specialty, rating, job count, avatar from controller.
- Wire "Edit Profile" → navigate to `Routes.EDIT_PROFILE`.
- Wire "Sign Out" → call `controller.logout()`.
- Wire "Notifications" and "My Services" to appropriate placeholders or stubs with UI feedback.
- Avatar: display network image if URL available, fallback to placeholder.
- Stats: use real `rating`, `jobsDone` from controller, remove `4.9` and `120` hardcodes.

#### [NEW] [edit_profile_view.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/profile/views/edit_profile_view.dart)
- Fields: Name, Phone, Specialty/Trade, Bio.
- Avatar picker: tap avatar → image picker → upload to `/profile/avatar`.
- Validation on every field before save.
- Loading/error states.
- "Change Password" section: current password, new password, confirm password → `PUT /auth/change-password`.

#### [NEW] [edit_profile_controller.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/profile/controllers/edit_profile_controller.dart)
- Separate controller for edit profile screen.
- Pre-fills fields from storage.
- `saveProfile()`, `saveAvatar()`, `savePassword()`.
- Loading and error states per operation.

---

### 5. Routes Update

#### [MODIFY] [app_routes.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/routes/app_routes.dart)
- Add `EDIT_PROFILE = '/edit-profile'`
- Add `FORGOT_PASSWORD = '/forgot-password'`

#### [MODIFY] [app_pages.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/routes/app_pages.dart)
- Register `EditProfileView` and `ForgotPasswordView` with their bindings.

---

### 6. Signup & KYC Flow fix

#### [MODIFY] [signup_view.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/auth/views/signup_view.dart)
- Add email field (backend requires email for worker registration).
- Add confirm password field.
- Validate all fields locally before calling `controller.signup()`.

#### [MODIFY] [kyc_view.dart](file:///Users/annur-dev/Flutter-work/handyGo/handygo_worker/lib/app/modules/auth/views/kyc_view.dart)
- Add loading state to "Verify My Identity" button.
- Wire to real API call via `controller.submitKyc()`.

---

## Verification Plan

### Build Check
- Run `flutter analyze` and ensure zero errors.
- Run `flutter build apk --debug` to ensure no compile errors.

### Manual Verification
1. Login with phone/email → should land on dashboard with real name and data.
2. Forgot Password → enter email → receive OTP (check email) → enter OTP → reset password → login with new password.
3. Edit Profile → change name → tap Save → verify name updates on profile page.
4. Change Password → enter wrong current password → should show error. Enter correct → should succeed.
5. Sign Out → should clear storage and go to login screen.
6. Signup → fill all fields → KYC → onboarding → should create a real worker account.

> [!IMPORTANT]
> The `EDIT_PROFILE` and `FORGOT_PASSWORD` routes are new screens. Bindings must be registered in `AppPages`. The `EditProfileController` must be a distinct binding from the main `ProfileController` to avoid state conflicts.

> [!WARNING]
> The avatar upload uses `image_picker` package. Confirm this is already in `pubspec.yaml`. If not, it needs to be added.
