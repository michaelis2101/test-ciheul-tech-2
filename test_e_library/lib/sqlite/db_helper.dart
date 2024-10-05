import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_e_library/model/book_model.dart';
import 'package:test_e_library/model/user_model.dart';
// import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._internal();

  static const String databaseName = 'database.db';

  static const int versionNumber = 1;

  // static const String tableNotes = 'Notes'

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        added_by TEXT NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        description TEXT,
        pdf_path TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> createNewUser(UserModel param) async {
    Database db = await database;

    return await db.insert('Users', param.toJson());
    // return await db.insert('Books', book.toMap());
  }

  Future<int> insertBook(Book book) async {
    Database db = await database;
    return await db.insert('Books', book.toMap());
  }

  Future<List<UserModel>> getAllUser() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db.query('Users');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<List<UserModel>> login(String username, String pw) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, pw],
    );
    return maps.map((map) => UserModel.fromJson(map)).toList();
  }

  Future<List<UserModel>> getLoggedUser(int uid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'id = ?',
      whereArgs: [uid.toString()],
    );
    return maps.map((map) => UserModel.fromJson(map)).toList();
  }

  Future<List<Book>> getAllBooks(int uid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('Books', where: 'added_by = ?', whereArgs: [uid]);
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  Future<List<Book>> getOneBook(int bookid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('Books', where: 'id = ?', whereArgs: [bookid]);
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  // Search for books by title or author
  Future<List<Book>> searchBooks(String query, int uid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Books',
      where: 'title LIKE ? OR author LIKE ? AND added_by = ?',
      whereArgs: ['%$query%', '%$query%', uid],
    );
    return maps.map((map) => Book.fromMap(map)).toList();
  }
  // Future<List<Book>> searchBooks(String query) async {
  //   Database db = await database;

  //   // Use the updated query with parentheses to correctly evaluate conditions
  //   List<Map<String, dynamic>> maps = await db.query(
  //     'Books',
  //     where: 'title LIKE ? OR author LIKE ?',
  //     whereArgs: [
  //       '%$query%',
  //       '%$query%',
  //     ], // Search for books by title/author for the specific user
  //   );

  //   return maps.map((map) => Book.fromMap(map)).toList();
  // }

  Future<int> updateBook(Book book) async {
    Database db = await database;
    return await db.update(
      'Books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    Database db = await database;
    return await db.delete(
      'Books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    Database db = await database;
    return await db.update(
      'Books',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Book>> getFavoriteBooks(int uid) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Books',
      where: 'is_favorite = 1 AND added_by = ?',
      whereArgs: [uid]
    );
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
