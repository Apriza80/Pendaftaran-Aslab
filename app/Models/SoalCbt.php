<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SoalCbt extends Model
{
    public function admin()
    {
        return $this->belongsTo(Admin::class);
    }

    public function jawabanCbts()
    {
        return $this->hasMany(JawabanCbt::class);
    }
}