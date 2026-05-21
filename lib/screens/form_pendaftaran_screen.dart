import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart'
    as http; // Import untuk menangani koneksi internet API
import 'dart:convert';

class FormPendaftaranScreen extends StatefulWidget {
  const FormPendaftaranScreen({super.key});

  @override
  State<FormPendaftaranScreen> createState() => _FormPendaftaranScreenState();
}

class _FormPendaftaranScreenState extends State<FormPendaftaranScreen> {
  String? _jenisKelamin;

  // Controller untuk menangkap teks di setiap kolom input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _tahunLulusController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _deskripsiProjectController =
      TextEditingController();
  final TextEditingController _alasanDaftarController = TextEditingController();

  // Menyimpan objek PlatformFile secara utuh agar jalurnya (path) bisa dibaca saat upload
  final Map<String, PlatformFile?> _selectedFiles = {
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
      WidgetsFlutterBinding.ensureInitialized();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFiles[key] = result.files.single;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil file: $e")));
    }
  }

  // FUNGSI UTAMA SINKRONISASI API LARAVEL BACKEND
  Future<void> _kirimPendaftaranKeBackend() async {
    // Validasi dasar field penting wajib diisi
    if (_namaController.text.isEmpty ||
        _nimController.text.isEmpty ||
        _whatsappController.text.isEmpty ||
        _jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Mohon isi Data Diri wajib Anda (Nama, NIM, No. WA, Jenis Kelamin)!",
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Menampilkan loading spinner indikator proses jaringan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D47A1)),
      ),
    );

    // URL Endpoint API Pendaftaran Aslab di Laravel temanmu
    String urlEndpoint = "http://10.21.0.180:8000/api/pendaftaran";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(urlEndpoint));

      // PERBAIKAN: Paksa Laravel merespon dalam format JSON (menghindari error HTML)
      request.headers['Accept'] = 'application/json';

      // PERBAIKAN: Kirim 'user_id' default (Wajib ada agar query Profil::create di backend tidak crash)
      request.fields['user_id'] = "1";

      // A. Memasukkan data INPUTAN TEKS (Disamakan dengan nama request di Controller Laravel baru)
      request.fields['nama'] = _namaController.text;
      request.fields['nim'] = _nimController.text;
      request.fields['kelas'] = _kelasController.text;
      request.fields['jenis_kelamin'] = _jenisKelamin!;
      request.fields['tempat_lahir'] = _tempatLahirController.text;
      request.fields['tanggal_lahir'] = _tanggalLahirController.text;
      request.fields['email'] = _emailController.text;
      request.fields['alasan_daftar'] = _alasanDaftarController.text;
      request.fields['deskripsi_project'] = _deskripsiProjectController.text;
      request.fields['link_github'] = _githubController.text;
      request.fields['link_linkedin'] = _linkedinController.text;
      request.fields['link_portfolio'] = _portfolioController.text;

      // KOREKSI UTAMA: Menyelaraskan nama key teks field agar terbaca controller backend temanmu
      request.fields['alamat_lengkap'] = _alamatController.text;
      request.fields['tahun_kelulusan'] = _tahunLulusController.text;
      request.fields['no_wa'] = _whatsappController.text;

      // B. Memasukkan FILE BERKAS FISIK (Nama key 'CV' dan 'KTM' sudah pas)
      for (var entry in _selectedFiles.entries) {
        if (entry.value != null && entry.value!.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value!.path!),
          );
        }
      }

      // C. Eksekusi kirim data paket ke server backend
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;
      Navigator.pop(context); // Menutup loading spinner

      // Memeriksa respon sukses dari server Laravel
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog(context);
      } else {
        // Cetak log error JSON asli jika validasi database ditolak
        print("====== ERROR DARI LARAVEL ======");
        print(response.statusCode);
        print(response.body);
        print("================================");

        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorData['message'] ??
                  "Gagal mengirim pendaftaran, cek kolom data database.",
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Menutup loading spinner jika koneksi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error Jaringan: Gagal terhubung ke Laravel ($e)"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _kelasController.dispose();
    _alamatController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _tahunLulusController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    _deskripsiProjectController.dispose();
    _alasanDaftarController.dispose();
    super.dispose();
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
              _buildTextField(
                "Nama Lengkap",
                Icons.person,
                controller: _namaController,
              ),
              _buildTextField(
                "NIM",
                Icons.badge,
                isNumber: true,
                controller: _nimController,
              ),
              _buildTextField(
                "Kelas",
                Icons.class_,
                controller: _kelasController,
              ),
              _buildTextField(
                "Alamat Lengkap",
                Icons.home,
                maxLines: 2,
                controller: _alamatController,
              ),
              _buildTextField(
                "No. WhatsApp",
                Icons.phone,
                isNumber: true,
                controller: _whatsappController,
              ),
              _buildTextField(
                "Email",
                Icons.email,
                controller: _emailController,
              ),

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

              _buildTextField(
                "Tempat Lahir",
                Icons.location_city,
                controller: _tempatLahirController,
              ),
              _buildTextField(
                "Tanggal Lahir",
                Icons.calendar_today,
                controller: _tanggalLahirController,
              ),
              _buildTextField(
                "Tahun Kelulusan (SMA/SMK)",
                Icons.school,
                isNumber: true,
                controller: _tahunLulusController,
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("2. Upload Dokumen (Wajib)"),

              _buildUploadTile(
                label: "Upload KTM",
                keyName: "KTM",
                defaultFormat: "Gambar/PDF",
                onTap: () =>
                    _pimmingDokumen("KTM", ['pdf', 'png', 'jpg', 'jpeg']),
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
              _buildTextField(
                "Link GitHub",
                Icons.code,
                isOptional: true,
                controller: _githubController,
              ),
              _buildTextField(
                "Link LinkedIn",
                Icons.link,
                isOptional: true,
                controller: _linkedinController,
              ),
              _buildTextField(
                "Link Portofolio Website",
                Icons.language,
                isOptional: true,
                controller: _portfolioController,
              ),

              _buildTextField(
                "Deskripsi Project",
                Icons.description,
                maxLines: 3,
                controller: _deskripsiProjectController,
              ),
              _buildTextField(
                "Alasan Daftar Aslab",
                Icons.question_answer,
                maxLines: 3,
                controller: _alasanDaftarController,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _kirimPendaftaranKeBackend,
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
    required TextEditingController controller,
    bool isNumber = false,
    int maxLines = 1,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
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

  Widget _buildUploadTile({
    required String label,
    required String keyName,
    required String defaultFormat,
    required VoidCallback onTap,
  }) {
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
                          ? "${_selectedFiles[keyName]!.name}"
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

  void _pimmingDokumen(String key, List<String> extensions) {
    _pilihDokumen(key, extensions);
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
              Navigator.pop(context);
              Navigator.pop(context);
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
