<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Worker;
use App\Models\Customer;
use App\Models\Subscription;
use App\Models\Job;
use App\Models\Service;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AdminDashboardController extends Controller
{
    /**
     * Dashboard overview stats for the admin panel.
     */
    public function stats()
    {
        $now = Carbon::now();
        $startOfMonth = $now->copy()->startOfMonth();

        // Revenue from active subscriptions this month
        $monthlyRevenue = Subscription::where('status', 'active')
            ->whereMonth('starts_at', $now->month)
            ->whereYear('starts_at', $now->year)
            ->sum('amount');

        $totalRevenue = Subscription::where('status', 'active')->sum('amount');

        $activeWorkers = Worker::where('status', 'active')->count();
        $totalWorkers = Worker::count();
        $totalCustomers = Customer::count();
        $totalJobs = Job::count();

        $activeSubscriptions = Subscription::where('status', 'active')
            ->where('expires_at', '>', $now)
            ->count();

        $expiredSubscriptions = Subscription::where('status', 'active')
            ->where('expires_at', '<=', $now)
            ->count();

        $pendingKyc = \App\Models\KycSubmission::where('status', 'pending')->count();

        // Recent activity
        $recentWorkers = Worker::with('user')
            ->latest()
            ->take(5)
            ->get()
            ->map(fn($w) => [
                'title' => 'New worker registration',
                'sub' => ($w->name ?? 'Unknown') . ' signed up',
                'time' => $w->created_at->diffForHumans(),
                'type' => 'worker',
            ]);

        $recentSubscriptions = Subscription::with('worker')
            ->where('status', 'active')
            ->latest()
            ->take(5)
            ->get()
            ->map(fn($s) => [
                'title' => 'Subscription activated',
                'sub' => ($s->worker->name ?? 'Unknown') . ' — ₦' . number_format($s->amount),
                'time' => $s->created_at->diffForHumans(),
                'type' => 'subscription',
            ]);

        return response()->json([
            'success' => true,
            'data' => [
                'total_revenue' => $totalRevenue,
                'monthly_revenue' => $monthlyRevenue,
                'active_workers' => $activeWorkers,
                'total_workers' => $totalWorkers,
                'total_customers' => $totalCustomers,
                'total_jobs' => $totalJobs,
                'active_subscriptions' => $activeSubscriptions,
                'expired_subscriptions' => $expiredSubscriptions,
                'pending_kyc' => $pendingKyc,
                'recent_activity' => $recentWorkers->merge($recentSubscriptions)
                    ->sortByDesc('time')
                    ->values()
                    ->take(10),
            ],
        ]);
    }

    /**
     * Revenue breakdown for charts.
     */
    public function revenue(Request $request)
    {
        $months = [];
        for ($i = 5; $i >= 0; $i--) {
            $date = Carbon::now()->subMonths($i);
            $revenue = Subscription::where('status', 'active')
                ->whereMonth('starts_at', $date->month)
                ->whereYear('starts_at', $date->year)
                ->sum('amount');

            $months[] = [
                'month' => $date->format('M Y'),
                'revenue' => (float) $revenue,
            ];
        }

        return response()->json([
            'success' => true,
            'data' => $months,
        ]);
    }

    /**
     * Workers grouped by service category for charts.
     */
    public function workersByCategory()
    {
        $categories = Worker::selectRaw('specialty, COUNT(*) as count')
            ->whereNotNull('specialty')
            ->groupBy('specialty')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }
}
