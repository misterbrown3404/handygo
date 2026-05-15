<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\Job;
use Illuminate\Support\Facades\Log;

class PaymentController extends Controller
{
    /**
     * Initialize a Paystack transaction.
     */
    public function initiate(Request $request)
    {
        $request->validate([
            'job_id' => 'required|exists:jobs,id',
            'email' => 'required|email',
            'amount' => 'required|numeric',
        ]);

        $response = Http::withToken(config('services.paystack.secret_key'))
            ->post(config('services.paystack.payment_url') . '/transaction/initialize', [
                'email' => $request->email,
                'amount' => $request->amount * 100, // Paystack uses kobo
                'reference' => 'JOB_' . $request->job_id . '_' . time(),
                'callback_url' => route('api.payments.verify', ['ref' => 'REF']), // placeholder
                'metadata' => [
                    'job_id' => $request->job_id,
                ],
            ]);

        return response()->json($response->json());
    }

    /**
     * Verify Paystack transaction status.
     */
    public function verify($reference)
    {
        $response = Http::withToken(config('services.paystack.secret_key'))
            ->get(config('services.paystack.payment_url') . '/transaction/verify/' . $reference);

        $data = $response->json();

        if ($data['status'] && $data['data']['status'] === 'success') {
            // Update job payment status
            $jobId = $data['data']['metadata']['job_id'];
            Job::where('id', $jobId)->update(['status' => 'assigned']); // Example flow
            
            return response()->json(['message' => 'Payment successful', 'data' => $data['data']]);
        }

        return response()->json(['message' => 'Payment failed', 'data' => $data], 400);
    }

    /**
     * Webhook for Paystack asynchronous notifications.
     */
    public function webhook(Request $request)
    {
        // Verify signature (implementation omitted for brevity)
        $event = $request->input('event');
        
        Log::info('Paystack Webhook Received: ' . $event);

        if ($event === 'charge.success') {
            // Handle success
        }

        return response(200);
    }
}
