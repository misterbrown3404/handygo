<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;
use App\Http\Resources\ServiceResource;

class ServiceController extends Controller
{
    public function index()
    {
        $services = Service::where('is_active', true)->get();
        return ServiceResource::collection($services);
    }

    public function show($id)
    {
        $service = Service::findOrFail($id);
        return new ServiceResource($service);
    }

    public function store(Request $request)
    {
        $this->authorize('create', Service::class);
        
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'description' => 'nullable|string',
            'icon' => 'nullable|string',
            'base_price' => 'nullable|numeric',
        ]);

        $service = Service::create($validated);

        return new ServiceResource($service);
    }

    public function update(Request $request, $id)
    {
        $service = Service::findOrFail($id);
        $this->authorize('update', $service);

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'category' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'icon' => 'sometimes|string',
            'base_price' => 'sometimes|numeric',
            'is_active' => 'sometimes|boolean',
        ]);

        $service->update($validated);

        return new ServiceResource($service);
    }

    public function destroy($id)
    {
        $service = Service::findOrFail($id);
        $this->authorize('delete', $service);
        $service->delete();

        return response()->json(['message' => 'Service deleted successfully']);
    }
}
