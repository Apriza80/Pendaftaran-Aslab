import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  // Menangkap lemparan paket data registrasi/login asli dari Dashboard
  final Map<String, dynamic>? userData;

  const EditProfileScreen({super.key, this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller untuk Data Diri
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Controller untuk Ubah Password Baru
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State untuk sembunyikan/tampilkan password
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Inisialisasi data ditarik secara presisi dari JSON backend kamu ('nama' dan 'no_hp')
    _namaController = TextEditingController(
      text: widget.userData?['nama'] ?? "",
    );
    _emailController = TextEditingController(
      text: widget.userData?['email'] ?? "",
    );
    _phoneController = TextEditingController(
      text: widget.userData?['no_hp'] ?? "",
    );

    // Sinkronisasi teks Header Card secara real-time saat user mengetik perubahan
    _namaController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          "Edit Profil & Keamanan",
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER CARD BANNER =================
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _namaController.text.isEmpty
                                ? "Nama Mahasiswa"
                                : _namaController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _emailController.text.isEmpty
                                ? "email@student.umsida.ac.id"
                                : _emailController.text,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= SECTION 1: DATA DIRI =================
                    _buildSubTitle("Informasi Profil"),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: "Nama Lengkap",
                      controller: _namaController,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Email Student",
                      controller: _emailController,
                      icon: Icons.mail_outline_rounded,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Nomor Telepon (WhatsApp)",
                      controller: _phoneController,
                      icon: Icons.phone_android_rounded,
                      type: TextInputType.phone,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(thickness: 1.2),
                    ),

                    // ================= SECTION 2: KEAMANAN / UBAH PASSWORD =================
                    _buildSubTitle("Ubah Password Keamanan"),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: "Password Lama",
                      controller: _oldPasswordController,
                      icon: Icons.lock_open_rounded,
                      isPassword: true,
                      obscureText: _obscureOld,
                      onSuffixTap: () =>
                          setState(() => _obscureOld = !_obscureOld),
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Password Baru",
                      controller: _newPasswordController,
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: _obscureNew,
                      onSuffixTap: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      label: "Konfirmasi Password Baru",
                      controller: _confirmPasswordController,
                      icon: Icons.gpp_good_outlined,
                      isPassword: true,
                      obscureText: _obscureConfirm,
                      onSuffixTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),

                    const SizedBox(height: 35),

                    // ================= TOMBOL UTAMA SIMPAN PROFIL =================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _prosesSimpanPerubahan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
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
      ),
    );
  }

  // Widget Pembantu Judul Sub-Section Form
  Widget _buildSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D47A1),
        letterSpacing: 0.2,
      ),
    );
  }

  // Widget Pembantu Desain Kolom Input yang Bagus & Konsisten
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword ? obscureText : false,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF0D47A1), size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: onSuffixTap,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.5),
        ),
      ),
    );
  }

  // Fungsi Evaluasi Validasi saat Klik Simpan Perubahan dilakukan
  void _prosesSimpanPerubahan() {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data diri profil wajib diisi lengkap!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Jika pengguna mencoba mengisi form ganti password
    if (_oldPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_newPasswordController.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password baru minimal berisikan 8 karakter!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Konfirmasi password baru tidak cocok!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    // Tampilkan notifikasi berhasil diperbarui
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil & Keamanan Berhasil Diperbarui!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(
      context,
    ); // Kembali ke dashboard setelah data berhasil di-update
  }
}
