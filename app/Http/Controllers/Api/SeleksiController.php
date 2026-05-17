<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Seleksi;

class SeleksiController extends Controller
{

    public function updateStatus(Request $request)
    {

        $seleksi = Seleksi::updateOrCreate(

            [
                'user_id' => $request->user_id
            ],

            [
                'status_seleksi' => $request->status_seleksi,
                'keterangan' => $request->keterangan
            ]

        );

        return response()->json([
            'success' => true,
            'message' => 'Status seleksi berhasil diupdate',
            'data' => $seleksi
        ]);
    }

}