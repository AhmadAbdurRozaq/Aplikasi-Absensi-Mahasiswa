import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import halaman tujuan
import 'daftar_matakuliah.dart';
import 'scan_barcode.dart';
import 'jadwal_matakuliah.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nama = '';

  @override
  void initState() {
    super.initState();
    _loadNama();
  }

  Future<void> _loadNama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? 'Pengguna';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar Manual
          Container(
            color: const Color(0xFF5B0C1F), // Maroon
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UNTAG SURABAYA\nABSENSI MAHASISWA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                Image.asset(
                  'assets/logo.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Banner Kampus Merdeka + Gedung
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/gedung_untag.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Image.asset(
                            'assets/kampus_merdeka.png',
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Mahasiswa
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B0C1F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            nama,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const Text(
                          'Teknik Informatika',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF5B0C1F), thickness: 1.5),
                  const SizedBox(height: 16),

                  // Menu 1 - Daftar Mata Kuliah
                  _buildMenuCard(
                    context,
                    iconPath: 'assets/icon_barcode.jpg',
                    label: 'DAFTAR MATA KULIAH',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DaftarMatakuliahPage(),
                        ),
                      );
                    },
                  ),

                  // Menu 2 - Scan QR Code
                  _buildMenuCard(
                    context,
                    iconPath: 'assets/icon_barcode.jpg',
                    label: 'SCAN QR CODE',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScanBarcodePage(),
                        ),
                      );
                    },
                  ),

                  // Menu 3 - Jadwal Mata Kuliah
                  _buildMenuCard(
                    context,
                    iconPath: 'assets/icon_barcode.jpg',
                    label: 'JADWAL MATA KULIAH',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JadwalMatakuliahPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Menu
  Widget _buildMenuCard(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD76961),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
