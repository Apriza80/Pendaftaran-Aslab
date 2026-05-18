<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Notifikasi;

class NotifikasiController extends Controller
{

    // ADMIN kirim notif
    public function store(Request $request)
    {

        $notif = Notifikasi::create([

            'user_id' => $request->user_id,
            'judul' => $request->judul,
            'pesan' => $request->pesan,
            'status_baca' => false

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi berhasil dikirim',
            'data' => $notif
        ]);
    }

    // USER lihat notif
    public function getNotif($user_id)
    {

        $notif = Notifikasi::where('user_id', $user_id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $notif
        ]);
    }

}