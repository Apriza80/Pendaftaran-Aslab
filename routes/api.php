<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfilController;
use App\Http\Controllers\Api\DokumenController;
use App\Http\Controllers\Api\AdminAuthController;
use App\Http\Controllers\Api\CbtController;
use App\Http\Controllers\Api\SeleksiController;
use App\Http\Controllers\Api\WawancaraController;


Route::post('/register', [AuthController::class, 'register']);

Route::post('/login', [AuthController::class, 'login']);

Route::post('/profil', [ProfilController::class, 'store']);

Route::get('/profil/{id}', [ProfilController::class, 'show']);

Route::put('/profil/{id}', [ProfilController::class, 'update']);

Route::post('/dokumen', [DokumenController::class, 'store']);

Route::post('/admin/register', [AdminAuthController::class, 'register']);
Route::post('/admin/login', [AdminAuthController::class, 'login']);

Route::post('/soal', [CbtController::class, 'storeSoal']);
Route::get('/soal/{user_id}', [CbtController::class, 'getSoal']);

Route::post('/seleksi', [SeleksiController::class, 'updateStatus']);

Route::post('/wawancara', [WawancaraController::class, 'store']);
Route::get('/wawancara/{user_id}', [WawancaraController::class, 'show']);