// lib/views/home_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ใช้จัดรูปแบบวันที่
import 'detail_ui.dart';
import '../models/iot_log.dart';
import '../utils/database_helper.dart';
import 'add_log_ui.dart';
import 'search_log_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // ตัวแปรสำหรับรอรับข้อมูลจาก Database
  late Future<List<IotLog>> logsFuture;

  @override
  void initState() {
    super.initState();
    _refreshLogs(); // ดึงข้อมูลทันทีเมื่อเปิดหน้านี้
  }

  // ฟังก์ชันสั่งดึงข้อมูลใหม่
  void _refreshLogs() {
    setState(() {
      logsFuture = DatabaseHelper.instance.readAllLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("บันทึกการเรียนรู้ IoT"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // เรียกใช้ SearchDelegate ที่เราเพิ่งสร้าง
              await showSearch(
                context: context,
                delegate: LogSearchDelegate(),
              );
              // พอกลับมาจากหน้าค้นหา (อาจจะมีการแก้ข้อมูล) ให้รีเฟรชหน้า Home ด้วย
              _refreshLogs();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<IotLog>>(
        future: logsFuture,
        builder: (context, snapshot) {
          // 1. กำลังโหลดข้อมูล
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ถ้ามี Error
          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }

          // 3. ถ้าไม่มีข้อมูลเลย (List ว่าง)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.memory, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("ยังไม่มีบันทึก กด + เพื่อเริ่มเลย",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 4. มีข้อมูล! แสดงรายการด้วย ListView
          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  // รูปภาพด้านซ้าย (ถ้ามีรูปให้โชว์รูป ถ้าไม่มีโชว์ไอคอน)
                  leading: Container(
                    width: 60,
                    height: 60,
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
                        ? const Icon(Icons.code, color: Colors.grey)
                        : null,
                  ),

                  // ชื่อเรื่อง
                  title: Text(
                    log.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // วันที่บันทึก
                  subtitle: Text(
                    log.date, // หรือจะใช้ DateFormat แปลงใหม่อีกทีก็ได้
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),

                  // ปุ่มลบด้านขวา
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // ลบข้อมูลและรีเฟรชหน้าจอ
                      await DatabaseHelper.instance.delete(log.id!);
                      _refreshLogs();
                    },
                  ),

                  // กดที่รายการเพื่อดูรายละเอียด (เดี๋ยวเราไปทำหน้า Detail กัน)
                  onTap: () async {
                    // เมื่อกดที่รายการ ให้ไปหน้า Detail พร้อมส่งข้อมูล log ไปด้วย
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailUI(log: log),
                      ),
                    );

                    // ถ้ากลับมาจาก Detail (อาจจะมีการแก้ไข) ให้รีเฟรชหน้า Home
                    if (result == true) {
                      _refreshLogs();
                    }
                  },
                ),
              );
            },
          );
        },
      ),

      // ปุ่มบวก
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ไปหน้าเพิ่มข้อมูล และรอผลลัพธ์
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLogUI()),
          );

          // ถ้ากลับมาแล้วมีการบันทึกจริง -> รีเฟรชรายการใหม่
          if (result == true) {
            _refreshLogs();
          }
        },
        label: const Text("จดบันทึก"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
