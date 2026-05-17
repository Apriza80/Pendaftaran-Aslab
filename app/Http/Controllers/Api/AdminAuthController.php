<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AdminAuthController extends Controller
{

    public function register(Request $request)
    {

        $validator = Validator::make($request->all(), [

            'nama' => 'required',
            'email' => 'required|email|unique:admins,email',
            'password' => 'required|min:6'

        ]);

        if ($validator->fails()) {

            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $admin = Admin::create([

            'nama' => $request->nama,
            'email' => $request->email,
            'password' => Hash::make($request->password)

        ]);

        return response()->json([
            'success' => true,
            'message' => 'Admin berhasil register',
            'data' => $admin
        ]);
    }

    public function login(Request $request)
    {

        $admin = Admin::where('email', $request->email)->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {

            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah'
            ], 401);
        }

        return response()->json([
            'success' => true,
            'message' => 'Login admin berhasil',
            'data' => $admin
        ]);
    }

}