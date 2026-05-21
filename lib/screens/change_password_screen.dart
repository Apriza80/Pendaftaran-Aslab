import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _passLamaController = TextEditingController();
  final _passBaruController = TextEditingController();
  final _konfirmasiPassController = TextEditingController();

  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _passLamaController.dispose();
    _passBaruController.dispose();
    _konfirmasiPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text("Ubah Password", style: TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Keamanan Akun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 5),
                const Text("Pastikan password baru Anda kuat dan sulit ditebak orang lain.", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 25),
                
                _buildInputField(
                  label: "Password Lama",
                  controller: _passLamaController,
                  obscure: _obscureLama,
                  onToggle: () => setState(() => _obscureLama = !_obscureLama),
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  label: "Password Baru",
                  controller: _passBaruController,
                  obscure: _obscureBaru,
                  onToggle: () => setState(() => _obscureBaru = !_obscureBaru),
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  label: "Konfirmasi Password Baru",
                  controller: _konfirmasiPassController,
                  obscure: _obscureKonfirmasi,
                  onToggle: () => setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password Sukses Diperbarui!"), backgroundColor: Color(0xFF0D47A1), behavior: SnackBarBehavior.floating),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1), // Biru Utama
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Update Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0D47A1)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.5)),
      ),
    );
  }
}