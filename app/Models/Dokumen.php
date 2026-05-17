<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Dokumen extends Model
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
        'file_cv',
        'file_ktm',
        'file_foto',
        'file_ijazah',
        'file_ss_ig',
        'file_project',
        'deskripsi_project',
        'link_github',
        'link_linkedin',
        'link_portfolio',
        'status_verifikasi',
        'catatan_admin',
        'admin_id'
    ];
}
