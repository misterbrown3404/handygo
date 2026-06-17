<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'job_id' => $this->job_id,
            'type' => 'Job Payment',
            'amount' => (float) $this->amount,
            'status' => 'completed',
            'date' => $this->date,
        ];
    }
}