import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  // ===================================================================
  // DATA DARI BACKEND (Sesuai Struktur Request Orisinal)
  // ===================================================================
  final String _namaPendaftar = "Mahasiswa UMSIDA"; // 1. Nama
  final String _tanggalWawancara =
      "Senin, 28 April 2026"; // 2. Jadwal (Tanggal)
  final String _jamWawancara = "09:00 - 10:00 WIB"; // 2. Jadwal (Jam)
  final String _lokasiWawancara = "Lab Komputer 2 (Gedung G)"; // 3. Lokasi
  final String _linkMeeting =
      "https://meet.google.com/umsida-aslab"; // 4. Link meeting
  final String _hasilKelulusan = "LOLOS"; // 5. Hasil
  final String _catatanAdmin =
      "Harap membawa cetak Kartu Ujian dan CV fisik saat wawancara offline. Datang 15 menit sebelum jadwal."; // 6. Catatan

  // DATA DUMMY: Hasil Nilai Akhir CBT & Wawancara
  final int _skorCbt = 85;
  final int _skorWawancara = 90;
  final String _gradeAkhir = "A";

  @override
  Widget build(BuildContext context) {
    // Pengkondisian skema warna berdasarkan "Hasil" dari backend
    bool isLolos = _hasilKelulusan == "LOLOS";
    Color statusColor = isLolos ? Colors.green : Colors.orange;
    Color statusBgColor = isLolos
        ? Colors.green.shade50
        : Colors.orange.shade50;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Jadwal & Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status Kelulusan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // ================== CARD STATUS + NAMA (Poin 1 & 5) ==================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        isLolos ? Icons.check_circle : Icons.pending,
                        color: statusColor,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLolos ? "SELAMAT!" : "PROSES SELEKSI",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              isLolos
                                  ? "Anda dinyatakan LOLOS tahap CBT. Silakan ikuti wawancara sesuai jadwal."
                                  : "Berkas dan nilai ujian Anda sedang ditinjau kembali oleh tim penguji.",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 25, thickness: 1),
                  Row(
                    children: [
                      const Text(
                        "Nama Peserta: ",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      Text(
                        _namaPendaftar,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Detail Wawancara",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // ================== CARD INFO JADWAL & LOKASI (Poin 2 & 3) ==================
            _buildJadwalCard(
              title: "Waktu Wawancara",
              subtitle: _tanggalWawancara,
              trailing: _jamWawancara,
              icon: Icons.access_time,
            ),
            const SizedBox(height: 10),
            _buildJadwalCard(
              title: "Lokasi / Media",
              subtitle: _lokasiWawancara,
              trailing: "Lihat Map",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 10),

            // ================== CARD LINK MEETING (Poin 4) ==================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.video_call,
                  color: Colors.blue,
                  size: 30,
                ),
                title: const Text(
                  "Link Meeting (Opsional)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: Text(
                  _linkMeeting,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),

            // ===================================================================
            // POSISI BARU: KETERANGAN HASIL NILAI CBT & WAWANCARA (DIBAWAH LINK MEETING)
            // ===================================================================
            if (isLolos) ...[
              const SizedBox(height: 25),
              const Text(
                "Keterangan Hasil Nilai",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Nilai CBT
                    Column(
                      children: [
                        const Text(
                          "Skor CBT",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$_skorCbt",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    // Nilai Wawancara
                    Column(
                      children: [
                        const Text(
                          "Wawancara",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$_skorWawancara",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    // Hasil Grade Akhir
                    Column(
                      children: [
                        const Text(
                          "Hasil Akhir",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Grade $_gradeAkhir",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 25),

            // ================== CARD CATATAN ADMIN (Poin 6) ==================
            if (_catatanAdmin.isNotEmpty) ...[
              const Text(
                "Catatan Tambahan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _catatanAdmin,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper Widget bawaan yang sudah diaktifkan fitur klik "Lihat Map"
  Widget _buildJadwalCard({
    required String title,
    required String subtitle,
    required String trailing,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          trailing == "Lihat Map"
              ? TextButton(
                  onPressed: () async {
                    const String googleMapsUrl = "https://maps.google.com";
                    final Uri url = Uri.parse(googleMapsUrl);

                    if (await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      await launchUrl(url);
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Tidak dapat membuka Google Maps"),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    trailing,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
        ],
      ),
    );
  }
}
