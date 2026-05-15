<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;
use App\Http\Resources\BookingResource;

class BookingController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Booking::with(['customer', 'worker', 'service']);

        if ($user->hasRole('customer')) {
            $query->where('customer_id', $user->customer->id);
        } elseif ($user->hasRole('worker')) {
            $query->where('worker_id', $user->worker->id);
        }

        $bookings = $query->latest()->paginate(20);
        return BookingResource::collection($bookings);
    }

    public function store(Request $request)
    {
        $request->validate([
            'service_id' => 'required|exists:services,id',
            'scheduled_at' => 'required|date|after:now',
            'notes' => 'nullable|string',
            'address' => 'required|string',
            'lat' => 'nullable|numeric',
            'lng' => 'nullable|numeric',
        ]);

        $booking = Booking::create([
            'customer_id' => $request->user()->customer->id,
            'service_id' => $request->service_id,
            'scheduled_at' => $request->scheduled_at,
            'notes' => $request->notes,
            'address' => $request->address,
            'lat' => $request->lat,
            'lng' => $request->lng,
            'status' => 'pending',
        ]);

        return new BookingResource($booking->load('service'));
    }

    public function show($id)
    {
        $booking = Booking::with(['customer', 'worker', 'service'])->findOrFail($id);
        return new BookingResource($booking);
    }

    public function accept(Request $request, $id)
    {
        $booking = Booking::findOrFail($id);
        // Only workers can accept bookings
        if ($request->user()->role !== 'worker') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $booking->update([
            'worker_id' => $request->user()->worker->id,
            'status' => 'accepted',
        ]);

        return new BookingResource($booking);
    }

    public function complete(Request $request, $id)
    {
        $booking = Booking::findOrFail($id);
        $booking->update(['status' => 'completed']);
        
        // Logic to transfer funds to worker wallet could go here
        
        return new BookingResource($booking);
    }

    public function cancel(Request $request, $id)
    {
        $booking = Booking::findOrFail($id);
        $booking->update(['status' => 'cancelled']);
        return new BookingResource($booking);
    }
}
