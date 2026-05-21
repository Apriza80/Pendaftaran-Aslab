import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller inputan data profil
  final _namaController = TextEditingController(text: "Mahasiswa UMSIDA");
  final _nimController = TextEditingController(text: "221080200XXX");
  final _emailController = TextEditingController(text: "mahasiswa@umsida.ac.id");
  final _prodiController = TextEditingController();
  final _fakultasController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _prodiController.dispose();
    _fakultasController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
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
          child: Column(
            children: [
              // Bagian Header Biru di dalam Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D47A1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 35, color: Color(0xFF0D47A1)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_namaController.text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_emailController.text, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              // Form Isian Lapisan Dalam
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildInputField(label: "Nama Lengkap", controller: _namaController, icon: Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildInputField(label: "NIM", controller: _nimController, icon: Icons.badge_outlined, enabled: false), // Kunci NIM agar tidak bisa diubah
                    const SizedBox(height: 15),
                    _buildInputField(label: "Email Student", controller: _emailController, icon: Icons.mail_outline, type: TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    _buildInputField(label: "Program Studi", controller: _prodiController, icon: Icons.school_outlined),
                    const SizedBox(height: 15),
                    _buildInputField(label: "Fakultas", controller: _fakultasController, icon: Icons.apartment_outlined),
                    const SizedBox(height: 15),
                    _buildInputField(label: "Nomor Telepon", controller: _phoneController, icon: Icons.phone_outlined, type: TextInputType.phone),
                    const SizedBox(height: 25),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Profil Berhasil Diperbarui!"), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50), // Hijau tombol simpan
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Simpan Profil", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
        filled: !enabled,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.5)),
      ),
    );
  }
}