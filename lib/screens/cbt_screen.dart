import 'package:flutter/material.dart';

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
  Map<int, int> _jawabanPeserta =
      {}; // Menyimpan jawaban (Kunci: Indeks Soal, Nilai: Indeks Pilihan)

  // Fungsi untuk berpindah nomor soal secara langsung
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
              Navigator.pop(context);
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
  Widget build(BuildContext context) {
    final Map<String, dynamic> soalSekarang = _daftarSoal[_indeksSoalAktif];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      // ================= HEADER UTAMA APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFEF5350,
        ), // Merah sesuai gambar 'Test CBT' kamu
        elevation: 0,
        title: const Text(
          "Test CBT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                "9:55",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                                // KOREKSI: Mengganti dari Colors.black70 ke Colors.black87 agar bebas error merah
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
                  const SizedBox(height: 20),

                  // ================= GRID NAVIGASI NOMOR SOAL =================
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

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: _daftarSoal.length,
                    itemBuilder: (context, index) {
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

                      return InkWell(
                        onTap: () => _lompatKeSoal(index),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: borderColor,
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    },
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
    );
  }
}
