<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('jobs', function (Blueprint $table) {
            $table->id();
            $table->string('job_id')->unique();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('worker_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('service_id')->constrained()->cascadeOnDelete();
            $table->decimal('amount', 12, 2);
            $table->enum('status', [
                'pending',
                'assigned',
                'in_progress',
                'completed',
                'disputed',
                'cancelled'
            ])->default('pending');
            $table->date('date');
            $table->text('description')->nullable();
            $table->text('address')->nullable();
            $table->decimal('lat', 10, 7)->nullable();
            $table->decimal('lng', 10, 7)->nullable();
            $table->string('completion_photo')->nullable();
            $table->decimal('worker_payout', 12, 2)->nullable();
            $table->text('cancellation_reason')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'date']);
            $table->index('customer_id');
            $table->index('worker_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('jobs');
    }
};
