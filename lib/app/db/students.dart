import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentapp/app/core/student.dart';

class StudentDatabase {
  static final StudentDatabase _studentDatabase = StudentDatabase._internal();
  static StudentDatabase get instance => _studentDatabase;
  static Database? db;

  static const String table = 'students';

  // Get database instance
  Future<Database> get database async {
    if (db != null) {
      return db!;
    }

    db = await _init();
    return db!;
  }

  // Initialize database
  Future<Database> _init() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'mavystudent.db'),
      onCreate: (db, version) async {
        // First time the database is created
        await db.execute("CREATE TABLE $table (id INTEGER PRIMARY KEY, name TEXT, image BLOB, course TEXT)");
        await db.execute("CREATE TABLE settings (id INTEGER PRIMARY KEY, name TEXT, value TEXT)");

        // Insert dark mode setting
        await db.insert("settings", {"name": "dark_mode", "value": "0"});
      },
      version: 1
    );
  }  

  // Get students
  Future<List<Student>> getStudents() async {
    final List<Map<String, Object?>> result = await (await database).query(table);
    return result.map((e) => Student.fromMap(e)).toList();
  }

  // Add student
  Future<int> addStudent(Student student) async {
    return await (await database).insert(table, student.toMap());
  }

  // Delete student
  Future<bool> deleteStudent(Student student) async {
    return await (await database).delete(table, where: "id = ?", whereArgs: [student.id]) > 0;
  }

  // Update dark mode setting
  void updateDarkmode(bool isDarkMode) async {
    await (await database).update("settings", {"value": isDarkMode ? "1" : "0"}, where: "name = ?", whereArgs: ["dark_mode"]);
  }
  
  /// Get dark mode setting
  Future<bool> getDarkMode() async {
    final List<Map<String, Object?>> result = await (await database).query("settings", where: "name = ?", whereArgs: ["dark_mode"]);
    return result.first["value"] == "1" ? true : false;
  }

  StudentDatabase._internal();
}