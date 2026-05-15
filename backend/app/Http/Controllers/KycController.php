<?php

namespace App\Http\Controllers;

use App\Models\KycSubmission;
use Illuminate\Http\Request;
use App\Http\Resources\KycSubmissionResource;
use Illuminate\Support\Facades\Auth;

class KycController extends Controller
{
    /**
     * List KYC submissions (Admin only).
     */
    public function index(Request $request)
    {
        $this->authorize('viewAny', KycSubmission::class);
        
        $submissions = KycSubmission::with('user')
            ->when($request->status, function($q, $status) {
                $q->where('status', $status);
            })
            ->latest()
            ->paginate(20);

        return KycSubmissionResource::collection($submissions);
    }

    /**
     * Submit KYC details (Worker).
     */
    public function submit(Request $request)
    {
        $request->validate([
            'nin' => 'required|string|size:11',
            'bvn' => 'required|string|size:11',
            'document_type' => 'required|string',
            'document_front' => 'required|string', // Path/URL
            'document_back' => 'nullable|string',
            'selfie' => 'required|string',
        ]);

        $submission = KycSubmission::create([
            'user_id' => Auth::id(),
            'nin' => $request->nin,
            'bvn' => $request->bvn,
            'document_type' => $request->document_type,
            'document_front' => $request->document_front,
            'document_back' => $request->document_back,
            'selfie' => $request->selfie,
            'status' => 'pending',
        ]);

        return new KycSubmissionResource($submission);
    }

    /**
     * Approve KYC (Admin).
     */
    public function approve(Request $request, $id)
    {
        $this->authorize('update', KycSubmission::class);
        
        $submission = KycSubmission::findOrFail($id);
        $submission->update([
            'status' => 'approved',
            'reviewed_by' => Auth::id(),
            'reviewed_at' => now(),
        ]);

        // Update worker status to active upon approval
        $submission->user->worker()->update(['status' => 'active']);

        return new KycSubmissionResource($submission);
    }

    /**
     * Reject KYC (Admin).
     */
    public function reject(Request $request, $id)
    {
        $this->authorize('update', KycSubmission::class);
        
        $request->validate(['rejection_reason' => 'required|string']);

        $submission = KycSubmission::findOrFail($id);
        $submission->update([
            'status' => 'rejected',
            'rejection_reason' => $request->rejection_reason,
            'reviewed_by' => Auth::id(),
            'reviewed_at' => now(),
        ]);

        return new KycSubmissionResource($submission);
    }
}
