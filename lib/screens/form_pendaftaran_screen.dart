import 'package:flutter/material.dart';

class FormPendaftaranScreen extends StatefulWidget {
  const FormPendaftaranScreen({super.key});

  @override
  State<FormPendaftaranScreen> createState() => _FormPendaftaranScreenState();
}

class _FormPendaftaranScreenState extends State<FormPendaftaranScreen> {
  String? _jenisKelamin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Form Pendaftaran Lengkap"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("1. Data Diri Mahasiswa"),
            _buildTextField("Nama Lengkap", Icons.person),
            _buildTextField("NIM", Icons.badge, isNumber: true),
            _buildTextField("Kelas", Icons.class_),
            _buildTextField("Alamat Lengkap", Icons.home, maxLines: 2),
            _buildTextField("No. WhatsApp", Icons.phone, isNumber: true),
            _buildTextField("Email", Icons.email),

            const SizedBox(height: 10),
            const Text(
              "Jenis Kelamin",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio(
                  value: "L",
                  groupValue: _jenisKelamin,
                  onChanged: (v) => setState(() => _jenisKelamin = v),
                ),
                const Text("Laki-laki"),
                Radio(
                  value: "P",
                  groupValue: _jenisKelamin,
                  onChanged: (v) => setState(() => _jenisKelamin = v),
                ),
                const Text("Perempuan"),
              ],
            ),

            _buildTextField("Tempat Lahir", Icons.location_city),
            _buildTextField("Tanggal Lahir", Icons.calendar_today),
            _buildTextField(
              "Tahun Kelulusan (SMA/SMK)",
              Icons.school,
              isNumber: true,
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("2. Upload Dokumen (Wajib)"),
            _buildUploadTile("Upload KTM", "Gambar/PDF"),
            _buildUploadTile("Upload Foto 4x6", "Gambar"),
            _buildUploadTile("Upload Ijazah Terakhir", "PDF"),
            _buildUploadTile("Upload CV", "PDF"),
            _buildUploadTile("Bukti Screenshot Follow IG", "Gambar"),

            const SizedBox(height: 20),
            _buildSectionTitle("3. Project & Portofolio"),
            _buildTextField("Link GitHub", Icons.code, isOptional: true),
            _buildTextField("Link LinkedIn", Icons.link, isOptional: true),
            _buildTextField(
              "Link Portofolio Website",
              Icons.language,
              isOptional: true,
            ),
            _buildUploadTile("Upload File Project (Zip)", "Zip/Rar"),
            _buildTextField(
              "Deskripsi Project",
              Icons.description,
              maxLines: 3,
            ),
            _buildTextField(
              "Alasan Daftar Aslab",
              Icons.question_answer,
              maxLines: 3,
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _showSuccessDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                ),
                child: const Text(
                  "KIRIM PENDAFTARAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: isOptional ? "$label (Opsional)" : label,
          prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildUploadTile(String label, String format) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_upload, color: Colors.blue),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                "Format: $format",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Pendaftaran Anda telah kami terima."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
