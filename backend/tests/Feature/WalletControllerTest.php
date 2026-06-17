<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Worker;
use App\Models\Job;
use App\Models\Service;
use App\Models\Customer;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class WalletControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function createWorker(): User
    {
        $user = User::create([
            'name' => 'Test Worker',
            'email' => 'worker@test.com',
            'phone' => '08012345678',
            'password' => Hash::make('password123'),
            'role' => 'worker',
            'is_active' => true,
        ]);
        $user->assignRole('worker');
        Worker::create([
            'user_id' => $user->id,
            'name' => 'Test Worker',
            'email' => 'worker@test.com',
            'phone' => '08012345678',
            'status' => 'active',
            'is_available' => true,
            'wallet_balance' => 5000.00,
        ]);
        return $user;
    }

    protected function createCustomer(): User
    {
        $user = User::create([
            'name' => 'Test Customer',
            'email' => 'customer@test.com',
            'phone' => '08012345679',
            'password' => Hash::make('password123'),
            'role' => 'customer',
            'is_active' => true,
        ]);
        $user->assignRole('customer');
        Customer::create([
            'user_id' => $user->id,
            'name' => 'Test Customer',
            'email' => 'customer@test.com',
            'phone' => '08012345679',
        ]);
        return $user;
    }

    public function test_balance_returns_correct_format(): void
    {
        $user = $this->createWorker();
        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->getJson('/api/v1/wallet/balance', [
            'Authorization' => 'Bearer ' . $token,
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data' => ['balance', 'total_earned']]);
    }

    public function test_balance_returns_forbidden_for_customer(): void
    {
        $user = $this->createCustomer();
        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->getJson('/api/v1/wallet/balance', [
            'Authorization' => 'Bearer ' . $token,
        ]);

        $response->assertStatus(403)
            ->assertJson(['success' => false, 'message' => 'Not a worker']);
    }

    public function test_transactions_returns_correct_format(): void
    {
        $user = $this->createWorker();
        $token = $user->createToken('auth_token')->plainTextToken;
        $customer = $this->createCustomer();
        $service = Service::create(['name' => 'Test', 'category' => 'Test', 'base_price' => 10000]);

        Job::create([
            'job_id' => 'JOB-001',
            'customer_id' => $customer->id,
            'worker_id' => $user->worker->id,
            'service_id' => $service->id,
            'amount' => 10000,
            'worker_payout' => 8000,
            'status' => 'completed',
        ]);

        $response = $this->getJson('/api/v1/wallet/transactions', [
            'Authorization' => 'Bearer ' . $token,
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'message', 'data']);
    }

    public function test_withdraw_validates_fields(): void
    {
        $user = $this->createWorker();
        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->postJson('/api/v1/wallet/withdraw', [], [
            'Authorization' => 'Bearer ' . $token,
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['amount', 'bank_name', 'account_number', 'account_name']);
    }

    public function test_withdraw_validates_minimum_amount(): void
    {
        $user = $this->createWorker();
        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->postJson('/api/v1/wallet/withdraw', [
            'amount' => 500,
            'bank_name' => 'GTBank',
            'account_number' => '1234567890',
            'account_name' => 'Test User',
        ], ['Authorization' => 'Bearer ' . $token]);

        $response->assertStatus(422);
    }

    public function test_withdraw_fails_for_insufficient_balance(): void
    {
        $user = $this->createWorker();
        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->postJson('/api/v1/wallet/withdraw', [
            'amount' => 10000,
            'bank_name' => 'GTBank',
            'account_number' => '1234567890',
            'account_name' => 'Test User',
        ], ['Authorization' => 'Bearer ' . $token]);

        $response->assertStatus(400)
            ->assertJson(['success' => false, 'message' => 'Insufficient balance']);
    }
}