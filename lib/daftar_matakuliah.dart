import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarMatakuliahPage extends StatefulWidget {
  const DaftarMatakuliahPage({super.key});

  @override
  State<DaftarMatakuliahPage> createState() => _DaftarMatakuliahPageState();
}

class _DaftarMatakuliahPageState extends State<DaftarMatakuliahPage> {
  final TextEditingController searchController = TextEditingController();
  List<String> searchHistory = [];
  String query = '';

  final List<Map<String, String>> matkulList = [
    {
      'kode': '14624413',
      'nama': 'PENGEMBANGAN APLIKASI BERGERAK',
      'kelas': 'A',
      'dosen': 'Naufal Abdillah, S.Kom, M.Kom',
      'hari': 'Senin',
      'jam': '09:30 - 11:10 WIB',
      'ruangan': 'I306',
    },
    {
      'kode': '14624413',
      'nama': 'PENGEMBANGAN APLIKASI BERGERAK',
      'kelas': 'B',
      'dosen': 'Naufal Abdillah, S.Kom, M.Kom',
      'hari': 'Selasa',
      'jam': '10:00 - 11:40 WIB',
      'ruangan': 'I307',
    },
    {
      'kode': '14624413',
      'nama': 'PENGEMBANGAN APLIKASI BERGERAK',
      'kelas': 'C',
      'dosen': 'Naufal Abdillah, S.Kom, M.Kom',
      'hari': 'Rabu',
      'jam': '13:00 - 14:40 WIB',
      'ruangan': 'I308',
    },
    {
      'kode': '14624414',
      'nama': 'PENGUJIAN PERANGKAT LUNAK',
      'kelas': 'A',
      'dosen': 'Fridy Mandita, S.Kom., M.Sc',
      'hari': 'Kamis',
      'jam': '08:00 - 09:40 WIB',
      'ruangan': 'I201',
    },
    {
      'kode': '14624414',
      'nama': 'PENGUJIAN PERANGKAT LUNAK',
      'kelas': 'B',
      'dosen': 'Fridy Mandita, S.Kom., M.Sc',
      'hari': 'Jumat',
      'jam': '10:00 - 11:40 WIB',
      'ruangan': 'I202',
    },
    {
      'kode': '14624414',
      'nama': 'PENGUJIAN PERANGKAT LUNAK',
      'kelas': 'C',
      'dosen': 'Fridy Mandita, S.Kom., M.Sc',
      'hari': 'Sabtu',
      'jam': '13:00 - 14:40 WIB',
      'ruangan': 'I203',
    },
    {
      'kode': '14624415',
      'nama': 'DESAIN PENGALAMAN PENGGUNA',
      'kelas': 'A',
      'dosen': 'Anang Pramono, S.Kom.,MM',
      'hari': 'Senin',
      'jam': '15:00 - 16:40 WIB',
      'ruangan': 'I401',
    },
    {
      'kode': '14624415',
      'nama': 'DESAIN PENGALAMAN PENGGUNA',
      'kelas': 'B',
      'dosen': 'Anang Pramono, S.Kom.,MM',
      'hari': 'Selasa',
      'jam': '08:00 - 09:40 WIB',
      'ruangan': 'I402',
    },
    {
      'kode': '14624415',
      'nama': 'DESAIN PENGALAMAN PENGGUNA',
      'kelas': 'C',
      'dosen': 'Anang Pramono, S.Kom.,MM',
      'hari': 'Rabu',
      'jam': '10:00 - 11:40 WIB',
      'ruangan': 'I403',
    },
  ];

  List<Map<String, String>> get filteredMatkul {
    return matkulList.where((matkul) {
      final kode = matkul['kode']?.toLowerCase() ?? '';
      final nama = matkul['nama']?.toLowerCase() ?? '';
      final kelas = matkul['kelas']?.toLowerCase() ?? '';
      final combined = '$nama - $kelas';

      final search = query.toLowerCase();

      return kode.contains(search) ||
          nama.contains(search) ||
          combined.contains(search);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    if (!searchHistory.contains(keyword)) {
      searchHistory.insert(0, keyword);
      if (searchHistory.length > 10)
        searchHistory = searchHistory.sublist(0, 10); // maksimal 10
      await prefs.setStringList('search_history', searchHistory);
    }
  }

  Future<void> _deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory.removeAt(index);
    await prefs.setStringList('search_history', searchHistory);
    setState(() {});
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() => searchHistory.clear());
  }

  Future<void> _simpanMatkulTerpilih(Map<String, String> matkul) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('matkul_terdaftar') ?? [];
    final item =
        '${matkul['kode']}|${matkul['nama']}|${matkul['kelas']}|${matkul['dosen']}|${matkul['hari']}|${matkul['jam']}|${matkul['ruangan']}';

    if (!existing.contains(item)) {
      existing.add(item);
      await prefs.setStringList('matkul_terdaftar', existing);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mata kuliah berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mata kuliah sudah pernah ditambahkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: const Color(0xFF7A2D3D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'DAFTAR MATA KULIAH',
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
                ), // placeholder agar teks tetap di tengah
              ],
            ),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              onSubmitted: (value) {
                _saveSearchHistory(value.trim());
              },
              decoration: InputDecoration(
                hintText: 'Cari mata kuliah',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Isi
          Expanded(
            child:
                query.isEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Riwayat pencarian',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: searchHistory.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(searchHistory[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _deleteHistoryItem(index),
                                ),
                                onTap: () {
                                  setState(() {
                                    query = searchHistory[index];
                                    searchController.text = query;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        if (searchHistory.isNotEmpty)
                          Center(
                            child: TextButton(
                              onPressed: _clearHistory,
                              child: const Text('Hapus semua riwayat'),
                            ),
                          ),
                      ],
                    )
                    : filteredMatkul.isEmpty
                    ? const Center(
                      child: Text(
                        'Tidak ada hasil ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredMatkul.length,
                      itemBuilder: (context, index) {
                        final matkul = filteredMatkul[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7A2D3D),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(12),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(child: Text('📝')),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${matkul['kode']} - ${matkul['nama']} - ${matkul['kelas']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Teacher : ${matkul['dosen']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Day : ${matkul['hari']} ${matkul['jam']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Class : ${matkul['ruangan']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          _simpanMatkulTerpilih(matkul);
                                          _saveSearchHistory(
                                            '${matkul['nama']} - ${matkul['kelas']}',
                                          );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text('Enter this course'),
                                      ),
                                    ],
                                  ),
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
