<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use App\Models\User;
use App\Models\Service;
use App\Models\Customer;
use App\Models\Worker;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create Roles
        Role::create(['name' => 'admin']);
        Role::create(['name' => 'staff']);
        Role::create(['name' => 'worker']);
        Role::create(['name' => 'customer']);

        // 2. Create Admin
        $admin = User::create([
            'name' => 'HandyGo Admin',
            'email' => 'admin@handygo.ng',
            'password' => Hash::make('password'),
            'role' => 'admin',
        ]);
        $admin->assignRole('admin');

        // 3. Create Services
        $services = [
            ['name' => 'Plumbing', 'category' => 'Home Maintenance', 'icon' => 'plumbing', 'base_price' => 5000],
            ['name' => 'Electrical', 'category' => 'Home Maintenance', 'icon' => 'electrical_services', 'base_price' => 4500],
            ['name' => 'AC Technician', 'category' => 'Appliances', 'icon' => 'ac_unit', 'base_price' => 7000],
            ['name' => 'Cleaning', 'category' => 'Cleaning', 'icon' => 'cleaning_services', 'base_price' => 3000],
            ['name' => 'Carpentry', 'category' => 'Home Maintenance', 'icon' => 'carpenter', 'base_price' => 5500],
        ];

        foreach ($services as $s) {
            Service::create($s);
        }

        // 4. Create dummy customer
        $customerUser = User::create([
            'name' => 'Tunde Adekunle',
            'email' => 'customer@example.com',
            'phone' => '08012345678',
            'password' => Hash::make('password'),
            'role' => 'customer',
        ]);
        $customerUser->assignRole('customer');
        Customer::create([
            'user_id' => $customerUser->id,
            'name' => $customerUser->name,
            'email' => $customerUser->email,
            'phone' => $customerUser->phone,
            'address' => '123 Victoria Island, Lagos',
            'lat' => 6.4281,
            'lng' => 3.4219,
        ]);

        // 5. Create dummy worker
        $workerUser = User::create([
            'name' => 'Ibrahim Musa',
            'email' => 'worker@example.com',
            'phone' => '08087654321',
            'password' => Hash::make('password'),
            'role' => 'worker',
        ]);
        $workerUser->assignRole('worker');
        Worker::create([
            'user_id' => $workerUser->id,
            'name' => $workerUser->name,
            'email' => $workerUser->email,
            'phone' => $workerUser->phone,
            'specialty' => 'Plumbing',
            'status' => 'active',
            'is_available' => true,
            'rating' => 4.8,
            'address' => '45 Lekki Phase 1, Lagos',
            'lat' => 6.4474,
            'lng' => 3.4723,
        ]);
    }
}
