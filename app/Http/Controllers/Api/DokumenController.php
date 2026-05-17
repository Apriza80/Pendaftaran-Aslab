<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Dokumen;

class DokumenController extends Controller
{
    public function store(Request $request)
    {

        $cv = null;
        $ktm = null;

        if ($request->hasFile('file_cv')) {

            $cv = time().'_cv.'.$request->file_cv->extension();

            $request->file_cv->move(public_path('dokumen/cv'), $cv);
        }

        if ($request->hasFile('file_ktm')) {

            $ktm = time().'_ktm.'.$request->file_ktm->extension();

            $request->file_ktm->move(public_path('dokumen/ktm'), $ktm);
        }

        $dokumen = Dokumen::create([

            'user_id' => $request->user_id,

            'file_cv' => $cv,
            'file_ktm' => $ktm,

            'deskripsi_project' => $request->deskripsi_project,
            'link_github' => $request->link_github,
            'link_linkedin' => $request->link_linkedin,
            'link_portfolio' => $request->link_portfolio

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Dokumen berhasil diupload',
            'data' => $dokumen
        ]);
    }
}