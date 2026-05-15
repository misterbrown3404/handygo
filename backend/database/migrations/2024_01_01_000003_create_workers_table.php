<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->string('email')->unique()->nullable();
            $table->string('phone', 20)->nullable();
            $table->text('address')->nullable();
            $table->decimal('lat', 10, 7)->nullable();
            $table->decimal('lng', 10, 7)->nullable();
            $table->string('avatar')->nullable();
            $table->string('specialty')->nullable();
            $table->enum('status', ['active', 'inactive', 'suspended'])->default('inactive');
            $table->boolean('is_available')->default(false);
            $table->decimal('rating', 3, 2)->default(0.00);
            $table->unsignedInteger('total_jobs')->default(0);
            $table->decimal('wallet_balance', 12, 2)->default(0.00);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workers');
    }
};
