import 'package:flutter/material.dart';
import 'dart:async'; // WAJIB: Untuk mengaktifkan fungsi jalannya waktu Timer

class CbtScreen extends StatefulWidget {
  const CbtScreen({super.key});

  @override
  State<CbtScreen> createState() => _CbtScreenState();
}

class _CbtScreenState extends State<CbtScreen> {
  // Data Dummy Soal Tes CBT Aslab
  final List<Map<String, dynamic>> _daftarSoal = [
    {
      "pertanyaan":
          "Di bawah ini yang termasuk widget Layout di Flutter adalah...",
      "opsi": ["A. Column", "B. String", "C. Boolean", "D. Int"],
      "kunci": 0,
    },
    {
      "pertanyaan":
          "StatefulWidget digunakan ketika widget tersebut memerlukan...",
      "opsi": [
        "A. Struktur data statis",
        "B. Perubahan data dinamis",
        "C. Keamanan enkripsi",
        "D. Rendering gambar saja",
      ],
      "kunci": 1,
    },
    {
      "pertanyaan":
          "Perintah dasar untuk menjalankan aplikasi Flutter melalui terminal adalah...",
      "opsi": [
        "A. flutter build",
        "B. flutter doctor",
        "C. flutter run",
        "D. flutter upgrade",
      ],
      "kunci": 2,
    },
    {
      "pertanyaan":
          "Method utama yang wajib ada sebagai pintu masuk pertama program Dart/Flutter yaitu...",
      "opsi": ["A. runApp()", "B. main()", "C. build()", "D. initState()"],
      "kunci": 1,
    },
    {
      "pertanyaan":
          "File pubspec.yaml di dalam proyek Flutter digunakan untuk mengonfigurasi...",
      "opsi": [
        "A. Database lokal",
        "B. Package & Asset",
        "C. IP Server Backend",
        "D. Algoritma enkripsi",
      ],
      "kunci": 1,
    },
  ];

  int _indeksSoalAktif = 0; // Melacak nomor soal yang sedang dibuka
  Map<int, int> _jawabanPeserta = {}; // Menyimpan jawaban peserta

  // DETAIL TIMER AKTIF (Contoh durasi pengerjaan: 60 menit)
  late Timer _examTimer;
  int _remainingSeconds = 60 * 60;

  @override
  void initState() {
    super.initState();
    _startHitungMundur();
  }

  // Fungsi menjalankan detak jam mundur setiap 1 detik
  void _startHitungMundur() {
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _examTimer.cancel();
        _kumpulJawabanOtomatisWaktuHabis();
      }
    });
  }

  // Mengubah sisa detik menjadi format teks Jam:Menit:Detik (00:00:00)
  String _formatWaktu(int totalDetik) {
    int jam = totalDetik ~/ 3600;
    int menit = (totalDetik % 3600) ~/ 60;
    int detik = totalDetik % 60;

    String formatJam = jam.toString().padLeft(2, '0');
    String formatMenit = menit.toString().padLeft(2, '0');
    String formatDetik = detik.toString().padLeft(2, '0');

    return "$formatJam:$formatMenit:$formatDetik";
  }

  // Peringatan konfirmasi ketika pendaftar mencoba klik back/keluar aplikasi
  Future<bool> _tampilkanPeringatanKeluarUjian() async {
    bool? harusKeluar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text(
              "Peringatan Ujian!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: const Text(
          "Ujian CBT sedang berjalan aktif. Anda dilarang keluar halaman sebelum menyelesaikan kiriman jawaban!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Lanjutkan Tes",
              style: TextStyle(
                color: Color(0xFF0D47A1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return harusKeluar ?? false;
  }

  void _kumpulJawabanOtomatisWaktuHabis() {
    _examTimer.cancel();
    Navigator.pop(context); // Balik ke Dashboard Screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Waktu habis! Seluruh jawaban Anda otomatis terkirim."),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Fungsi berpindah nomor soal secara langsung
  void _lompatKeSoal(int indeksBaru) {
    setState(() {
      _indeksSoalAktif = indeksBaru;
    });
  }

  // Fungsi untuk memproses tombol Lanjut
  void _soalBerikutnya() {
    if (_indeksSoalAktif < _daftarSoal.length - 1) {
      setState(() {
        _indeksSoalAktif++;
      });
    }
  }

  // Fungsi Submit Akhir CBT
  void _kirimJawabanAkhir() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Selesai & Kirim?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Anda telah mengerjakan ${_jawabanPeserta.length} dari ${_daftarSoal.length} soal. Yakin ingin mengakhiri tes?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _examTimer.cancel(); // Matikan detak timer
              Navigator.pop(context); // Tutup dialog konfirmasi
              Navigator.pop(context); // Kembali pulang aman ke Dashboard Screen

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Selamat! Jawaban Tes CBT Anda berhasil disimpan.",
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
            ),
            child: const Text(
              "Ya, Kirim",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _examTimer.cancel(); // Amankan memori dari kebocoran stream timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> soalSekarang = _daftarSoal[_indeksSoalAktif];

    return PopScope(
      canPop: false, // Mencegat tombol back hardware fisik bawah HP pendaftar
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final mauKeluar = await _tampilkanPeringatanKeluarUjian();
        if (mauKeluar && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFD),
        // ================= HEADER UTAMA APPBAR =================
        appBar: AppBar(
          backgroundColor: const Color(0xFFEF5350), // Merah Cerah CBT
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed:
                _tampilkanPeringatanKeluarUjian, // Mencegat panah back AppBar atas
          ),
          title: const Text(
            "Test CBT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            // INTEGRASI DISPLAY TIMER REAL-TIME AKTIF
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_alarm_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _formatWaktu(_remainingSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Penunjuk progress soal
                    Text(
                      "Pertanyaan ${_indeksSoalAktif + 1} dari ${_daftarSoal.length}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Teks Soal Pertanyaan
                    Text(
                      soalSekarang["pertanyaan"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ================= PILIHAN GANDA (A, B, C, D) =================
                    Column(
                      children: List.generate(soalSekarang["opsi"].length, (
                        index,
                      ) {
                        final bool isSelected =
                            _jawabanPeserta[_indeksSoalAktif] == index;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0D47A1).withOpacity(0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D47A1)
                                  : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _jawabanPeserta[_indeksSoalAktif] = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Text(
                                soalSekarang["opsi"][index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF0D47A1)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),

                    // ================= PERBAIKAN: SCROLL HORIZONTAL NAVIGASI NOMOR SOAL =================
                    const Divider(height: 30),
                    const Text(
                      "Navigasi Soal",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, // Arah geser kanan-kiri elastis bebas overflow
                      child: Row(
                        children: List.generate(_daftarSoal.length, (index) {
                          final bool isCurrent = _indeksSoalAktif == index;
                          final bool isAnswered = _jawabanPeserta.containsKey(
                            index,
                          );

                          Color boxColor = Colors.white;
                          Color textColor = Colors.black87;
                          Color borderColor = Colors.grey.shade300;

                          if (isCurrent) {
                            borderColor = const Color(0xFF0D47A1);
                            boxColor = const Color(0xFF0D47A1).withOpacity(0.1);
                            textColor = const Color(0xFF0D47A1);
                          } else if (isAnswered) {
                            boxColor = const Color(0xFF0D47A1);
                            borderColor = const Color(0xFF0D47A1);
                            textColor = Colors.white;
                          }

                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: borderColor,
                                width: isCurrent ? 2.0 : 1.0,
                              ),
                            ),
                            child: InkWell(
                              onTap: () => _lompatKeSoal(index),
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= TOMBOL KONTROL DI AREA BAWAH LAYAR =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xffeaeaea))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_indeksSoalAktif < _daftarSoal.length - 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 40,
                        width: 110,
                        child: ElevatedButton(
                          onPressed: _soalBerikutnya,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: const Color(0xFF0D47A1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "LANJUT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios_rounded, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _kirimJawabanAkhir,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "SELESAI & KIRIM JAWABAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
