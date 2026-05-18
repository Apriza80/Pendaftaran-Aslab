<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Wawancara;

class WawancaraController extends Controller
{

    // ADMIN buat jadwal wawancara
    public function store(Request $request)
    {

        $wawancara = Wawancara::create([

            'user_id' => $request->user_id,
            'jadwal' => $request->jadwal,
            'lokasi' => $request->lokasi,
            'link_meeting' => $request->link_meeting,
            'hasil' => 'Proses',
            'catatan' => $request->catatan,
            'admin_id' => $request->admin_id

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Jadwal wawancara berhasil dibuat',
            'data' => $wawancara
        ]);
    }

    // USER lihat jadwal wawancara
    public function show($user_id)
    {

        $wawancara = Wawancara::where('user_id', $user_id)->first();

        if (!$wawancara) {

            return response()->json([
                'success' => false,
                'message' => 'Jadwal wawancara belum tersedia'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $wawancara
        ]);
    }

}