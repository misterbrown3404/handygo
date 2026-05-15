<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Worker extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'email',
        'phone',
        'address',
        'lat',
        'lng',
        'avatar',
        'specialty',
        'status',
        'is_available',
        'rating',
        'total_jobs',
        'wallet_balance',
    ];

    protected $casts = [
        'is_available' => 'boolean',
        'lat' => 'decimal:7',
        'lng' => 'decimal:7',
        'rating' => 'decimal:2',
        'wallet_balance' => 'decimal:2',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function jobs()
    {
        return $this->hasMany(Job::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function media()
    {
        return $this->morphMany(Media::class, 'model');
    }
}
