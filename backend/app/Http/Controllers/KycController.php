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
        $submissions = KycSubmission::with('user')
            ->when($request->status, function($q, $status) {
                $q->where('status', $status);
            })
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'message' => 'KYC submissions retrieved',
            'data' => KycSubmissionResource::collection($submissions)->response()->getData(true)
        ]);
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

        // Delete existing pending submissions for this user to avoid duplicates
        KycSubmission::where('user_id', Auth::id())->where('status', 'pending')->delete();

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

        return response()->json([
            'success' => true,
            'message' => 'KYC submitted successfully',
            'data' => new KycSubmissionResource($submission)
        ]);
    }

    /**
     * Approve KYC (Admin).
     */
    public function approve(Request $request, $id)
    {
        $submission = KycSubmission::findOrFail($id);
        $submission->update([
            'status' => 'approved',
            'reviewed_by' => Auth::id(),
            'reviewed_at' => now(),
        ]);

        // Update worker status to active upon approval
        if ($submission->user && $submission->user->worker) {
            $submission->user->worker->update(['status' => 'active']);
        }

        return response()->json([
            'success' => true,
            'message' => 'KYC submission approved',
            'data' => new KycSubmissionResource($submission)
        ]);
    }

    /**
     * Reject KYC (Admin).
     */
    public function reject(Request $request, $id)
    {
        $request->validate(['rejection_reason' => 'required|string']);

        $submission = KycSubmission::findOrFail($id);
        $submission->update([
            'status' => 'rejected',
            'rejection_reason' => $request->rejection_reason,
            'reviewed_by' => Auth::id(),
            'reviewed_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'KYC submission rejected',
            'data' => new KycSubmissionResource($submission)
        ]);
    }
}
