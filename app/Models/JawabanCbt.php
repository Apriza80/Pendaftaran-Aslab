<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class JawabanCbt extends Model
{
    public function ujianCbt()
    {
        return $this->belongsTo(UjianCbt::class);
    }

    public function soalCbt()
    {
        return $this->belongsTo(SoalCbt::class);
    }
}