// lib/views/search_log_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/iot_log.dart';
import '../utils/database_helper.dart';
import 'detail_ui.dart';

class LogSearchDelegate extends SearchDelegate {
  // เปลี่ยนข้อความในช่องค้นหา (Hint Text)
  @override
  String? get searchFieldLabel => 'ค้นหาชื่อ, โค้ด, บันทึก...';

  // 1. ปุ่มทางขวา (กากบาทลบคำ)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // ล้างคำค้นหา
          // ถ้าอยากให้ปิดหน้าค้นหาเลยเมื่อกดเคลียร์ ให้ใช้ close(context, null);
        },
      ),
    ];
  }

  // 2. ปุ่มทางซ้าย (ลูกศรย้อนกลับ)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // ปิดหน้าค้นหา
    );
  }

  // 3. แสดงผลลัพธ์ (เมื่อกด Enter) - เราให้ทำงานเหมือนตอนพิมพ์เลย
  @override
  Widget buildResults(BuildContext context) {
    return _buildLogList();
  }

  // 4. แสดงผลลัพธ์ทันทีที่พิมพ์ (Suggestions)
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildLogList();
  }

  // ฟังก์ชันสร้างรายการที่ค้นหาเจอ (ใช้ซ้ำในทั้ง buildResults และ buildSuggestions)
// ฟังก์ชันสร้างรายการที่ค้นหาเจอ (แก้ไขแล้ว)
  Widget _buildLogList() {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            const Text("พิมพ์คำเพื่อค้นหา...",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return FutureBuilder<List<IotLog>>(
      future: DatabaseHelper.instance.searchLogs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("ไม่พบข้อมูลที่ค้นหา"));
        }

        final logs = snapshot.data!;

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: log.imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(log.imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: log.imagePath == null
                    ? const Icon(Icons.code, size: 30, color: Colors.grey)
                    : null,
              ),
              // --- จุดที่แก้ไขคือตรงนี้ครับ ---
              title: Text(
                log.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // ---------------------------
              subtitle: Text(
                log.note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailUI(log: log)),
                );
              },
            );
          },
        );
      },
    );
  }
}
