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
        Schema::create('ujian_cbts', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->dateTime('tanggal_ujian')
                ->useCurrent();

            $table->decimal('nilai', 5, 2)->nullable();

            $table->enum('status_ujian', [
                'Selesai',
                'Belum Selesai'
            ])->default('Selesai');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ujian_cbts');
    }
};