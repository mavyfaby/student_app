import 'package:sqflite/sqflite.dart';

class StudentDatabase {
  static final StudentDatabase _studentDatabase = StudentDatabase._internal();
  static Database? db;

  factory StudentDatabase(Database d) {
    db = d;
    init();
    return _studentDatabase;
  }

  static void init() async {
    
  }  

  StudentDatabase._internal();
}