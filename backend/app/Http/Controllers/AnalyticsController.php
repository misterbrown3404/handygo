<?php

namespace App\Http\Controllers;

use App\Models\Job;
use App\Models\User;
use App\Models\Worker;
use App\Models\Booking;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AnalyticsController extends Controller
{
    /**
     * Get high-level KPI overview.
     */
    public function overview()
    {
        return response()->json([
            'total_revenue' => Job::where('status', 'completed')->sum('amount'),
            'total_jobs' => Job::count(),
            'active_workers' => Worker::where('status', 'active')->count(),
            'total_customers' => User::where('role', 'customer')->count(),
            'pending_kyc' => User::whereHas('kycSubmissions', function($q) {
                $q->where('status', 'pending');
            })->count(),
        ]);
    }

    /**
     * Get revenue data for charts.
     */
    public function revenue(Request $request)
    {
        $days = $request->days ?? 7;
        
        $revenue = Job::where('status', 'completed')
            ->where('date', '>=', now()->subDays($days))
            ->select(
                DB::raw('DATE(date) as day'),
                DB::raw('SUM(amount) as total')
            )
            ->groupBy('day')
            ->orderBy('day')
            ->get();

        return response()->json($revenue);
    }

    /**
     * Get job distribution by category for pie charts.
     */
    public function jobsByCategory()
    {
        $distribution = Service::withCount('jobs')
            ->get()
            ->map(function($service) {
                return [
                    'category' => $service->category,
                    'count' => $service->jobs_count,
                ];
            });

        return response()->json($distribution);
    }

    /**
     * Get weekly job volume (Completed vs Cancelled).
     */
    public function weeklyVolume()
    {
        $startOfWeek = now()->startOfWeek();
        
        $data = Job::where('date', '>=', $startOfWeek)
            ->select(
                DB::raw('DAYNAME(date) as day'),
                DB::raw('status'),
                DB::raw('COUNT(*) as count')
            )
            ->groupBy('day', 'status')
            ->get()
            ->groupBy('day');

        return response()->json($data);
    }

    /**
     * Get top performing workers.
     */
    public function topWorkers()
    {
        $workers = Worker::orderBy('rating', 'desc')
            ->orderBy('total_jobs', 'desc')
            ->take(5)
            ->get();

        return response()->json($workers);
    }
}
