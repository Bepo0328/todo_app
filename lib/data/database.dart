import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/data/todo.dart';

class DatabaseHelper {
  static const _databaseName = 'todo.db';
  static const _databaseVersion = 1;
  static const todoTable = 'todo';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $todoTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title String,
      memo String,
      category String,
      color INTEGER,
      done INTEGER,
      date INTEGER DEFAULT 0,
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Future<int> insertTodo(Todo todo) async {
      Database? db = await instance.database;

      if (todo.id == null) {
        Map<String, dynamic> row = {
          'title': todo.title,
          'memo': todo.memo,
          'category': todo.category,
          'color': todo.color,
          'done': todo.done,
          'date': todo.date,
        };

        return await db!.insert(todoTable, row);
      } else {
        Map<String, dynamic> row = {
          'title': todo.title,
          'memo': todo.memo,
          'category': todo.category,
          'color': todo.color,
          'done': todo.done,
          'date': todo.date,
        };

        return await db!
            .update(todoTable, row, where: 'id = ?', whereArgs: [todo.id]);
      }
    }
  }

  Future<List<Todo>> getAllTodo() async {
    Database? db = await instance.database;
    List<Todo> todos = [];

    var queries = await db!.query(todoTable);

    for (var q in queries) {
      todos.add(Todo(
        id: q['id'] as int?,
        title: q['title'] as String?,
        memo: q['memo'] as String?,
        category: q['category'] as String?,
        color: q['color'] as int?,
        done: q['done'] as int?,
        date: q['date'] as int?,
      ));
    }

    return todos;
  }

  Future<List<Todo>> getTodoByDate(int date) async {
    Database? db = await instance.database;
    List<Todo> todos = [];

    var queries =
        await db!.query(todoTable, where: 'date = ?', whereArgs: [date]);

    for (var q in queries) {
      todos.add(Todo(
        id: q['id'] as int?,
        title: q['title'] as String?,
        memo: q['memo'] as String?,
        category: q['category'] as String?,
        color: q['color'] as int?,
        done: q['done'] as int?,
        date: q['date'] as int?,
      ));
    }

    return todos;
  }
}
