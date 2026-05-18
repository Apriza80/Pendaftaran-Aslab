<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Wawancara extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function admin()
    {
        return $this->belongsTo(Admin::class);
    }
    protected $fillable = [
        'user_id',
        'jadwal',
        'lokasi',
        'link_meeting',
        'hasil',
        'catatan',
        'admin_id'
    ];
}