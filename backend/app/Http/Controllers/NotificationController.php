<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    /**
     * Register device token for push notifications.
     */
    public function registerDevice(Request $request)
    {
        $request->validate(['device_token' => 'required|string']);

        Auth::user()->update([
            'device_token' => $request->device_token
        ]);

        return response()->json(['message' => 'Device registered successfully']);
    }

    /**
     * List user notifications.
     */
    public function index()
    {
        // Using Laravel's built-in notification system
        return response()->json(Auth::user()->notifications()->paginate(20));
    }

    /**
     * Mark notification as read.
     */
    public function markRead($id)
    {
        $notification = Auth::user()->notifications()->findOrFail($id);
        $notification->markAsRead();
        return response()->json(['message' => 'Notification marked as read']);
    }
}
