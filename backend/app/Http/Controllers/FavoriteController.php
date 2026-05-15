<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    /**
     * List user's favorites.
     */
    public function index()
    {
        $favorites = Favorite::where('user_id', Auth::id())
            ->with('favoritable')
            ->get();
            
        return response()->json($favorites);
    }

    /**
     * Toggle favorite status.
     */
    public function toggle(Request $request)
    {
        $request->validate([
            'favoritable_id' => 'required|integer',
            'favoritable_type' => 'required|string|in:worker,service',
        ]);

        $type = $request->favoritable_type === 'worker' ? \App\Models\Worker::class : \App\Models\Service::class;

        $favorite = Favorite::where('user_id', Auth::id())
            ->where('favoritable_id', $request->favoritable_id)
            ->where('favoritable_type', $type)
            ->first();

        if ($favorite) {
            $favorite->delete();
            return response()->json(['message' => 'Removed from favorites', 'is_favorite' => false]);
        } else {
            Favorite::create([
                'user_id' => Auth::id(),
                'favoritable_id' => $request->favoritable_id,
                'favoritable_type' => $type,
            ]);
            return response()->json(['message' => 'Added to favorites', 'is_favorite' => true]);
        }
    }
}
