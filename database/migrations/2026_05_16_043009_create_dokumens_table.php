<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('dokumens', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->string('file_cv')->nullable();
            $table->string('file_ktm')->nullable();
            $table->string('file_foto')->nullable();
            $table->string('file_ijazah')->nullable();
            $table->string('file_ss_ig')->nullable();
            $table->string('file_project')->nullable();

            $table->text('deskripsi_project')->nullable();

            $table->string('link_github')->nullable();
            $table->string('link_linkedin')->nullable();
            $table->string('link_portfolio')->nullable();

            $table->enum('status_verifikasi', [
                'pending',
                'lolos',
                'ditolak'
            ])->default('pending');

            $table->text('catatan_admin')->nullable();

            $table->foreignId('admin_id')
                ->nullable()
                ->constrained()
                ->nullOnDelete();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dokumens');
    }
};