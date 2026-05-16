<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Services\FcmService;
use App\Models\User;
use App\Mail\BroadcastMail;
use Illuminate\Support\Facades\Mail;
use App\Models\Setting;

class NotificationController extends Controller
{
    protected $fcm;

    public function __construct(FcmService $fcm)
    {
        $this->fcm = $fcm;
    }

    /**
     * Register device token for push notifications.
     */
    public function registerDevice(Request $request)
    {
        $request->validate(['device_token' => 'required|string']);

        Auth::user()->update([
            'fcm_token' => $request->device_token
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Device registered successfully'
        ]);
    }

    /**
     * List user notifications.
     */
    public function index()
    {
        $notifications = Auth::user()->notifications()->paginate(20);
        
        return response()->json([
            'success' => true,
            'message' => 'Notifications retrieved',
            'data' => $notifications
        ]);
    }

    /**
     * Mark notification as read.
     */
    public function markRead($id)
    {
        $notification = Auth::user()->notifications()->findOrFail($id);
        $notification->markAsRead();
        
        return response()->json([
            'success' => true,
            'message' => 'Notification marked as read'
        ]);
    }

    /**
     * Broadcast notification to groups (Admin only).
     */
    public function broadcast(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:100',
            'body' => 'required|string|max:500',
            'target' => 'required|in:all,workers,customers',
            'send_email' => 'nullable|boolean',
        ]);

        $target = $request->target;
        $title = $request->title;
        $body = $request->body;

        // 1. Send Push Notification via FCM
        $topic = $target == 'all' ? 'broadcast_all' : ($target == 'workers' ? 'broadcast_workers' : 'broadcast_customers');
        $fcmSuccess = $this->fcm->broadcast($topic, $title, $body);

        // 2. Send Emails if requested or enabled in settings
        $emailEnabled = Setting::get('email_notifications_enabled') == '1';
        if ($request->send_email || $emailEnabled) {
            $query = User::query();
            if ($target == 'workers') $query->where('role', 'worker');
            if ($target == 'customers') $query->where('role', 'customer');

            // Send in chunks to handle large user bases
            $query->chunk(100, function ($users) use ($title, $body) {
                foreach ($users as $user) {
                    Mail::to($user->email)->queue(new BroadcastMail($title, $body));
                }
            });
        }

        return response()->json([
            'success' => true,
            'message' => "Notification broadcasted to $target successfully via Push" . ($emailEnabled ? " and Email" : "")
        ]);
    }
}
