import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart'; // ธีมโค้ดสีขาวสะอาด
import 'package:google_fonts/google_fonts.dart';

import '../models/iot_log.dart';
import 'add_log_ui.dart';

class DetailUI extends StatefulWidget {
  final IotLog log; // รับข้อมูลมาโชว์

  const DetailUI({super.key, required this.log});

  @override
  State<DetailUI> createState() => _DetailUIState();
}

class _DetailUIState extends State<DetailUI> {
  late IotLog currentLog;

  @override
  void initState() {
    super.initState();
    currentLog = widget.log;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียด"),
        actions: [
          // ปุ่มแก้ไข (รูปดินสอ)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // กดแล้วส่งข้อมูลปัจจุบันไปที่หน้า AddLogUI (โหมดแก้ไข)
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLogUI(log: currentLog),
                ),
              );

              // ถ้าแก้ไขเสร็จแล้ว (result == true) ให้ปิดหน้านี้กลับไป Home เพื่อรีเฟรช
              if (result == true) {
                if (mounted) Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. รูปภาพ (ถ้ามี)
            if (currentLog.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(currentLog.imagePath!),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // 2. หัวข้อ และ วันที่
            Text(
              currentLog.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "บันทึกเมื่อ: ${currentLog.date}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 30),

            // 3. เนื้อหาบันทึก
            const Text("📝 บันทึก:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              currentLog.note,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // 4. โค้ด Arduino (พระเอกของเรา)
            const Text("💻 Code:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              // ใช้ HighlightView แสดงโค้ดสีสวยๆ
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: HighlightView(
                  currentLog.codeSnippet,
                  language: 'cpp', // Arduino ใช้ภาษา C++
                  theme: githubTheme, // เลือกธีมได้ (draculaTheme, githubTheme)
                  padding: const EdgeInsets.all(12),
                  textStyle: GoogleFonts.firaCode(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
