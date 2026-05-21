import 'package:flutter/material.dart';
import 'form_pendaftaran_screen.dart';
import 'cbt_screen.dart';
import 'kartu_ujian_screen.dart';
import 'jadwal_screen.dart';
import 'edit_profil_screen.dart';
import 'change_password_screen.dart';

class DashboardScreen extends StatefulWidget {
  // Menambahkan properti penampung lemparan data profil dari LoginScreen
  final Map<String, dynamic>? userData;

  const DashboardScreen({super.key, this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mengonversi status langkah pendaftaran string dari Laravel menjadi angka integer
  int get tahapPendaftaran {
    // Membaca status_step dari backend. Default jika kosong adalah 'administrasi' (0)
    String statusStr = widget.userData?['status_step'] ?? 'administrasi';

    if (statusStr == 'cbt') {
      return 1; // Berkas disetujui, dipersilakan ikut CBT
    } else if (statusStr == 'lolos' || statusStr == 'wawancara') {
      return 2; // Selesai CBT / Lolos ke tahap wawancara & jadwal terbuka
    }
    return 0; // Tahap awal berkas administrasi dalam verifikasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFF),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
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
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        // PERBAIKAN: Diubah menggunakan key ['nama'] sesuai JSON backend kamu
                        Text(
                          widget.userData?['nama'] ?? "Mahasiswa UMSIDA",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // PERBAIKAN: Diubah menggunakan key ['no_hp'] sesuai JSON backend kamu
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 2. STATUS CARD DINAMIS (Pusat Informasi Pendaftar)
            _buildStatusCard(),

            const SizedBox(height: 20),

            // 3. MENU UTAMA DENGAN LOGIKA PENGUNCIAN BACKEND
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Layanan Utama",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      // MENU 1: Selalu Terbuka untuk edit/isi pendaftaran
                      _buildMenuCard(
                        context,
                        "Daftar Aslab",
                        Icons.assignment_ind_rounded,
                        Colors.blue,
                        true,
                        const FormPendaftaranScreen(),
                      ),
                      // MENU 2: Terbuka jika Berkas Disetujui (Tahap >= 1)
                      _buildMenuCard(
                        context,
                        "Test CBT",
                        Icons.laptop_mac_rounded,
                        Colors.purple,
                        tahapPendaftaran >= 1,
                        const CbtScreen(),
                      ),
                      // MENU 3: Terbuka jika Berkas Disetujui (Tahap >= 1)
                      _buildMenuCard(
                        context,
                        "Kartu Ujian",
                        Icons.badge_rounded,
                        Colors.green,
                        tahapPendaftaran >= 1,
                        const KartuUjianScreen(),
                      ),
                      // MENU 4: Terbuka jika CBT Selesai / Lolos (Tahap >= 2)
                      _buildMenuCard(
                        context,
                        "Jadwal",
                        Icons.event_available_rounded,
                        Colors.red,
                        tahapPendaftaran >= 2,
                        const JadwalScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: KARTU STATUS DINAMIS ---
  Widget _buildStatusCard() {
    bool isVerif = tahapPendaftaran >= 1;
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isVerif
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isVerif ? "BERKAS DISETUJUI" : "DALAM VERIFIKASI",
                    style: TextStyle(
                      color: isVerif ? Colors.green : Colors.orange,
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
                  isVerif
                      ? Icons.check_circle_rounded
                      : Icons.pending_actions_rounded,
                  color: isVerif ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isVerif
                        ? "Selamat! Berkas Anda telah disetujui admin. Silakan cetak kartu dan ikuti ujian CBT."
                        : "Berkas Anda sedang diperiksa oleh Admin Lab. Harap cek secara berkala.",
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

  // --- WIDGET: KARTU MENU DENGAN LOGIKA KUNCI ---
  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    bool isEnabled,
    Widget destination,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: isEnabled
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                )
              : () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Menu $title terkunci. Selesaikan tahap sebelumnya!",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                ),
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.4,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 35, color: color),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isEnabled)
                  const Positioned(
                    top: 15,
                    right: 15,
                    child: Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET: DRAWER & LOGOUT ---
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 45, color: Color(0xFF0D47A1)),
            ),
            // PERBAIKAN: Sinkronisasi Teks Nama menggunakan key ['nama'] dari backend
            accountName: Text(
              widget.userData?['nama'] ?? "Mahasiswa UMSIDA",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // PERBAIKAN: Sinkronisasi Teks Email menggunakan key ['email'] dari backend
            accountEmail: Text(
              widget.userData?['email'] ?? "email@student.umsida.ac.id",
            ),
          ),

          _buildSidebarItem(Icons.manage_accounts, "Edit Profil", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          }),

          _buildSidebarItem(Icons.lock_reset, "Ubah Password", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          }),

          _buildSidebarItem(
            Icons.chat_bubble_outline,
            "Hubungi Admin Lab",
            () {},
          ),
          const Spacer(),
          const Divider(),
          _buildSidebarItem(
            Icons.logout_rounded,
            "Logout",
            () => _showLogoutDialog(context),
            isLogout: true,
          ),
          const SizedBox(height: 10),
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
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
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
