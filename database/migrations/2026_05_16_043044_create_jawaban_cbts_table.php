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
        Schema::create('jawaban_cbts', function (Blueprint $table) {
            $table->id();

            $table->foreignId('ujian_cbt_id')
                ->constrained()
                ->onDelete('cascade');

            $table->foreignId('soal_cbt_id')
                ->constrained()
                ->onDelete('cascade');

            $table->char('jawaban_pengguna', 1);

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jawaban_cbts');
    }
};