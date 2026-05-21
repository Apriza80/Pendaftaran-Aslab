import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Fungsi pemicu link luar (YouTube & WhatsApp)
  Future<void> _bukaTautanLuar(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        await launchUrl(url);
      } else {
        throw 'Gagal memicu tautan';
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tidak dapat membuka aplikasi terkait. Pastikan aplikasi sudah terinstal.",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> banners = [
      'assets/tahap1.png',
      'assets/tahap2.png',
      'assets/tahap3.png',
    ];

    final double tinggiLayar = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= 1. HEADER: POSISI LOGO & TEKS DINAIKKAN =================
            Container(
              width: double.infinity,
              height: tinggiLayar * 0.44,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgumsida.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 2,
                      ), // Menarik konten utama agar lebih naik ke atas
                      // Logo Aslab
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logoaslab.png',
                            height: 65,
                            width: 65,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.school_rounded,
                                  size: 45,
                                  color: Color(0xFF0D47A1),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Teks Judul Utama
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "APLIKASI RESMI PENDAFTARAN\nASLAB INFORMATIKA UMSIDA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            height: 1.3,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.6),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 1), // Sela fleksibel tengah
                      // Tombol Panduan (Tutorial & Bantuan)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            _buildHeaderButton(
                              label: "Tutorial",
                              icon: Icons.play_arrow_rounded,
                              color: const Color(0xFFD32F2F),
                              onTap: () => _bukaTautanLuar(
                                context,
                                "https://www.youtube.com",
                              ),
                            ),
                            const SizedBox(width: 15),
                            _buildHeaderButton(
                              label: "Bantuan",
                              icon: Icons.chat_bubble_outline_rounded,
                              color: const Color(0xFF1B5E20),
                              onTap: () => _bukaTautanLuar(
                                context,
                                "https://wa.me/6281234567890",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ), // Jarak bawah dikunci agar tidak mepet Card Login
                    ],
                  ),
                ),
              ),
            ),

            // ================= 2. CARD LOGIN (FLOATING CARD) =================
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_circle_outlined,
                            color: Color(0xFF0D47A1),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Anda belum login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Silakan login untuk melanjutkan pendaftaran.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= 3. BAGIAN SLIDER BANNER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Pelaksanaan Seleksi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 195,
                    child: PageView.builder(
                      itemCount: banners.length,
                      physics: const BouncingScrollPhysics(),
                      controller: PageController(viewportFraction: 0.96),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              banners[index],
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                          size: 35,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Gagal memuat gambar banner",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_left_alt_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Geser untuk melihat alur tahapan & info link resmi web",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= STATISTIK PENDAFTAR AKTIF =================
                  const Text(
                    "Statistik Pendaftar Sementara",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildStatBar(
                          "Total Pendaftar",
                          148,
                          Colors.blue.shade700,
                          0.9,
                        ),
                        const SizedBox(height: 12),
                        _buildStatBar(
                          "Lolos Berkas",
                          92,
                          Colors.green.shade600,
                          0.6,
                        ),
                        const SizedBox(height: 12),
                        _buildStatBar(
                          "Lolos CBT",
                          45,
                          Colors.orange.shade700,
                          0.3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= 4. BERITA TERBARU =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Berita & Pengumuman",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0D47A1),
                        ),
                        child: const Text(
                          "Lihat Semua",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _buildNewsItem(
                    "Tips Menghadapi Tes CBT Informatika",
                    "Diterbitkan: Kamis, 21 Mei 2026",
                  ),
                  _buildNewsItem(
                    "Alur Pengumpulan Berkas Fisik Tambahan",
                    "Diterbitkan: Selasa, 19 Mei 2026",
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk membuat Diagram Batang Statistik
  Widget _buildStatBar(
    String label,
    int jumlah,
    Color barColor,
    double presentaseLebar,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KOREKSI: Menggunakan Colors.black87 yang dijamin aman 100% tanpa error merah
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "$jumlah Mhs",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: presentaseLebar,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
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
    );
  }

  Widget _buildNewsItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Color(0xFF0D47A1),
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}
