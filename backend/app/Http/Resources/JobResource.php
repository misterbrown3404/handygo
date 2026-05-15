<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class JobResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'job_id' => $this->job_id,
            'customer' => $this->whenLoaded('customer', function () {
                return [
                    'id' => $this->customer->id,
                    'name' => $this->customer->name,
                    'email' => $this->customer->email,
                ];
            }),
            'worker' => $this->whenLoaded('worker', function () {
                return [
                    'id' => $this->worker->id,
                    'name' => $this->worker->name,
                    'email' => $this->worker->email,
                    'status' => $this->worker->status,
                ];
            }),
            'service' => $this->whenLoaded('service', function () {
                return [
                    'id' => $this->service->id,
                    'name' => $this->service->name,
                    'category' => $this->service->category,
                ];
            }),
            'amount' => $this->amount,
            'status' => $this->status,
            'date' => $this->date->toDateString(),
            'created_at' => $this->created_at->toDateTimeString(),
            'updated_at' => $this->updated_at->toDateTimeString(),
        ];
    }
}
?>
