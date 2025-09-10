import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_qr.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ScanBarcodePage extends StatefulWidget {
  const ScanBarcodePage({super.key});

  @override
  State<ScanBarcodePage> createState() => _ScanBarcodePageState();
}

class _ScanBarcodePageState extends State<ScanBarcodePage> {
  List<String> matkulTerdaftar = [];

  @override
  void initState() {
    super.initState();
    _loadMatkulTerdaftar();
  }

  Future<void> _loadMatkulTerdaftar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      matkulTerdaftar = prefs.getStringList('matkul_terdaftar') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar Custom
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              color: const Color(0xFF7A2D3D),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'SCAN QR CODE',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ), // Placeholder agar judul tetap center
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Pilih presensi sesuai mata kuliah',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: matkulTerdaftar.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final data = matkulTerdaftar[index].split('|');
                final kode = data[0];
                final nama = data[1];
                final kelas = data[2];
                final dosen = data[3];
                final hari = data[4];
                final jam = data[5];
                final ruangan = data[6];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A2D3D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Kiri - info matkul
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$kode - $nama - $kelas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Teacher : $dosen',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Day : $hari $jam',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Class : $ruangan',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Kanan - tombol presensi
                      ElevatedButton.icon(
                        onPressed: () async {
                          final hasilScan = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScanQrPage(),
                            ),
                          );

                          if (hasilScan != null &&
                              hasilScan is String &&
                              hasilScan.contains('|')) {
                            await initializeDateFormatting(
                              'id_ID',
                              null,
                            ); // ⬅️ WAJIB

                            final now = DateTime.now();
                            final jam = DateFormat('HH:mm').format(now);
                            final hari = DateFormat(
                              'EEEE, d MMMM yyyy',
                              'id_ID',
                            ).format(now);

                            final riwayatBaru = '$hasilScan\n$hari • $jam';

                            final prefs = await SharedPreferences.getInstance();
                            List<String> history =
                                prefs.getStringList('scan_history') ?? [];

                            history.insert(0, riwayatBaru);
                            await prefs.setStringList('scan_history', history);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Berhasil absen dan disimpan ke histori',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Scan gagal atau tidak valid'),
                              ),
                            );
                          }
                        },

                        icon: const Icon(Icons.qr_code),
                        label: const Text("Absen"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
