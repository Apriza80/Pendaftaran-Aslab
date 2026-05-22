class ApiConfig {
  // 1. Tulis IP dasar server temanmu di sini sebagai pusat kontrol
  static const String baseUrl = "http://10.21.2.14:8000/api";

  // 2. Daftarkan pecahan pintu gerbang (endpoint) sesuai kebutuhan screen
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String pendaftaran = "$baseUrl/pendaftaran";
  static const String cbt = "$baseUrl/cbt";
  static const String jadwal = "$baseUrl/jadwal";
}
