<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Seleksi extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    protected $fillable = [
        'user_id',
        'status_seleksi',
        'keterangan'
    ];
}