import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/tasks.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<void> deleteCompletedTasks() async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: '$_tasksStatusColumnName = ?',
      whereArgs: [1],
    );
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tasksTableName (
          $_tasksIdColumnName INTEGER PRIMARY KEY,
          $_tasksContentColumnName TEXT NOT NULL,
          $_tasksStatusColumnName INTEGER NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  Future<void> updateTaskContent(int id, String content) async{
    final db = await database;
    await db.update(_tasksTableName, {
      _tasksContentColumnName: content,
    },
    where: 'id = ?', whereArgs: [id]);
  }

  addTask(
      String content,
      ) async {
    final db = await database;
    await db.insert(
      _tasksTableName,
      {
        _tasksContentColumnName: content,
        _tasksStatusColumnName: 0,
      },
    );
  }

  Future<List<Tasks>> getTasks() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<Tasks> tasks = data
        .map(
          (e) => Tasks(
        id: e["id"] as int,
        status: e["status"] as int,
        content: e["content"] as String,
      ),
    )
        .toList();
    return tasks;
  }

  updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {
        _tasksStatusColumnName: status,
      },
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  deleteTask(
      int id,
      ) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}
