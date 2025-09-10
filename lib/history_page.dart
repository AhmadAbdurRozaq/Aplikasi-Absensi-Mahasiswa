import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> scanHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      scanHistory = prefs.getStringList('scan_history') ?? [];
    });
  }

  Future<void> _hapusRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('scan_history');
    setState(() {
      scanHistory.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Background utama putih
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D2A42), // ✅ AppBar merah tua
        centerTitle: true,
        title: Text(
          'RIWAYAT ABSENSI',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (scanHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _hapusRiwayat,
            ),
        ],
      ),
      body: scanHistory.isEmpty
          ? Center(
              child: Text(
                'Belum ada riwayat absen.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                final data = scanHistory[index].split('\n');
                final details = data[0].split('|');
                final waktu = data.length > 1 ? data[1] : '';

                String kode = details.length > 0 ? details[0] : '';
                String nama = details.length > 1 ? details[1] : '';
                String kelas = details.length > 2 ? details[2] : '';
                String dosen = details.length > 3 ? details[3] : '';
                String hari = details.length > 4 ? details[4] : '';
                String jam = details.length > 5 ? details[5] : '';
                String ruangan = details.length > 6 ? details[6] : '';

                return Card(
                  color: const Color(0xFFB5445C), // ✅ Merah muda card
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$nama - $kelas ($kode)',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Dosen: $dosen',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        Text('Hari: $hari',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        Text('Jam: $jam',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        Text('Ruangan: $ruangan',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(
                          'Absen pada: $waktu',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
