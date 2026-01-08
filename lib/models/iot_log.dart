// lib/models/iot_log.dart
class IotLog {
  final int? id; // รหัส (Database สร้างให้เอง)
  final String title; // หัวข้อเรื่อง
  final String note; // บันทึกช่วยจำ
  final String codeSnippet; // โค้ด Arduino
  final String? imagePath; // ที่อยู่ไฟล์รูปภาพในเครื่อง
  final String date; // วันที่บันทึก

  IotLog({
    this.id,
    required this.title,
    required this.note,
    required this.codeSnippet,
    this.imagePath,
    required this.date,
  });

  // แปลงข้อมูลเป็น Map (เพื่อบันทึกลง SQL)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'codeSnippet': codeSnippet,
      'imagePath': imagePath,
      'date': date,
    };
  }

  // แปลงจาก Map กลับเป็น Object (เพื่อเอามาโชว์ในแอพ)
  factory IotLog.fromMap(Map<String, dynamic> map) {
    return IotLog(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      codeSnippet: map['codeSnippet'],
      imagePath: map['imagePath'],
      date: map['date'],
    );
  }
}
