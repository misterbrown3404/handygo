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
        $data = [
            'total_revenue' => Job::where('status', 'completed')->sum('amount'),
            'total_jobs' => Job::count(),
            'active_workers' => Worker::where('status', 'active')->count(),
            'total_customers' => User::where('role', 'customer')->count(),
            'pending_kyc' => User::whereHas('kycSubmissions', function($q) {
                $q->where('status', 'pending');
            })->count(),
            'avg_job_value' => round(Job::where('status', 'completed')->avg('amount') ?? 0, 2),
            'worker_retention' => 95, // Placeholder
            'active_subscriptions' => Worker::subscribed()->count(),
            'jobs_this_month' => Job::whereMonth('date', now()->month)->count(),
        ];

        return response()->json([
            'success' => true,
            'message' => 'KPI overview retrieved',
            'data' => $data
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
                DB::raw('DATE(date) as period'),
                DB::raw('SUM(amount) as revenue')
            )
            ->groupBy('period')
            ->orderBy('period')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Revenue data retrieved',
            'data' => $revenue
        ]);
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
                    'category' => $service->name,
                    'count' => $service->jobs_count,
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Jobs by category retrieved',
            'data' => $distribution
        ]);
    }

    /**
     * Get weekly job volume (Completed vs Pending).
     */
    public function weeklyVolume()
    {
        $startOfWeek = now()->startOfWeek();
        
        $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        $results = [];

        foreach ($days as $day) {
            $completed = Job::where('status', 'completed')
                ->where(DB::raw('DAYNAME(date)'), $day)
                ->where('date', '>=', $startOfWeek)
                ->count();
            
            $pending = Job::whereIn('status', ['pending', 'in_progress'])
                ->where(DB::raw('DAYNAME(date)'), $day)
                ->where('date', '>=', $startOfWeek)
                ->count();

            $results[] = [
                'day' => substr($day, 0, 3),
                'completed' => $completed,
                'pending' => $pending
            ];
        }

        return response()->json([
            'success' => true,
            'message' => 'Weekly volume retrieved',
            'data' => $results
        ]);
    }

    /**
     * Get top performing workers.
     */
    public function topWorkers()
    {
        $workers = Worker::with('user')
            ->orderBy('rating', 'desc')
            ->orderBy('total_jobs', 'desc')
            ->take(5)
            ->get()
            ->map(function($worker) {
                return [
                    'name' => $worker->user->name ?? 'Unknown',
                    'specialty' => $worker->specialty,
                    'jobs_count' => $worker->total_jobs,
                    'rating' => $worker->rating,
                    'earnings' => Job::where('worker_id', $worker->id)->where('status', 'completed')->sum('amount'),
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Top workers retrieved',
            'data' => $workers
        ]);
    }
}
