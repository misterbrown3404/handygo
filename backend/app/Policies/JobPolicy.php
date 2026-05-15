<?php

namespace App\Policies;

use App\Models\Job;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class JobPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return true; // Filtering is handled in the controller
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Job $job): bool
    {
        if ($user->hasRole(['admin', 'staff'])) return true;
        
        return $user->customer?->id === $job->customer_id || 
               $user->worker?->id === $job->worker_id;
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return $user->hasRole('customer');
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Job $job): bool
    {
        if ($user->hasRole(['admin', 'staff'])) return true;

        return $user->customer?->id === $job->customer_id || 
               $user->worker?->id === $job->worker_id;
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Job $job): bool
    {
        return $user->hasRole('admin');
    }
}
