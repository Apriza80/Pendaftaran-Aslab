import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart'; // Memanggil URL API pusat

class KartuUjianScreen extends StatefulWidget {
  final String userId;

  const KartuUjianScreen({super.key, required this.userId});

  @override
  State<KartuUjianScreen> createState() => _KartuUjianScreenState();
}

class _KartuUjianScreenState extends State<KartuUjianScreen> {
  bool _isLoading = true;
  String _pesanError = "";

  // Variabel penampung data dinamis kartu dari Admin
  String _nama = "Mahasiswa UMSIDA";
  String _nim = "-";
  String _tema = "Seleksi Asisten Laboratorium";
  String _tanggal = "-";
  String _jam = "-";
  String _durasi = "-";
  String _tokenCbt = "-";
  String _tahun = "2026";
  String _status = "-";

  @override
  void initState() {
    super.initState();
    _ambilDataKartuUjian();
  }

  // FUNGSI UTAMA: Mengambil rincian jadwal yang diinput oleh Admin
  Future<void> _ambilDataKartuUjian() async {
    setState(() {
      _isLoading = true;
      _pesanError = "";
    });

    final url = Uri.parse("${ApiConfig.baseUrl}/kartu-ujian/${widget.userId}");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final data = jsonResponse;
        setState(() {
          _nama = data['nama'] ?? "Mahasiswa UMSIDA";
          _nim = data['nim'] ?? "-";
          _tema = data['tema'] ?? "Seleksi Asisten Laboratorium";
          _tanggal = data['tanggal'] ?? "-";
          _jam = data['jam'] ?? widget.userId;
          _durasi = data['durasi'].toString();
          _tokenCbt = data['token'] ?? "-";
          _tahun = data['tahun']?.toString() ?? "2026";
          _status = data['status'] ?? "CBT";
          _isLoading = false;
        });
      } else {
        setState(() {
          _pesanError = "Jadwal ujian belum diatur oleh Admin.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _pesanError = "Gagal memuat data kartu ujian ($e)";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          "Kartu Ujian Digital",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D47A1)),
            )
          : _pesanError.isNotEmpty
          ? _buildErrorState()
          : Stack(
              children: [
                // 1. Ornamen Background Gradasi Biru Atas
                Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // 2. Konten Utama Card Melayang
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // KARTU DESIGN RASIO RESMI
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header Internal Kartu
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Text(
                                  "KARTU PESERTA ASLAB $_tahun",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Color(0xFF0D47A1),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Avatar Frame Bulat
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(
                                            0xFF0D47A1,
                                          ).withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 42,
                                        backgroundColor: Color(0xFFE3F2FD),
                                        child: Icon(
                                          Icons.person,
                                          size: 55,
                                          color: Color(0xFF0D47A1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Nama & NIM Dinamis
                                    Text(
                                      _nama,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "NIM: $_nim",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Divider(
                                        color: Color(0xFFF0F4F8),
                                        thickness: 1.5,
                                      ),
                                    ),

                                    // ====== DETAIL RINCIAN JADWAL INPUTAN ADMIN ======
                                    _buildDetailBaris(
                                      Icons.topic_rounded,
                                      "Tema Seleksi",
                                      _tema,
                                    ),
                                    _buildDetailBaris(
                                      Icons.calendar_month_rounded,
                                      "Tanggal Ujian",
                                      _tanggal,
                                    ),
                                    _buildDetailBaris(
                                      Icons.access_time_filled_rounded,
                                      "Jam Sesi",
                                      _jam,
                                    ),
                                    _buildDetailBaris(
                                      Icons.timer_rounded,
                                      "Durasi Ujian",
                                      _durasi,
                                    ),
                                    _buildDetailBaris(
                                      Icons.vpn_key_rounded,
                                      "Token CBT",
                                      _tokenCbt,
                                    ),
                                    _buildDetailBaris(
                                      Icons.analytics_rounded,
                                      "Status Tahap",
                                      _status.toUpperCase(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // 3. BUTTON AKSI DOWNLOAD PDF
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Mempersiapkan berkas PDF kartu ujian...",
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              "UNDUH KARTU (PDF)",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF5350),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              shadowColor: Colors.red.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Widget pembantu untuk layout baris informasi dinamis
  Widget _buildDetailBaris(IconData ikon, String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan jika data belum siap / error jaringan
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_late_rounded,
              size: 60,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              _pesanError,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
