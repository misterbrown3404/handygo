<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class KycSubmissionResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'user_name' => $this->user?->name ?? 'Deleted User',
            'nin' => $this->nin,
            'bvn' => $this->bvn,
            'document_type' => $this->document_type,
            'document_front' => $this->document_front,
            'document_back' => $this->document_back,
            'selfie' => $this->selfie,
            'status' => $this->status,
            'rejection_reason' => $this->rejection_reason,
            'reviewed_at' => $this->reviewed_at,
            'created_at' => $this->created_at,
        ];
    }
}
