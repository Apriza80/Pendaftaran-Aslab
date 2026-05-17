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
    protected $fillable = [
        'pertanyaan',
        'opsi_a',
        'opsi_b',
        'opsi_c',
        'opsi_d',
        'jawaban_benar',
        'admin_id'
    ];
}