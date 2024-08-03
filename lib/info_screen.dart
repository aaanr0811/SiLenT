import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: InfoScreen()));

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi',
          style: TextStyle(
            color: Colors.white, // Ubah warna teks menjadi putih
          ),
        ),
        backgroundColor: Color.fromRGBO(0, 111, 111, 1.0), // Warna hijau
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna ikon kembali menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              _buildAppInfo(),
              SizedBox(height: 40),
              _buildSectionTitle('Pengembang'),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStudentInfoCard('Annisa Aisyah', '33421304'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildStudentInfoCard('Putri Ayu', '33421319'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Dosen Pembimbing'),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child:
                        _buildLecturerInfoCard('Sirli Fahriah S.Kom., M.Kom'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildLecturerInfoCard(
                        'Nurseno Bayu Aji S.Kom., M.Kom'),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copyright,
                color: Colors.black, // Ubah warna ikon menjadi hitam
                size: 16,
              ),
              SizedBox(width: 4), // Spasi antara ikon dan teks
              Text(
                'Copyright 2024',
                style: TextStyle(
                  color: Colors.black, // Ubah warna teks menjadi hitam
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Informasi Aplikasi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Center(
          // Gunakan widget Center di sini
          child: Text(
            'Aplikasi SiLenT (Sign Language Translator) dirancang untuk menjadi jembatan komunikasi antara individu yang tunarungu dan mereka yang tidak mengerti bahasa isyarat. Dengan menggunakan teknologi pengenalan gerak dan penerjemahan bahasa isyarat.',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center, // Pusatkan teks
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 111, 111, 1.0), // Warna hijau
        ),
      ),
    );
  }

  Widget _buildStudentInfoCard(String name, String identifier) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(7), // Padding yang dikurangi dalam kartu
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ), // Ukuran font disesuaikan
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4), // Jarak yang dikurangi antara elemen teks
          Text(
            identifier,
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerInfoCard(String name) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(7), // Padding yang dikurangi dalam kartu
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ), // Ukuran font disesuaikan
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
