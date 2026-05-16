<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfilController;


Route::post('/register', [AuthController::class, 'register']);

Route::post('/login', [AuthController::class, 'login']);

Route::post('/profil', [ProfilController::class, 'store']);

Route::get('/profil/{id}', [ProfilController::class, 'show']);

Route::put('/profil/{id}', [ProfilController::class, 'update']);