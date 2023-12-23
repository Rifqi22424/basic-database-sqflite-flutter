import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "user_database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db
            .execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)");
      },
    );
  }

  Future<int> insertUser(String name) async {
    Database db = await database;
    return await db.insert("users", {"name": name});
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query("users");
  }
}
