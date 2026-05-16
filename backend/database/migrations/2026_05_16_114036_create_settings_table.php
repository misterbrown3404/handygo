<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->string('group')->default('general');
            $table->timestamps();
        });

        // Seed initial settings
        DB::table('settings')->insert([
            ['key' => 'platform_name', 'value' => 'HandyGo', 'group' => 'general', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'commission_rate', 'value' => '15', 'group' => 'commission', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'min_withdrawal', 'value' => '5000', 'group' => 'commission', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'push_notifications_enabled', 'value' => '1', 'group' => 'notifications', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'email_notifications_enabled', 'value' => '1', 'group' => 'notifications', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('settings');
    }
};
