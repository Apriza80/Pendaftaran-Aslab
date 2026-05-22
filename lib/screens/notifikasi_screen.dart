import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  final String statusSeleksi; // Menerima status seleksi langsung dari Dashboard
  final String keteranganSeleksi; // Menerima keterangan dari Dashboard

  const NotifikasiScreen({
    super.key,
    required this.statusSeleksi,
    required this.keteranganSeleksi,
  });

  // Fungsi generator notifikasi otomatis sesuai logika final Meiko
  List<Map<String, String>> _generateNotifikasiOtomatis() {
    List<Map<String, String>> listNotif = [];

    String statusSistem = statusSeleksi.toLowerCase();

    // 1. KONDISI AWAL: Jika baru registrasi akun dan belum di-action oleh admin (Status: pending)
    if (statusSistem == 'pending') {
      listNotif.add({
        "judul": "Registrasi Akun Berhasil",
        "pesan":
            "Akun Anda berhasil aktif di sistem seleksi UMSIDA. Silakan masuk ke menu 'Isi Formulir Pendaftaran' untuk melengkapi biodata dan mengunggah berkas administrasi Anda.",
      });
    }

    // 2. KONDISI DISETUJUI: Jika admin klik "Setujui", status naik ke 'cbt', 'wawancara', atau 'lolos'
    if (statusSistem == 'cbt' ||
        statusSistem == 'wawancara' ||
        statusSistem == 'lolos') {
      // Notif pendaftaran berhasil & berkas diterima baru dimunculkan di sini
      listNotif.add({
        "judul": "Pendaftaran Berhasil",
        "pesan":
            "Berkas administrasi pendaftaran Anda telah kami terima dan diverifikasi oleh sistem.",
      });

      // Ditumpuk dengan notif instruksi CBT di atasnya
      listNotif.insert(0, {
        "judul": "Lolos Administrasi",
        "pesan":
            "Selamat, Anda dinyatakan lolos tahap verifikasi administrasi! Silakan unduh/cetak kartu peserta ujian Anda di dashboard dan ikuti Ujian Online (Test CBT) sesuai jadwal.",
      });
    }

    // 3. KONDISI LOLOS CBT: Status naik ke 'wawancara' atau 'lolos'
    if (statusSistem == 'wawancara' || statusSistem == 'lolos') {
      listNotif.insert(0, {
        "judul": "Jadwal Wawancara",
        "pesan":
            "Selamat, Anda berhasil lolos ujian CBT! Tahapan selanjutnya adalah tes wawancara tatap muka yang dilaksanakan pada tanggal 25 Mei jam 09.00 WIB di Ruang Laboratorium Informatika.",
      });
    }

    // 4. KONDISI FINAL LOLOS: Status jadi 'lolos'
    if (statusSistem == 'lolos') {
      listNotif.insert(0, {
        "judul": "Pengumuman Akhir (Lolos)",
        "pesan":
            "Selamat! Anda dinyatakan lulus seleksi akhir dan resmi bergabung menjadi bagian dari Asisten Laboratorium Informatika UMSIDA. Silakan cek menu jadwal berkala untuk pengarahan perdana.",
      });
    }

    // 5. KONDISI DITOLAK: Jika admin mengklik tombol "Tolak" (Status: tidak lolos)
    if (statusSistem == 'tidak lolos') {
      listNotif.add({
        "judul": "Pengumuman Seleksi",
        "pesan":
            "Terma kasih telah mengikuti rangkaian seleksi Asisten Laboratorium Informatika tahun ini. Mohon maaf, berkas berkas atau akumulasi nilai ujian Anda belum memenuhi prasyarat kelulusan. Jangan berkecil hati dan tetap semangat!",
      });
    }

    return listNotif;
  }

  @override
  Widget build(BuildContext context) {
    final daftarNotifikasi = _generateNotifikasiOtomatis();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Pemberitahuan"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: daftarNotifikasi.length,
        itemBuilder: (context, index) {
          final notif = daftarNotifikasi[index];

          bool isLolos =
              notif['judul']!.contains('Lolos') ||
              notif['judul']!.contains('Berhasil') ||
              notif['judul']!.contains('Jadwal');
          bool isGagal =
              notif['judul']!.contains('Tidak') ||
              notif['judul']!.contains('Mohon Maaf');

          return Card(
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: isLolos && !isGagal
                    ? Colors.green.shade50
                    : (isGagal ? Colors.red.shade50 : const Color(0xFFE3F2FD)),
                child: Icon(
                  isLolos && !isGagal
                      ? Icons.check_circle_rounded
                      : (isGagal
                            ? Icons.cancel_rounded
                            : Icons.campaign_rounded),
                  color: isLolos && !isGagal
                      ? Colors.green
                      : (isGagal ? Colors.red : const Color(0xFF0D47A1)),
                ),
              ),
              title: Text(
                notif['judul']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                "Ketuk untuk melihat detail pesan",
                style: TextStyle(fontSize: 11),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    top: 4,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notif['pesan']!,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
