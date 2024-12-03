import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      cep TEXT NOT NULL,
      address TEXT NOT NULL,
      number TEXT NOT NULL,
      city TEXT NOT NULL,
      state TEXT NOT NULL
    )
  ''');
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final contacts = await db.query('contacts');
    return contacts.map((contact) => Contact.fromMap(contact)).toList();
  }

  Future<void> insertContact(Contact contact) async {
    final db = await database;
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateContact(Contact contact) async {
    final db = await database;
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('contacts');
  }
}
