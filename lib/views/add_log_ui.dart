// lib/views/add_log_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/iot_log.dart';
import '../utils/database_helper.dart';

class AddLogUI extends StatefulWidget {
  final IotLog?
      log; // 1. เพิ่มตัวรับข้อมูล (ถ้ามีค่า = แก้ไข, ถ้า null = เพิ่มใหม่)

  const AddLogUI({super.key, this.log});

  @override
  State<AddLogUI> createState() => _AddLogUIState();
}

class _AddLogUIState extends State<AddLogUI> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _codeController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // 2. เช็คว่าถ้าเป็นโหมดแก้ไข ให้ดึงข้อมูลเก่ามาใส่ในช่อง
    if (widget.log != null) {
      _titleController.text = widget.log!.title;
      _noteController.text = widget.log!.note;
      _codeController.text = widget.log!.codeSnippet;
      if (widget.log!.imagePath != null) {
        _selectedImage = File(widget.log!.imagePath!);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _saveLog() async {
    if (_titleController.text.isEmpty) return;

    // 3. สร้าง Object โดยใช้ ID เดิม (ถ้าเป็นการแก้ไข)
    final log = IotLog(
      id: widget.log?.id, // ถ้าแก้ใช้ ID เดิม, ถ้าเพิ่มใหม่ id จะเป็น null
      title: _titleController.text,
      note: _noteController.text,
      codeSnippet: _codeController.text,
      imagePath: _selectedImage?.path,
      date: DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.now()), // อัปเดตเวลาล่าสุด
    );

    // 4. เลือกว่าจะ Create หรือ Update
    if (widget.log == null) {
      await DatabaseHelper.instance.create(log);
    } else {
      await DatabaseHelper.instance.update(log);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // เปลี่ยนชื่อหัวข้อตามโหมด
        title: Text(widget.log == null ? 'เพิ่มบันทึกใหม่' : 'แก้ไขบันทึก'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: _saveLog, icon: const Icon(Icons.save))
        ],
      ),
      // ... (ส่วน Body โค้ดเหมือนเดิมทุกประการ ไม่ต้องแก้) ...
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('ถ่ายรูป'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('เลือกจากอัลบั้ม'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          Text('แตะเพื่อเพิ่มรูปวงจร/ผลลัพธ์'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'หัวข้อเรื่อง', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'บันทึกความเข้าใจ', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _codeController,
              maxLines: 8,
              style: GoogleFonts.firaCode(),
              decoration: const InputDecoration(
                  labelText: 'โค้ด Arduino',
                  border: OutlineInputBorder(),
                  filled: true),
            ),
          ],
        ),
      ),
    );
  }
}
