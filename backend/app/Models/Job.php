<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Job extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'job_id',
        'customer_id',
        'worker_id',
        'service_id',
        'amount',
        'status',
        'date',
        'description',
        'address',
        'lat',
        'lng',
        'completion_photo',
        'worker_payout',
        'cancellation_reason',
    ];

    protected $casts = [
        'date' => 'date',
        'amount' => 'decimal:2',
        'lat' => 'decimal:7',
        'lng' => 'decimal:7',
        'worker_payout' => 'decimal:2',
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

    public function media()
    {
        return $this->morphMany(Media::class, 'model');
    }
}
