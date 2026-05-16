<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Profil;

class ProfilController extends Controller
{
    public function store(Request $request)
    {
        $profil = Profil::create([

            'user_id' => $request->user_id,
            'nim' => $request->nim,
            'kelas' => $request->kelas,
            'jenis_kelamin' => $request->jenis_kelamin,
            'tempat_lahir' => $request->tempat_lahir,
            'tanggal_lahir' => $request->tanggal_lahir,
            'alamat_lengkap' => $request->alamat_lengkap,
            'tahun_kelulusan' => $request->tahun_kelulusan,
            'alasan_daftar' => $request->alasan_daftar

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil dibuat',
            'data' => $profil
        ]);
    }
}