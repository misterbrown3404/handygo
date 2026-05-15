<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'category',
        'description',
        'icon',
        'base_price',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'base_price' => 'decimal:2',
    ];

    public function jobs()
    {
        return $this->hasMany(Job::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}
