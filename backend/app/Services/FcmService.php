<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FcmService
{
    protected $messaging;

    public function __construct()
    {
        try {
            $factory = (new Factory)->withServiceAccount(storage_path('app/firebase-auth.json'));
            $this->messaging = $factory->createMessaging();
        } catch (\Exception $e) {
            Log::error("FCM Service initialization failed: " . $e->getMessage());
        }
    }

    /**
     * Send notification to a single device.
     */
    public function sendToDevice($token, $title, $body, $data = [])
    {
        if (!$this->messaging || !$token) return false;

        try {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(Notification::create($title, $body))
                ->withData($data);

            $this->messaging->send($message);
            return true;
        } catch (\Exception $e) {
            Log::error("FCM Send failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Broadcast to a topic.
     */
    public function broadcast($topic, $title, $body, $data = [])
    {
        if (!$this->messaging) return false;

        try {
            $message = CloudMessage::withTarget('topic', $topic)
                ->withNotification(Notification::create($title, $body))
                ->withData($data);

            $this->messaging->send($message);
            return true;
        } catch (\Exception $e) {
            Log::error("FCM Broadcast failed: " . $e->getMessage());
            return false;
        }
    }
}
