<?php

namespace App\Http\Controllers;

use App\Models\Subscription;
use App\Models\Worker;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class SubscriptionController extends Controller
{
    /**
     * Worker initiates a subscription payment via Paystack.
     */
    public function initiate(Request $request)
    {
        $request->validate([
            'plan_name' => 'sometimes|string|in:monthly',
        ]);

        $user = $request->user();
        $worker = Worker::where('user_id', $user->id)->firstOrFail();

        $amount = 5000; // ₦5,000 monthly
        $reference = 'SUB_' . $worker->id . '_' . time();

        $response = Http::withToken(config('services.paystack.secret_key'))
            ->post(config('services.paystack.payment_url') . '/transaction/initialize', [
                'email' => $user->email,
                'amount' => $amount * 100, // Paystack uses kobo
                'reference' => $reference,
                'callback_url' => config('app.url') . '/api/v1/subscriptions/callback',
                'metadata' => [
                    'worker_id' => $worker->id,
                    'plan_name' => $request->plan_name ?? 'monthly',
                ],
            ]);

        $data = $response->json();

        if (!$data['status']) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to initialize payment',
            ], 400);
        }

        // Create pending subscription record
        Subscription::create([
            'worker_id' => $worker->id,
            'plan_name' => $request->plan_name ?? 'monthly',
            'amount' => $amount,
            'paystack_reference' => $reference,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Payment initialized',
            'data' => [
                'authorization_url' => $data['data']['authorization_url'],
                'reference' => $reference,
            ],
        ]);
    }

    /**
     * Check the current worker's subscription status.
     */
    public function status(Request $request)
    {
        $user = $request->user();
        $worker = Worker::where('user_id', $user->id)->first();

        if (!$worker) {
            return response()->json([
                'success' => false,
                'message' => 'Worker profile not found',
            ], 404);
        }

        $activeSubscription = Subscription::where('worker_id', $worker->id)
            ->where('status', 'active')
            ->where('expires_at', '>', now())
            ->latest()
            ->first();

        return response()->json([
            'success' => true,
            'data' => [
                'is_subscribed' => $activeSubscription !== null,
                'subscription' => $activeSubscription,
                'plan_name' => $activeSubscription?->plan_name,
                'expires_at' => $activeSubscription?->expires_at?->toIso8601String(),
            ],
        ]);
    }

    /**
     * Paystack webhook handler for subscription payments.
     */
    public function webhook(Request $request)
    {
        // Verify Paystack signature
        $signature = $request->header('x-paystack-signature');
        $payload = $request->getContent();
        $expected = hash_hmac('sha512', $payload, config('services.paystack.secret_key'));

        if ($signature !== $expected) {
            Log::warning('Paystack webhook: Invalid signature');
            return response('Invalid signature', 400);
        }

        $event = $request->input('event');
        $data = $request->input('data');

        Log::info('Paystack Subscription Webhook: ' . $event, $data ?? []);

        if ($event === 'charge.success') {
            $reference = $data['reference'] ?? null;

            if (!$reference) {
                return response('Missing reference', 400);
            }

            $subscription = Subscription::where('paystack_reference', $reference)->first();

            if ($subscription) {
                $now = Carbon::now();
                $subscription->update([
                    'status' => 'active',
                    'starts_at' => $now,
                    'expires_at' => $now->copy()->addMonth(),
                ]);

                // Activate the worker's visibility
                $subscription->worker()->update([
                    'status' => 'active',
                    'is_available' => true,
                ]);

                Log::info("Subscription activated for worker #{$subscription->worker_id}");
            }
        }

        return response('OK', 200);
    }

    /**
     * Admin: List all subscriptions with pagination.
     */
    public function adminIndex(Request $request)
    {
        $subscriptions = Subscription::with('worker.user')
            ->when($request->status, fn($q, $status) => $q->where('status', $status))
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $subscriptions,
        ]);
    }
}
