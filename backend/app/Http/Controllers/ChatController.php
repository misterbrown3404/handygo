<?php

namespace App\Http\Controllers;

use App\Models\ChatMessage;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Resources\ChatMessageResource;
use Illuminate\Support\Facades\Auth;

class ChatController extends Controller
{
    /**
     * Get list of users the current user has chatted with.
     */
    public function threads()
    {
        $userId = Auth::id();
        
        $threads = ChatMessage::where('sender_id', $userId)
            ->orWhere('receiver_id', $userId)
            ->latest()
            ->get()
            ->groupBy(function($message) use ($userId) {
                return $message->sender_id == $userId ? $message->receiver_id : $message->sender_id;
            })
            ->map(function($messages) {
                return $messages->first();
            });

        return ChatMessageResource::collection($threads);
    }

    /**
     * Get messages between current user and another user.
     */
    public function messages($userId)
    {
        $currentUserId = Auth::id();
        
        $messages = ChatMessage::where(function($query) use ($currentUserId, $userId) {
            $query->where('sender_id', $currentUserId)->where('receiver_id', $userId);
        })
        ->orWhere(function($query) use ($currentUserId, $userId) {
            $query->where('sender_id', $userId)->where('receiver_id', $currentUserId);
        })
        ->oldest()
        ->get();

        return ChatMessageResource::collection($messages);
    }

    /**
     * Send a new message.
     */
    public function send(Request $request)
    {
        $request->validate([
            'receiver_id' => 'required|exists:users,id',
            'content' => 'required|string',
            'attachment' => 'nullable|string',
        ]);

        $message = ChatMessage::create([
            'sender_id' => Auth::id(),
            'receiver_id' => $request->receiver_id,
            'content' => $request->content,
            'attachment' => $request->attachment,
        ]);

        // Logic to trigger real-time notification (Pusher/FCM) could go here

        return new ChatMessageResource($message);
    }

    /**
     * Mark message as read.
     */
    public function markRead($id)
    {
        $message = ChatMessage::findOrFail($id);
        if ($message->receiver_id == Auth::id()) {
            $message->update([
                'is_read' => true,
                'read_at' => now(),
            ]);
        }

        return response()->json(['message' => 'Message marked as read']);
    }
}
