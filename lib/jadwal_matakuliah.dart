import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class JadwalMatakuliahPage extends StatefulWidget {
  const JadwalMatakuliahPage({super.key});

  @override
  State<JadwalMatakuliahPage> createState() => _JadwalMatakuliahPageState();
}

class _JadwalMatakuliahPageState extends State<JadwalMatakuliahPage> {
  List<List<String>> semuaJadwal = [];
  List<List<String>> filteredJadwal = [];
  String selectedHari = 'Semua Hari';

  final List<String> daftarHari = [
    'Semua Hari',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  @override
  void initState() {
    super.initState();
    _loadJadwalMatkul();
  }

  Future<void> _loadJadwalMatkul() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('matkul_terdaftar') ?? [];

    setState(() {
      semuaJadwal = data.map((e) => e.split('|')).toList();
      _filterJadwal();
    });
  }

  void _filterJadwal() {
    setState(() {
      if (selectedHari == 'Semua Hari') {
        filteredJadwal = semuaJadwal;
      } else {
        filteredJadwal =
            semuaJadwal.where((e) => e[4] == selectedHari).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            bottom: 12,
          ),
          color: const Color(0xFF7A2D3D),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Text(
                  'JADWAL MATA KULIAH',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Dropdown Hari
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedHari,
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(),
              items:
                  daftarHari.map((hari) {
                    return DropdownMenuItem(
                      value: hari,
                      child: Text(hari, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHari = value!;
                  _filterJadwal();
                });
              },
            ),
          ),

          // List Jadwal
          Expanded(
            child:
                filteredJadwal.isEmpty
                    ? Center(
                      child: Text(
                        'Tidak ada jadwal tersedia.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredJadwal.length,
                      itemBuilder: (context, index) {
                        final matkul = filteredJadwal[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7A2D3D),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                            ),
                            title: Text(
                              '${matkul[0]} - ${matkul[1]} - ${matkul[2]}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Teacher: ${matkul[3]}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Day: ${matkul[4]} ${matkul[5]}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Class: ${matkul[6]}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
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
