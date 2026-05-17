<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    public function dokumens()
    {
        return $this->hasMany(Dokumen::class);
    }

    public function soalCbts()
    {
        return $this->hasMany(SoalCbt::class);
    }

    public function wawancaras()
    {
        return $this->hasMany(Wawancara::class);
    }
    protected $fillable = [
        'nama',
        'email',
        'password'
    ];
}