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
        Schema::create('wawancaras', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->dateTime('jadwal');

            $table->string('lokasi')->nullable();

            $table->string('link_meeting')->nullable();

            $table->enum('hasil', [
                'Proses',
                'Lolos',
                'Tidak Lolos'
            ])->default('Proses');

            $table->text('catatan')->nullable();

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
        Schema::dropIfExists('wawancaras');
    }
};  