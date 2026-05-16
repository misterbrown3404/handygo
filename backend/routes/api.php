<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\JobController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\WorkerController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\ChatController;
use App\Http\Controllers\AnalyticsController;
use App\Http\Controllers\MediaController;
use App\Http\Controllers\GeoController;
use App\Http\Controllers\KycController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\WalletController;

/*
|--------------------------------------------------------------------------
| API Routes — HandyGo v1
| Base URL: /api/v1/
|--------------------------------------------------------------------------
*/

use App\Http\Controllers\Auth\SocialAuthController;
use App\Http\Controllers\SubscriptionController;
use App\Http\Controllers\Admin\AdminDashboardController;
use App\Http\Controllers\SettingsController;

Route::prefix('v1')->group(function () {

    // ─── Public Auth Routes ──────────────────────────────────────────────
    Route::prefix('auth')->middleware('throttle:10,1')->group(function () {
        Route::post('register',        [AuthController::class, 'register']);
        Route::post('login',           [AuthController::class, 'login']);
        Route::post('social',          [SocialAuthController::class, 'handle']);
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
        Route::post('reset-password',  [AuthController::class, 'resetPassword']);
        Route::post('verify-otp',      [AuthController::class, 'verifyOtp']);
    });

    // ─── Payment & Subscription Webhooks (no auth — Paystack signs the payload) ──
    Route::post('payments/webhook',      [PaymentController::class, 'webhook']);
    Route::post('subscriptions/webhook', [SubscriptionController::class, 'webhook']);

    // ─── Protected Routes (Bearer token via Sanctum) ─────────────────────
    Route::middleware('auth:sanctum')->group(function () {

        // Auth
        Route::post('auth/logout',          [AuthController::class, 'logout']);
        Route::get('auth/me',               [AuthController::class, 'me']);
        Route::put('auth/change-password',  [AuthController::class, 'changePassword']);

        // Profile
        Route::post('profile/update',       [\App\Http\Controllers\ProfileController::class, 'update']);
        Route::post('profile/avatar',       [\App\Http\Controllers\ProfileController::class, 'avatar']);
        Route::post('user/fcm-token',      [\App\Http\Controllers\Api\UserController::class, 'updateFcmToken']);

        // ── Subscriptions (Worker) ────────────────────────────────────────
        Route::post('subscriptions/initiate', [SubscriptionController::class, 'initiate']);
        Route::get('subscriptions/status',    [SubscriptionController::class, 'status']);

        // ── Jobs ──────────────────────────────────────────────────────────
        Route::get('jobs/export',           [JobController::class, 'export']);
        Route::get('jobs/filters/status',   [JobController::class, 'statusFilters']);
        Route::apiResource('jobs',          JobController::class);

        // ── Customers ─────────────────────────────────────────────────────
        Route::apiResource('customers',     CustomerController::class);

        // ── Workers ───────────────────────────────────────────────────────
        Route::get('workers/nearby',         [WorkerController::class, 'nearby']);
        Route::post('workers/{worker}/toggle-status', [WorkerController::class, 'toggleStatus']);
        Route::apiResource('workers',        WorkerController::class);

        // ── Services ──────────────────────────────────────────────────────
        Route::apiResource('services',       ServiceController::class);

        // ── Bookings ──────────────────────────────────────────────────────
        Route::post('bookings/{booking}/accept',   [BookingController::class, 'accept']);
        Route::post('bookings/{booking}/decline',  [BookingController::class, 'decline']);
        Route::post('bookings/{booking}/complete', [BookingController::class, 'complete']);
        Route::post('bookings/{booking}/cancel',   [BookingController::class, 'cancel']);
        Route::apiResource('bookings',              BookingController::class);

        // ── Favorites ─────────────────────────────────────────────────────
        Route::post('favorites/toggle',       [FavoriteController::class, 'toggle']);
        Route::get('favorites',               [FavoriteController::class, 'index']);

        // ── Chat ──────────────────────────────────────────────────────────
        Route::get('chat/threads',            [ChatController::class, 'threads']);
        Route::get('chat/threads/{userId}',   [ChatController::class, 'messages']);
        Route::post('chat/message',           [ChatController::class, 'send']);
        Route::post('chat/message/{id}/read', [ChatController::class, 'markRead']);

        // ── KYC (Worker submission & Legacy Admin) ──────────────────────────────────
        Route::get('kyc',                  [KycController::class, 'index']); // Legacy fallback
        Route::post('kyc/submit',          [KycController::class, 'submit']);
        Route::post('kyc/{id}/approve',    [KycController::class, 'approve']); // Legacy fallback
        Route::post('kyc/{id}/reject',     [KycController::class, 'reject']); // Legacy fallback

        // ── Media (image upload) ──────────────────────────────────────────
        Route::post('media/upload',        [MediaController::class, 'upload']);
        Route::delete('media/{id}',        [MediaController::class, 'destroy']);

        // ── Geo / Maps ────────────────────────────────────────────────────
        Route::get('geo/address',          [GeoController::class, 'forwardGeocode']);
        Route::get('geo/reverse',          [GeoController::class, 'reverseGeocode']);
        Route::get('geo/nearby',           [GeoController::class, 'nearby']);

        // ── Payments (Paystack) ───────────────────────────────────────────
        Route::post('payments/initiate',   [PaymentController::class, 'initiate']);
        Route::get('payments/verify/{ref}',[PaymentController::class, 'verify']);
        Route::get('payments/history',     [PaymentController::class, 'history']);

        // ── Wallet (Worker earnings) ──────────────────────────────────────
        Route::get('wallet/balance',          [WalletController::class, 'balance']);
        Route::get('wallet/transactions',     [WalletController::class, 'transactions']);
        Route::post('wallet/withdraw',        [WalletController::class, 'withdraw']);

        // ── Push Notifications ────────────────────────────────────────────
        Route::post('notifications/register-device',  [NotificationController::class, 'registerDevice']);
        Route::get('notifications',                   [NotificationController::class, 'index']);
        Route::post('notifications/{id}/read',        [NotificationController::class, 'markRead']);

        // ══════════════════════════════════════════════════════════════════
        // ── ADMIN ROUTES (role:admin only) ────────────────────────────────
        // ══════════════════════════════════════════════════════════════════
        Route::middleware('role:admin')->prefix('admin')->group(function () {
            // Dashboard
            Route::get('dashboard/stats',           [AdminDashboardController::class, 'stats']);
            Route::get('dashboard/revenue',         [AdminDashboardController::class, 'revenue']);
            Route::get('dashboard/workers-by-category', [AdminDashboardController::class, 'workersByCategory']);

            // Subscriptions management
            Route::get('subscriptions',             [SubscriptionController::class, 'adminIndex']);

            // Services / Categories CRUD (admin only)
            Route::post('services',                 [ServiceController::class, 'store']);
            Route::put('services/{id}',             [ServiceController::class, 'update']);
            Route::delete('services/{id}',          [ServiceController::class, 'destroy']);

            // KYC Management (admin only)
            Route::get('kyc',                       [KycController::class, 'index']);
            Route::post('kyc/{id}/approve',         [KycController::class, 'approve']);
            Route::post('kyc/{id}/reject',          [KycController::class, 'reject']);

            // Notifications (admin only)
            Route::post('notifications/broadcast',   [NotificationController::class, 'broadcast']);

            // Settings (admin only)
            Route::get('settings',                   [SettingsController::class, 'index']);
            Route::post('settings',                  [SettingsController::class, 'update']);

            // Analytics (admin only)
            Route::get('analytics/overview',         [AnalyticsController::class, 'overview']);
            Route::get('analytics/revenue',          [AnalyticsController::class, 'revenue']);
            Route::get('analytics/jobs-by-category', [AnalyticsController::class, 'jobsByCategory']);
            Route::get('analytics/weekly-volume',    [AnalyticsController::class, 'weeklyVolume']);
            Route::get('analytics/top-workers',      [AnalyticsController::class, 'topWorkers']);
        });
    });
});
