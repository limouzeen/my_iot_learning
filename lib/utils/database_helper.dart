import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/iot_log.dart'; // import model

class DatabaseHelper {
  // สร้าง Singleton (ให้มี Database ตัวเดียวทั้งแอพ)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // เรียกใช้ Database (ถ้ายังไม่มีให้สร้างใหม่)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('iot_learning.db'); // ชื่อไฟล์ DB ในเครื่อง
    return _database!;
  }

  // ฟังก์ชันเปิด/สร้าง Database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // สร้างตารางเก็บข้อมูล (รันแค่ครั้งแรกที่ติดตั้งแอพ)
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE logs ( 
        id $idType, 
        title $textType,
        note $textType,
        codeSnippet $textType,
        imagePath $textNullable,
        date $textType
      )
    ''');
  }

  // --- ฟังก์ชันใช้งานจริง ---

  // 1. เพิ่มข้อมูลใหม่ (Create)
  Future<int> create(IotLog log) async {
    final db = await instance.database;
    return await db.insert('logs', log.toMap());
  }

  // 2. ดึงข้อมูลทั้งหมด (Read All)
  Future<List<IotLog>> readAllLogs() async {
    final db = await instance.database;
    final result =
        await db.query('logs', orderBy: 'date DESC'); // เรียงใหม่ -> เก่า
    return result.map((json) => IotLog.fromMap(json)).toList();
  }

  // 3. ลบข้อมูล (Delete)
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. อัปเดตข้อมูล (Update)
  Future<int> update(IotLog log) async {
    final db = await instance.database;
    return db.update(
      'logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id], // อัปเดตเฉพาะแถวที่มี id ตรงกัน
    );
  }

  // 5. ค้นหาข้อมูล (Search) - ค้นหาใน Title, Note, และ Code
  Future<List<IotLog>> searchLogs(String keyword) async {
    final db = await instance.database;
    final result = await db.query(
      'logs',
      // ใช้ LIKE %...% เพื่อหาข้อความที่ "มีคำนี้ผสมอยู่"
      where: 'title LIKE ? OR note LIKE ? OR codeSnippet LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
      orderBy: 'date DESC',
    );
    return result.map((json) => IotLog.fromMap(json)).toList();
  }
}
