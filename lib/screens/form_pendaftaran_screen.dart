import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Tambahan untuk mengambil file asli dari HP

class FormPendaftaranScreen extends StatefulWidget {
  const FormPendaftaranScreen({super.key});

  @override
  State<FormPendaftaranScreen> createState() => _FormPendaftaranScreenState();
}

class _FormPendaftaranScreenState extends State<FormPendaftaranScreen> {
  String? _jenisKelamin;

  // Tempat menyimpan nama file yang diupload secara dinamis
  final Map<String, String?> _selectedFiles = {
    "KTM": null,
    "Foto": null,
    "Ijazah": null,
    "CV": null,
    "ScreenshotIG": null,
  };

  // Fungsi untuk memicu klik upload dokumen asli dari HP pendaftar
  Future<void> _pilihDokumen(
    String key,
    List<String>? allowedExtensions,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.name != null) {
        setState(() {
          // Simpan nama file asli ke dalam state untuk ditampilkan di UI
          _selectedFiles[key] = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil file: $e")));
    }
  }

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
        child: Padding(
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

              // KOREKSI: Sekarang tile upload dokumen di bawah ini bisa diklik & memicu FilePicker
              _buildUploadTile(
                label: "Upload KTM",
                keyName: "KTM",
                defaultFormat: "Gambar/PDF",
                onTap: () =>
                    _pilihDokumen("KTM", ['pdf', 'png', 'jpg', 'jpeg']),
              ),
              _buildUploadTile(
                label: "Upload Foto 4x6",
                keyName: "Foto",
                defaultFormat: "Gambar (JPG/PNG)",
                onTap: () => _pilihDokumen("Foto", ['jpg', 'jpeg', 'png']),
              ),
              _buildUploadTile(
                label: "Upload Ijazah Terakhir",
                keyName: "Ijazah",
                defaultFormat: "PDF",
                onTap: () => _pilihDokumen("Ijazah", ['pdf']),
              ),
              _buildUploadTile(
                label: "Upload CV",
                keyName: "CV",
                defaultFormat: "PDF",
                onTap: () => _pilihDokumen("CV", ['pdf']),
              ),
              _buildUploadTile(
                label: "Bukti Screenshot Follow IG",
                keyName: "ScreenshotIG",
                defaultFormat: "Gambar",
                onTap: () =>
                    _pilihDokumen("ScreenshotIG", ['png', 'jpg', 'jpeg']),
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("3. Project & Portofolio"),
              _buildTextField("Link GitHub", Icons.code, isOptional: true),
              _buildTextField("Link LinkedIn", Icons.link, isOptional: true),
              _buildTextField(
                "Link Portofolio Website",
                Icons.language,
                isOptional: true,
              ),

              // KOREKSI: Upload File Project (Zip) sudah dihapus total dari sini sesuai request
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "KIRIM PENDAFTARAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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

  // Helper Widget Pembuat Tempat Upload yang Bisa Diklik Dinamis
  Widget _buildUploadTile({
    required String label,
    required String keyName,
    required String defaultFormat,
    required VoidCallback onTap,
  }) {
    // Mengecek apakah pendaftar sudah memilih file atau belum
    bool fileSudahDipilih = _selectedFiles[keyName] != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: fileSudahDipilih
                  ? Colors.green.shade400
                  : Colors.grey.shade300,
              width: fileSudahDipilih ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
            color: fileSudahDipilih
                ? Colors.green.shade50
                : Colors.grey.shade50,
          ),
          child: Row(
            children: [
              Icon(
                fileSudahDipilih
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_rounded,
                color: fileSudahDipilih ? Colors.green : Colors.blue,
                size: 26,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileSudahDipilih
                          ? "${_selectedFiles[keyName]}" // Tampilkan nama file asli HP pendaftar
                          : "Format wajib: $defaultFormat",
                      style: TextStyle(
                        fontSize: 12,
                        color: fileSudahDipilih
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                        fontWeight: fileSudahDipilih
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (fileSudahDipilih)
                const Icon(Icons.stars_rounded, color: Colors.green, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Berhasil"),
        content: const Text("Pendaftaran Anda telah kami terima."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup Dialog
              Navigator.pop(context); // Kembali ke Dashboard Screen
            },
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
