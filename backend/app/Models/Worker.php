<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Subscription;

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

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }

    /**
     * Get the latest active subscription.
     */
    public function activeSubscription()
    {
        return $this->hasOne(Subscription::class)
            ->where('status', 'active')
            ->where('expires_at', '>', now())
            ->latest();
    }

    /**
     * Scope: Only workers with an active subscription (visible to customers).
     */
    public function scopeSubscribed($query)
    {
        return $query->whereHas('subscriptions', function ($q) {
            $q->where('status', 'active')
              ->where('expires_at', '>', now());
        });
    }

    /**
     * Check if worker has an active subscription.
     */
    public function getHasActiveSubscriptionAttribute(): bool
    {
        return $this->subscriptions()
            ->where('status', 'active')
            ->where('expires_at', '>', now())
            ->exists();
    }

    protected $appends = ['has_active_subscription'];
}
