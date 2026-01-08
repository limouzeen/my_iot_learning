import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import ให้ตรงกับชื่อโปรเจกต์ของคุณ
import 'package:flutter_application_1/views/home_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Learning Log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ตั้งค่าสีหลักเป็นสีเขียว Teals แบบ IoT
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00ADB5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // เรียกใช้ Google Fonts ตรงนี้
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // เรียกใช้หน้า HomeUI จากโฟลเดอร์ views
      home: const HomeUI(),
    );
  }
}
