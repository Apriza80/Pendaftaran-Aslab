import 'package:flutter/material.dart';

class KartuUjianScreen extends StatelessWidget {
  const KartuUjianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kartu Ujian Digital"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("KARTU PESERTA ASLAB 2026", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(height: 30),
              // Simulasi Foto Profil
              const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 20),
              const Text("Mahasiswa UMSIDA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("NIM: 221080200XXX"),
              const SizedBox(height: 20),
              // Simulasi QR Code
              Container(
                width: 150,
                height: 150,
                color: Colors.grey[200],
                child: const Icon(Icons.qr_code_2, size: 120),
              ),
              const SizedBox(height: 10),
              const Text("Scan saat memasuki ruang ujian", 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}