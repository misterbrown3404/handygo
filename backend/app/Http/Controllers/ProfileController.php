<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\User;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string|max:255',
        ]);

        $user = $request->user();
        $user->name = $request->name;
        $user->phone = $request->phone;
        $user->save();

        if ($user->role === 'customer' && $user->customer) {
            $user->customer->update([
                'name' => $request->name,
                'phone' => $request->phone,
                'address' => $request->address,
            ]);
        } elseif ($user->role === 'worker' && $user->worker) {
            $user->worker->update([
                'name' => $request->name,
                'phone' => $request->phone,
                // Worker might have an address or location field. Let's assume address exists.
                // If not, we skip it or check first. For safety we only update what's in worker model.
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data' => $user->load(['customer', 'worker']),
        ]);
    }

    public function avatar(Request $request)
    {
        $request->validate([
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            // Upload to Cloudinary
            $uploadedFileUrl = cloudinary()->upload($request->file('avatar')->getRealPath())->getSecurePath();
            $url = $uploadedFileUrl;
            
            $user->avatar = $url;
            $user->save();

            if ($user->role === 'customer' && $user->customer) {
                $user->customer->update(['avatar' => $url]);
            } elseif ($user->role === 'worker' && $user->worker) {
                $user->worker->update(['avatar' => $url]);
            }

            return response()->json([
                'success' => true,
                'message' => 'Avatar uploaded successfully',
                'data' => [
                    'avatar_url' => $url,
                ]
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'No file uploaded',
            'data' => null,
        ], 400);
    }
}
