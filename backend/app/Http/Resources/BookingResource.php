<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'customer' => new CustomerResource($this->whenLoaded('customer')),
            'worker' => new WorkerResource($this->whenLoaded('worker')),
            'service' => new ServiceResource($this->whenLoaded('service')),
            'scheduled_at' => $this->scheduled_at,
            'status' => $this->status,
            'notes' => $this->notes,
            'address' => $this->address,
            'amount' => $this->amount,
            'rating' => $this->rating,
            'review' => $this->review,
            'created_at' => $this->created_at,
        ];
    }
}
