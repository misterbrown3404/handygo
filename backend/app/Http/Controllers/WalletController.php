<?php

namespace App\Http\Controllers;

use App\Http\Requests\WithdrawRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Worker;
use Illuminate\Support\Facades\Auth;

class WalletController extends Controller
{
    public function balance()
    {
        $worker = Auth::user()->worker;

        if (!$worker) {
            return response()->json([
                'success' => false,
                'message' => 'Not a worker',
                'data' => null,
            ], 403);
        }

        return response()->json([
            'success' => true,
            'message' => 'Wallet balance retrieved',
            'data' => [
                'balance' => $worker->wallet_balance,
                'total_earned' => $worker->jobs()->where('status', 'completed')->sum('worker_payout'),
            ],
        ]);
    }

    public function transactions()
    {
        $worker = Auth::user()->worker;

        if (!$worker) {
            return response()->json([
                'success' => false,
                'message' => 'Not a worker',
                'data' => [],
            ], 403);
        }

        $transactions = $worker->jobs()
            ->where('status', 'completed')
            ->select('id', 'job_id', 'worker_payout as amount', 'updated_at as date')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Transactions retrieved',
            'data' => TransactionResource::collection($transactions),
        ]);
    }

    public function withdraw(WithdrawRequest $request)
    {
        $worker = Auth::user()->worker;

        if (!$worker) {
            return response()->json([
                'success' => false,
                'message' => 'Not a worker',
                'data' => null,
            ], 403);
        }

        if ($worker->wallet_balance < $request->amount) {
            return response()->json([
                'success' => false,
                'message' => 'Insufficient balance',
                'data' => null,
            ], 400);
        }

        return response()->json([
            'success' => true,
            'message' => 'Withdrawal request submitted successfully',
            'data' => null,
        ]);
    }
}