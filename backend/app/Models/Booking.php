<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Booking extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'customer_id',
        'worker_id',
        'service_id',
        'scheduled_at',
        'status',
        'notes',
        'address',
        'lat',
        'lng',
        'amount',
        'platform_fee',
        'worker_payout',
        'rating',
        'review',
    ];

    protected $casts = [
        'scheduled_at' => 'datetime',
        'amount' => 'decimal:2',
        'platform_fee' => 'decimal:2',
        'worker_payout' => 'decimal:2',
        'lat' => 'decimal:7',
        'lng' => 'decimal:7',
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    public function worker()
    {
        return $this->belongsTo(Worker::class);
    }

    public function service()
    {
        return $this->belongsTo(Service::class);
    }
}
