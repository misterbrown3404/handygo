<?php

namespace App\Http\Controllers;

use App\Models\Worker;
use Illuminate\Http\Request;
use App\Http\Resources\WorkerResource;
use App\Services\GeocoderService;

class WorkerController extends Controller
{
    public function index(Request $request)
    {
        $query = Worker::query();

        // Only show subscribed workers to customers
        if (!$request->user()?->hasRole('admin')) {
            $query->subscribed();
        }

        $workers = $query->when($request->status, function($query, $status) {
            return $query->where('status', $status);
        })
        ->when($request->location, function($query, $location) {
            return $query->where('address', 'like', '%' . $location . '%');
        })
        ->when($request->search, function($query, $search) {
            return $query->where(function($q) use ($search) {
                $q->where('name', 'like', '%' . $search . '%')
                  ->orWhere('specialty', 'like', '%' . $search . '%');
            });
        })
        ->paginate(20);
        
        return response()->json([
            'success' => true,
            'message' => 'Workers retrieved',
            'data' => WorkerResource::collection($workers)->response()->getData(true)
        ]);
    }

    public function show($id)
    {
        $worker = Worker::findOrFail($id);
        return response()->json([
            'success' => true,
            'message' => 'Worker details retrieved',
            'data' => new WorkerResource($worker)
        ]);
    }

    public function nearby(Request $request)
    {
        $request->validate([
            'lat' => 'required|numeric',
            'lng' => 'required|numeric',
            'radius' => 'sometimes|numeric', // in km
        ]);

        $radius = $request->radius ?? 10;
        
        $geocoder = new GeocoderService();
        $workers = $geocoder->nearbyWorkers(
            $request->lat, 
            $request->lng, 
            $radius, 
            $request->user()?->hasRole('admin') ?? false
        );

        return response()->json([
            'success' => true,
            'message' => 'Nearby workers retrieved',
            'data' => WorkerResource::collection($workers)
        ]);
    }

    public function update(Request $request, $id)
    {
        $worker = Worker::findOrFail($id);
        $this->authorize('update', $worker);

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'address' => 'sometimes|string',
            'lat' => 'sometimes|numeric',
            'lng' => 'sometimes|numeric',
            'avatar' => 'sometimes|string',
            'specialty' => 'sometimes|string',
            'is_available' => 'sometimes|boolean',
        ]);

        $worker->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Worker updated successfully',
            'data' => new WorkerResource($worker)
        ]);
    }

    public function toggleStatus(Request $request, $id)
    {
        $worker = Worker::findOrFail($id);
        $this->authorize('update', $worker);

        $worker->update(['is_available' => !$worker->is_available]);

        return response()->json([
            'success' => true,
            'message' => 'Worker availability toggled',
            'data' => new WorkerResource($worker)
        ]);
    }
}
