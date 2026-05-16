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
        Schema::create('seleksis', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->enum('status_seleksi', [
                'Administrasi',
                'CBT',
                'Wawancara',
                'Final Lolos',
                'Final Gagal'
            ]);

            $table->text('keterangan')->nullable();

            $table->timestamp('tanggal_update')
                ->useCurrent()
                ->useCurrentOnUpdate();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('seleksis');
    }
};