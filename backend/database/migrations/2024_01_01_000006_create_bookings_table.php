<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('worker_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('service_id')->constrained()->cascadeOnDelete();
            $table->datetime('scheduled_at');
            $table->enum('status', [
                'pending',
                'accepted',
                'declined',
                'in_progress',
                'completed',
                'cancelled'
            ])->default('pending');
            $table->text('notes')->nullable();
            $table->text('address')->nullable();
            $table->decimal('lat', 10, 7)->nullable();
            $table->decimal('lng', 10, 7)->nullable();
            $table->decimal('amount', 12, 2)->nullable();
            $table->decimal('platform_fee', 12, 2)->nullable();
            $table->decimal('worker_payout', 12, 2)->nullable();
            $table->unsignedTinyInteger('rating')->nullable();
            $table->text('review')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'scheduled_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
