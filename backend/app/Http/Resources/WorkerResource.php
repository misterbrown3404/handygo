<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class WorkerResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'address' => $this->address,
            'lat' => $this->lat,
            'lng' => $this->lng,
            'avatar' => $this->avatar,
            'specialty' => $this->specialty,
            'status' => $this->status,
            'is_available' => $this->is_available,
            'rating' => $this->rating,
            'total_jobs' => $this->total_jobs,
            'wallet_balance' => $this->when(auth()->user()?->id === $this->user_id, $this->wallet_balance),
        ];
    }
}
