<?php

namespace App\Http\Controllers;

use App\Models\Media;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class MediaController extends Controller
{
    /**
     * Upload a file and return the path/url.
     */
    public function upload(Request $request)
    {
        $request->validate([
            'file' => 'required|file|max:5120', // 5MB max
            'collection' => 'nullable|string',
            'model_type' => 'nullable|string',
            'model_id' => 'nullable|integer',
        ]);

        $file = $request->file('file');
        $disk = config('filesystems.default');
        
        $filename = Str::random(40) . '.' . $file->getClientOriginalExtension();
        $path = $file->storeAs('uploads', $filename, $disk);
        $url = Storage::disk($disk)->url($path);

        $media = Media::create([
            'model_type' => $request->model_type,
            'model_id' => $request->model_id,
            'disk' => $disk,
            'path' => $path,
            'url' => $url,
            'mime_type' => $file->getMimeType(),
            'size' => $file->getSize(),
            'collection' => $request->collection,
        ]);

        return response()->json([
            'id' => $media->id,
            'url' => $url,
            'path' => $path,
        ]);
    }

    /**
     * Delete media and its file.
     */
    public function destroy($id)
    {
        $media = Media::findOrFail($id);
        
        // Delete physical file
        Storage::disk($media->disk)->delete($media->path);
        
        // Delete database record
        $media->delete();

        return response()->json(['message' => 'Media deleted successfully']);
    }
}
