<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notifikasi extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}