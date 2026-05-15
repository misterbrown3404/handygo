<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KycSubmission extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'nin',
        'bvn',
        'document_type',
        'document_front',
        'document_back',
        'selfie',
        'status',
        'rejection_reason',
        'reviewed_by',
        'reviewed_at',
        'verification_data',
    ];

    protected $casts = [
        'reviewed_at' => 'datetime',
        'verification_data' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reviewer()
    {
        return $this->belongsTo(User::class, 'reviewed_by');
    }
}
