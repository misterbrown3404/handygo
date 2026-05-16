<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class GeoController extends Controller
{
    public function forwardGeocode(Request $request)
    {
        return response()->json([
            'success' => true,
            'message' => 'Geocoding not configured yet',
            'data' => [],
        ]);
    }

    public function reverseGeocode(Request $request)
    {
        return response()->json([
            'success' => true,
            'message' => 'Reverse geocoding not configured yet',
            'data' => [],
        ]);
    }

    public function nearby(Request $request)
    {
        return response()->json([
            'success' => true,
            'message' => 'Nearby search not configured yet',
            'data' => [],
        ]);
    }
}
