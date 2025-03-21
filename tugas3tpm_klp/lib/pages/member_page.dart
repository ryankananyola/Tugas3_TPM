import 'package:flutter/material.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMemberCard(
              name: 'Sayudha Patria',
              nim: '123220177',
              position: 'Direktur PT Timah',
              wealth: '300 Triliun',
              imagePath: 'assets/image/yudha.jpg',
            ),
            _buildMemberCard(
              name: 'Aryamukti Satria Hendrayana',
              nim: '123220181',
              position: 'Direktur PT Pertamina',
              wealth: '900 Triliun',
              imagePath: 'assets/image/rio.jpg',
            ),
            _buildMemberCard(
              name: 'Yohanes Febryan Kana Nyola',
              nim: '123220198',
              position: 'Direktur PT Duta Palma Group',
              wealth: '78 Triliun',
              imagePath: 'assets/image/ryan.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard({
    required String name,
    required String nim,
    required String position,
    required String wealth,
    required String imagePath,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIM: $nim', style: const TextStyle(fontSize: 14)),
                  Text('Jabatan: $position', style: const TextStyle(fontSize: 14)),
                  Text(
                    'Kekayaan: $wealth',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
