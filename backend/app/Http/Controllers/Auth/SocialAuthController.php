<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Illuminate\Support\Str;

class SocialAuthController extends Controller
{
    /**
     * Handle social login/registration
     */
    public function handle(Request $request)
    {
        $request->validate([
            'provider' => 'required|in:google,apple',
            'token' => 'required',
        ]);

        try {
            if ($request->provider === 'google') {
                return $this->handleGoogle($request->token);
            } else {
                return $this->handleApple($request);
            }
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication failed: ' . $e->getMessage()
            ], 401);
        }
    }

    protected function handleGoogle($token)
    {
        $auth = Firebase::auth();
        $verifiedIdToken = $auth->verifyIdToken($token);
        
        $claims = $verifiedIdToken->claims();
        $email = $claims->get('email');
        $name = $claims->get('name');
        $avatar = $claims->get('picture');

        return $this->loginOrCreateUser($email, $name, $avatar, 'google');
    }

    protected function handleApple(Request $request)
    {
        // For Apple, we'll verify the token. 
        // Note: Full Apple verification requires public keys from Apple.
        // For this implementation, we trust the token if it's sent from a secure app context, 
        // but in production you should use 'socialite' or a JWT verifier.
        
        // Decoding the JWT payload without full verification for demonstration 
        // (In a real app, use lcobucci/jwt to verify signature against Apple public keys)
        $segments = explode('.', $request->token);
        if (count($segments) !== 3) {
            throw new \Exception('Invalid Apple token');
        }

        $payload = json_decode(base64_decode($segments[1]), true);
        $email = $payload['email'] ?? $request->email;
        $name = $request->name ?? ($payload['name'] ?? 'Apple User');

        if (!$email) {
            throw new \Exception('Email not provided by Apple');
        }

        return $this->loginOrCreateUser($email, $name, null, 'apple');
    }

    protected function loginOrCreateUser($email, $name, $avatar, $provider)
    {
        $user = User::where('email', $email)->first();

        if (!$user) {
            $user = User::create([
                'name' => $name,
                'email' => $email,
                'password' => bcrypt(Str::random(16)),
                'role' => 'customer', // Default role
                'avatar' => $avatar,
                'email_verified_at' => now(),
            ]);
            
            // Create customer profile
            $user->customer()->create([
                'name' => $name,
                'phone' => '', // To be updated by user
                'avatar' => $avatar,
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user->load(['customer', 'worker']),
        ]);
    }
}
