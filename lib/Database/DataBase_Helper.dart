import 'dart:async';
import 'dart:io';
import 'package:databaseoffline/Model/Info_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  DatabaseHelper._privateConostructure();
  // database instanse
  static final DatabaseHelper instance = DatabaseHelper._privateConostructure();
  // database create
  static Database? _database;
  // database get

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    //  mobile storage path directory
    Directory documentDirectory = await getApplicationSupportDirectory();

    String path = join(documentDirectory.path,'todos.db');// database name todos
    // return korbe database create
    return await openDatabase(
      path,
      version:1,
      // oncreate
      onCreate: _onCreate,
    );
  }
  FutureOr _onCreate(Database db, int version)async {
    // database TABLE name todos
    print('database created');
    await db.execute("""
            CREATE TABLE todos(
            id INTEGER PRIMARY KEY,
            name STRING,
            degicnation STRING,
           )"""
    );

  }
  // database data inseart

  Future<int> addTodos(Information todo) async{
    print("get insert");

    Database db = await instance.database;

    return await db.insert('todos', todo.toJson());


  }
  // database query
  Future<List<Information>> getTodos()async{
    print("get todos");
    // data base get
    Database db = await instance.database;
    var todos = await db.query('todos',orderBy: "id");
    List<Information> _todos =todos.isNotEmpty ? todos.map((todo) => Information.fromJson(todo)).toList():[];
    print(_todos);
    return _todos;
  }
  // Delete
  Future delteTodo(int id ) async{
    Database db =await instance.database;
    return await db.delete('todos', where: 'id=?' , whereArgs:  [id]);

  }

  // update method




}


