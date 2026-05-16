<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\Request;
use App\Http\Resources\CustomerResource;

class CustomerController extends Controller
{
    public function index()
    {
        $customers = Customer::paginate(20);
        return response()->json([
            'success' => true,
            'message' => 'Customers retrieved',
            'data' => CustomerResource::collection($customers)->response()->getData(true)
        ]);
    }

    public function show($id)
    {
        $customer = Customer::findOrFail($id);
        return response()->json([
            'success' => true,
            'message' => 'Customer details retrieved',
            'data' => new CustomerResource($customer)
        ]);
    }

    public function update(Request $request, $id)
    {
        $customer = Customer::findOrFail($id);
        $this->authorize('update', $customer);

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
            'address' => 'sometimes|string',
            'lat' => 'sometimes|numeric',
            'lng' => 'sometimes|numeric',
            'avatar' => 'sometimes|string',
        ]);

        $customer->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Customer updated successfully',
            'data' => new CustomerResource($customer)
        ]);
    }

    public function destroy($id)
    {
        $customer = Customer::findOrFail($id);
        $this->authorize('delete', $customer);
        $customer->delete();

        return response()->json([
            'success' => true,
            'message' => 'Customer deleted successfully'
        ]);
    }
}
