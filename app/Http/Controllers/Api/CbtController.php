<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SoalCbt;
use App\Models\Seleksi;

class CbtController extends Controller
{

    public function storeSoal(Request $request)
    {

        $soal = SoalCbt::create([

            'pertanyaan' => $request->pertanyaan,
            'opsi_a' => $request->opsi_a,
            'opsi_b' => $request->opsi_b,
            'opsi_c' => $request->opsi_c,
            'opsi_d' => $request->opsi_d,
            'jawaban_benar' => $request->jawaban_benar,
            'admin_id' => $request->admin_id

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Soal berhasil ditambahkan',
            'data' => $soal
        ]);
    }
    public function getSoal($user_id)
    {

        $seleksi = Seleksi::where('user_id', $user_id)->first();

        if (!$seleksi || $seleksi->status_seleksi != 'CBT') {

            return response()->json([
                'success' => false,
                'message' => 'Anda belum bisa mengakses CBT'
            ], 403);
        }

        $soal = SoalCbt::all();

        return response()->json([
            'success' => true,
            'status_user' => $seleksi->status_seleksi,
            'data' => $soal
        ]);
    }

}