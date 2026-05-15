<?php

namespace App\Http\Controllers;

use App\Http\Resources\JobResource;
use App\Http\Requests\StoreJobRequest;
use App\Http\Requests\UpdateJobRequest;
use App\Models\Job;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\StreamedResponse;

class JobController extends Controller
{
    /**
     * Display a paginated listing of jobs.
     */
    public function index(Request $request)
    {
        $perPage = $request->query('per_page', 20);
        $jobs = Job::with(['customer', 'worker', 'service'])
            ->when($request->filled('status'), fn($q) => $q->where('status', $request->status))
            ->when($request->filled('search'), function ($q) use ($request) {
                $search = $request->search;
                $q->where(function ($sub) use ($search) {
                    $sub->where('job_id', 'like', "%{$search}%")
                        ->orWhereHas('customer', fn($c) => $c->where('name', 'like', "%{$search}%"))
                        ->orWhereHas('worker', fn($w) => $w->where('name', 'like', "%{$search}%"));
                });
            })
            ->orderByDesc('date')
            ->paginate($perPage);

        return JobResource::collection($jobs);
    }

    /**
     * Store a newly created job.
     */
    public function store(StoreJobRequest $request)
    {
        $validated = $request->validated();
        $validated['id'] = (string) \Illuminate\Support\Str::uuid();
        $validated['job_id'] = '#'.rand(1000,9999);
        $job = Job::create($validated);
        return new JobResource($job);
    }

    /**
     * Display the specified job.
     */
    public function show(string $id)
    {
        $job = Job::with(['customer', 'worker', 'service'])->findOrFail($id);
        return new JobResource($job);
    }

    /**
     * Update the specified job.
     */
    public function update(UpdateJobRequest $request, string $id)
    {
        $job = Job::findOrFail($id);
        $job->update($request->validated());
        return new JobResource($job);
    }

    /**
     * Remove (soft‑delete) the job.
     */
    public function destroy(string $id)
    {
        $job = Job::findOrFail($id);
        $job->delete();
        return response()->json(['message' => 'Job deleted'], 200);
    }

    /**
     * Export filtered jobs as CSV.
     */
    public function export(Request $request)
    {
        $jobs = Job::with(['customer', 'worker', 'service'])
            ->when($request->filled('status'), fn($q) => $q->where('status', $request->status))
            ->when($request->filled('search'), function ($q) use ($request) {
                $search = $request->search;
                $q->where(function ($sub) use ($search) {
                    $sub->where('job_id', 'like', "%{$search}%")
                        ->orWhereHas('customer', fn($c) => $c->where('name', 'like', "%{$search}%"))
                        ->orWhereHas('worker', fn($w) => $w->where('name', 'like', "%{$search}%"));
                });
            })
            ->orderByDesc('date')
            ->get();

        $callback = function () use ($jobs) {
            $handle = fopen('php://output', 'w');
            // Header row
            fputcsv($handle, ['Job ID', 'Customer', 'Worker', 'Service', 'Amount', 'Date', 'Status']);
            foreach ($jobs as $job) {
                fputcsv($handle, [
                    $job->job_id,
                    $job->customer->name ?? 'N/A',
                    $job->worker->name ?? 'Unassigned',
                    $job->service->name ?? 'N/A',
                    $job->amount,
                    $job->date->format('Y-m-d'),
                    $job->status,
                ]);
            }
            fclose($handle);
        };

        $filename = 'jobs_'.now()->format('Ymd_Hi').'.csv';
        return response()->streamDownload($callback, $filename, [
            'Content-Type' => 'text/csv',
            'Cache-Control' => 'no-store, no-cache',
        ]);
    }
}

?>
