import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sql_lite/helper/constant.dart';
import 'package:sql_lite/model/user_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDb();
      return _database!;
    }
  }

  Future<Database> initDb() async {
    String path = p.join(await getDatabasesPath(), "UserData.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return db.execute('''
          CREATE TABLE $userTable (
            $uid INTEGER PRIMARY KEY AUTOINCREMENT,
            $uname TEXT NOT NULL,
            $uphone TEXT NOT NULL,
            $uemial TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insert(UserModle user) async {
    var dataclient = await database;
    await dataclient.insert(userTable, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateUser(UserModle user) async {
    var db = await database;
    await db.update(userTable, user.toJson(),
        where: '$uid=?', whereArgs: [user.id]);
  }

  Future<UserModle?> getUser(int id) async {
    var db = await database;
    List<Map<String, dynamic>> data =
        await db.query(userTable, where: '$uid=?', whereArgs: [id]);
    if (data.length > 0) {
      return UserModle.fromJson(data.first);
    } else {
      return null;
    }
  }

  Future<List<UserModle>> getAllUsers() async {
    var db = await database;
    List<Map<String, dynamic>> data = await db.query(userTable);
    return data.isNotEmpty
        ? data.map((e) => UserModle.fromJson(e)).toList()
        : [];
  }

  Future<void> delete(int? id) async {
    var db = await database;
    await db.delete(userTable, where: '$uid=?', whereArgs: [id]);
  }
}
