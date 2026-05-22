import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // WAJIB untuk membuka link browser
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'form_pendaftaran_screen.dart';
import 'cbt_screen.dart';
import 'kartu_ujian_screen.dart';
import 'jadwal_screen.dart';
import 'edit_profil_screen.dart';
import 'notifikasi_screen.dart';

class DashboardScreen extends StatefulWidget {
  // Menambahkan properti penampung lemparan data profil dari LoginScreen
  final Map<String, dynamic>? userData;

  const DashboardScreen({super.key, this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Variabel penampung status dinamis hasil sinkronisasi database Laravel terbaru
  String _statusSeleksi = "pending";
  String _keteranganSeleksi =
      "Berkas Anda sedang diperiksa oleh Admin Lab. Harap cek secara berkala.";
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _ambilStatusTerbaru();
  }

  // FUNGSI UTAMA: Mengambil status seleksi terupdate dari database admin backend
  Future<void> _ambilStatusTerbaru() async {
    setState(() {
      _isLoadingStatus = true;
    });

    try {
      // Menembak endpoint status seleksi pendaftar sesuai id login
      final url = Uri.parse(
        "${ApiConfig.baseUrl}/seleksi/${widget.userData?['user_id'] ?? '1'}",
      );
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          setState(() {
            _statusSeleksi =
                jsonResponse['data']['status_seleksi'] ?? "pending";
            _keteranganSeleksi =
                jsonResponse['data']['keterangan'] ??
                "Berkas Anda sedang diperiksa oleh Admin Lab. Harap cek secara berkala.";
            _isLoadingStatus = false;
          });
        }
      } else {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingStatus = false;
      });
    }
  }

  // Mengonversi status langkah pendaftaran string dari Laravel menjadi angka integer
  int get tahapPendaftaran {
    String statusStr = _statusSeleksi.toLowerCase();

    if (statusStr == 'cbt') {
      return 1; // Berkas disetujui, dipersilakan ikut CBT
    } else if (statusStr == 'lolos' || statusStr == 'wawancara') {
      return 2; // Selesai CBT / Lolos ke tahap wawancara & jadwal terbuka
    }
    return 0; // Tahap awal berkas administrasi dalam verifikasi
  }

  // FUNGSI BARU: Memicu HP untuk membuka browser menuju link tertentu
  Future<void> _bukaWebsiteEksternal(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tidak dapat membuka link: $urlString")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    }
  }

  // Mengatur warna dinamis card status di dashboard depan
  Color _getWarnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'cbt':
        return Colors.blue.shade700;
      case 'wawancara':
        return Colors.purple;
      case 'lolos':
        return Colors.green;
      case 'tidak lolos':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFF),
      drawer: _buildDrawer(), // Memanggil Sidebar Drawer yang sudah di-upgrade
      body: RefreshIndicator(
        onRefresh:
            _ambilStatusTerbaru, // Geser layar ke bawah untuk reload status otomatis dari admin
        color: const Color(0xFF0D47A1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Memastikan seksi teks sejajar ke kiri
            children: [
              // 1. HEADER PROFIL DENGAN GRADASI
              Container(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 25,
                  right: 25,
                  bottom: 40,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selamat Datang,",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.userData?['nama'] ?? "Mahasiswa UMSIDA",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Phone: ${widget.userData?['no_hp'] ?? '-'}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                // KODE BARU YANG BENAR:
                                NotifikasiScreen(
                                  statusSeleksi: _statusSeleksi,
                                  keteranganSeleksi:
                                      _keteranganSeleksi, // 👈 Tambahkan baris ini
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 2. STATUS CARD DINAMIS (Pusat Informasi Pendaftar)
              _buildStatusCard(),

              // 3. SEKSI MENU UTAMA - TRANSFORMASI DESAIN LIST MODERN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alur Menu Seleksi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // MENU 1: Daftar Aslab (Selalu Aktif)
                    _buildListMenuRow(
                      context,
                      title: "Isi Formulir Pendaftaran",
                      desc: "Lengkapi data profil diri dan upload berkas fisik",
                      icon: Icons.assignment_ind_rounded,
                      color: Colors.blue,
                      isEnabled: true,
                      destination: FormPendaftaranScreen(
                        userId: widget.userData?['user_id']?.toString() ?? "1",
                      ),
                    ),
                    const SizedBox(height: 12),

                    // MENU 2: Kartu Ujian (Terbuka setelah administrasi lolos)
                    _buildListMenuRow(
                      context,
                      title: "Cetak Kartu Ujian",
                      desc: "Unduh bukti resmi untuk syarat validasi tes",
                      icon: Icons.badge_rounded,
                      color: Colors.green,
                      isEnabled: tahapPendaftaran >= 1,
                      destination: const KartuUjianScreen(),
                    ),
                    const SizedBox(height: 12),

                    // MENU 3: Test CBT (Mengikuti setelah cetak kartu)
                    _buildListMenuRow(
                      context,
                      title: "Ujian Online (Test CBT)",
                      desc:
                          "Pengerjaan soal seleksi berbasis komputer kompetensi",
                      icon: Icons.laptop_mac_rounded,
                      color: Colors.purple,
                      isEnabled: tahapPendaftaran >= 1,
                      destination: const CbtScreen(),
                    ),
                    const SizedBox(height: 12),

                    // MENU 4: Jadwal Wawancara (Terbuka jika Tahap >= 2)
                    _buildListMenuRow(
                      context,
                      title: "Jadwal Wawancara & Pengumuman",
                      desc:
                          "Lihat rincian tanggal wawancara dan status kelulusan",
                      icon: Icons.event_available_rounded,
                      color: Colors.red,
                      isEnabled: tahapPendaftaran >= 2,
                      destination: const JadwalScreen(),
                    ),

                    const SizedBox(height: 28),

                    // ================= SEKSI: TRACKING TIMELINE KEMAJUAN =================
                    const Text(
                      "Progress Tahapan Kamu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTrackingTimelineCard(),

                    const SizedBox(height: 25),

                    // ================= SEKSI PENGUMUMAN LAB =================
                    const Text(
                      "Pengumuman Lab",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAnnouncementCard(
                      judul: "Penutupan Berkas",
                      pesan:
                          "Pastikan format dokumen (KTM, CV, Foto) terbaca jelas untuk mempercepat verifikasi oleh Admin Laboratorium.",
                      icon: Icons.campaign_rounded,
                      warnaTema: Colors.amber.shade900,
                      warnaBg: Colors.amber.shade50,
                    ),
                    const SizedBox(
                      height: 35,
                    ), // Jarak aman scroll paling bawah
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: KARTU STATUS DINAMIS ---
  Widget _buildStatusCard() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status Pendaftaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                _isLoadingStatus
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getWarnaStatus(
                            _statusSeleksi,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _statusSeleksi.toUpperCase(),
                          style: TextStyle(
                            color: _getWarnaStatus(_statusSeleksi),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                Icon(
                  _statusSeleksi.toLowerCase() == 'tidak lolos'
                      ? Icons.cancel_rounded
                      : Icons.check_circle_rounded,
                  color: _getWarnaStatus(_statusSeleksi),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _keteranganSeleksi,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: BARIS LIST MENU YANG ELEGAN ---
  Widget _buildListMenuRow(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    required Widget destination,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isEnabled ? 0.02 : 0.0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isEnabled ? Colors.grey.shade100 : Colors.grey.shade200,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isEnabled
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                )
              : () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Akses menu '$title' saat ini masih terkunci!",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.orange.shade800,
                  ),
                ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? color.withOpacity(0.1)
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEnabled ? icon : Icons.lock_outline_rounded,
                    size: 24,
                    color: isEnabled ? color : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isEnabled
                              ? Colors.black87
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        desc,
                        style: TextStyle(
                          fontSize: 11,
                          color: isEnabled
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  isEnabled
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.lock_rounded,
                  size: 14,
                  color: isEnabled
                      ? Colors.grey.shade400
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET: TRACKING TIMELINE KEMAJUAN ---
  Widget _buildTrackingTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimelineNode(
            "Administrasi",
            isDone: true,
            isActive: _statusSeleksi.toLowerCase() == 'pending',
          ),
          _buildTimelineLine(isDone: tahapPendaftaran >= 1),
          _buildTimelineNode(
            "Ujian CBT",
            isDone: tahapPendaftaran >= 1,
            isActive: _statusSeleksi.toLowerCase() == 'cbt',
          ),
          _buildTimelineLine(isDone: tahapPendaftaran >= 2),
          _buildTimelineNode(
            "Wawancara",
            isDone: tahapPendaftaran >= 2,
            isActive: _statusSeleksi.toLowerCase() == 'wawancara',
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(
    String title, {
    required bool isDone,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF0D47A1)
                : (isDone ? Colors.green.shade50 : Colors.grey.shade100),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? const Color(0xFF0D47A1)
                  : (isDone ? Colors.green.shade400 : Colors.grey.shade300),
            ),
          ),
          child: Icon(
            isDone ? Icons.check_rounded : Icons.circle_outlined,
            color: isActive
                ? Colors.white
                : (isDone ? Colors.green : Colors.grey.shade400),
            size: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF0D47A1) : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? Colors.green.shade300 : Colors.grey.shade200,
        margin: const EdgeInsets.only(bottom: 20),
      ),
    );
  }

  // --- WIDGET: CARD NOTIFIKASI INFORMASI PENGUMUMAN ---
  Widget _buildAnnouncementCard({
    required String judul,
    required String pesan,
    required IconData icon,
    required Color warnaTema,
    required Color warnaBg,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: warnaTema.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: warnaTema, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: warnaTema,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pesan,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SEKSI SIDEBAR DRAWER DENGAN DETEKSI KLIK LINK WEB EKSTERNAL AKTIF
  // =========================================================================
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: Color(0xFF0D47A1)),
            ),
            // PERBAIKAN SINKRONISASI: Mengubah dari 'nama_lengkap' menjadi 'nama' agar sama dengan dashboard utama
            accountName: Text(
              widget.userData?['nama'] ?? "Mahasiswa UMSIDA",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            accountEmail: Text(
              widget.userData?['email'] ?? "email@student.umsida.ac.id",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12, bottom: 6),
                      child: Text(
                        "NAVIGASI INTERNAL",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    _buildSidebarItem(
                      Icons.manage_accounts_rounded,
                      "Edit Profil Kamu",
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(userData: widget.userData),
                          ),
                        );
                      },
                    ),
                    _buildSidebarItem(
                      Icons.chat_bubble_outline_rounded,
                      "Hubungi Admin Lab",
                      () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Membuka chat internal bersama laboran...",
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                    ),

                    // TAUTAN KLIK LANGSUNG WEB ASLI KAMU DI SINI
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 4, bottom: 6),
                      child: Text(
                        "PRANALA LUAR (WEBSITE)",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.language_rounded,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "Website Resmi Aslab",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: const Text(
                        "Informasi pendaftaran & jadwal lab",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.open_in_new_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Tutup drawer biar rapi
                        _bukaWebsiteEksternal(
                          "https://aslab-informatika.umsida.ac.id",
                        ); // MASUKKAN LINK WEB ASLAB DI SINI
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.school_rounded,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Portal Alumni Aslab",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: const Text(
                        "Database portfolio alumni UMSIDA",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.open_in_new_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Tutup drawer
                        _bukaWebsiteEksternal(
                          "https://alumni-aslab.umsida.ac.id",
                        ); // MASUKKAN LINK WEB ALUMNI DI SINI
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                    ),

                    _buildSidebarItem(
                      Icons.logout_rounded,
                      "Logout Sesi Akun",
                      () => _showLogoutDialog(context),
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer Hak Cipta Permanen
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            color: const Color(0xFFF8FAFF),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sistem Seleksi Aslab CBT",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "© 2026 Informatika UMSIDA",
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : const Color(0xFF0D47A1),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Keluar Aplikasi?"),
        content: const Text(
          "Semua sesi Anda akan berakhir. Ingin melanjutkan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            ),
            child: const Text(
              "YA, KELUAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
