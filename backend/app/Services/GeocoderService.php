<?php

namespace App\Services;

use App\Models\Worker;
use Illuminate\Support\Collection;

class GeocoderService
{
    /**
     * Find workers nearby using Haversine formula.
     */
    public function nearbyWorkers(float $lat, float $lng, int $radiusKm): Collection
    {
        return Worker::selectRaw("
            *, (6371 * acos(
                cos(radians(?)) *
                cos(radians(lat)) *
                cos(radians(lng) - radians(?)) +
                sin(radians(?)) *
                sin(radians(lat))
            )) AS distance
        ", [$lat, $lng, $lat])
            ->where('status', 'active')
            ->where('is_available', true)
            ->having('distance', '<', $radiusKm)
            ->orderBy('distance')
            ->get();
    }

    /**
     * Placeholder for real geocoding API (Google/Mapbox).
     */
    public function forwardGeocode(string $address): array
    {
        // Integration with Google Maps / Mapbox would happen here
        // For now, return random Lagos coordinates for demo
        return [
            'lat' => 6.5244 + (rand(-100, 100) / 1000),
            'lng' => 3.3792 + (rand(-100, 100) / 1000),
        ];
    }
}
