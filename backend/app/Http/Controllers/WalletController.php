<?php

namespace App\Http\Controllers;

use App\Models\Worker;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class WalletController extends Controller
{
    /**
     * Get current worker's wallet balance and transactions.
     */
    public function balance()
    {
        $worker = Auth::user()->worker;
        
        if (!$worker) {
            return response()->json(['message' => 'Not a worker'], 403);
        }

        return response()->json([
            'balance' => $worker->wallet_balance,
            'total_earned' => $worker->jobs()->where('status', 'completed')->sum('worker_payout'),
        ]);
    }

    /**
     * Placeholder for transaction history.
     */
    public function transactions()
    {
        // In a real app, you'd have a 'transactions' table
        // For now, return completed jobs as "income"
        $worker = Auth::user()->worker;
        
        $transactions = $worker->jobs()
            ->where('status', 'completed')
            ->select('id', 'job_id', 'worker_payout as amount', 'updated_at as date')
            ->latest()
            ->get();

        return response()->json($transactions);
    }

    /**
     * Request a withdrawal to bank account.
     */
    public function withdraw(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1000', // min withdrawal 1000 NGN
            'bank_code' => 'required|string',
            'account_number' => 'required|string',
        ]);

        $worker = Auth::user()->worker;

        if ($worker->wallet_balance < $request->amount) {
            return response()->json(['message' => 'Insufficient balance'], 400);
        }

        // Logic to initiate transfer via Paystack / Flutterwave would go here
        
        // $worker->decrement('wallet_balance', $request->amount);

        return response()->json(['message' => 'Withdrawal request submitted successfully']);
    }
}
