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
        $workers = Worker::when($request->status, function($query, $status) {
            return $query->where('status', $status);
        })
        ->paginate(20);
        
        return WorkerResource::collection($workers);
    }

    public function show($id)
    {
        $worker = Worker::findOrFail($id);
        return new WorkerResource($worker);
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
        $workers = $geocoder->nearbyWorkers($request->lat, $request->lng, $radius);

        return WorkerResource::collection($workers);
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

        return new WorkerResource($worker);
    }

    public function toggleStatus(Request $request, $id)
    {
        $worker = Worker::findOrFail($id);
        $this->authorize('update', $worker);

        $worker->update(['is_available' => !$worker->is_available]);

        return new WorkerResource($worker);
    }
}
