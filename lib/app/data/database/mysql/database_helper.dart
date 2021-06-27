// import 'dart:io';

// import 'package:app/app/utils/helper/echo.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final _databaseName = "elba2al_5.db";
//   static final _databaseVersion = 3;

//   static final table = 'cart';

//   static final columnId = 'id';
//   static final columnProductId = 'productId';
//   static final columnNameEn = 'nameEn';
//   static final columnNameAr = 'nameAr';
//   static final columnPrice = 'price';
//   static final columnFragmentation = 'fragmentation';
//   static final columnNewPrice = 'newPrice';
//   static final columnImage = 'image';
//   static final columnQty = 'qty';
//   static final columnShopId = 'shopId';

//   // make this a singleton class
//   DatabaseHelper._privateConstructor();

//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // only have a single app-wide reference to the database
//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     // lazily instantiate the db the first time it is accessed
//     _database = await _initDatabase();
//     return _database;
//   }

//   // this opens the database (and creates it if it doesn't exist)
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
//   }

//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//             $columnProductId INTEGER NOT NULL,
//             $columnShopId INTEGER NOT NULL,
//             $columnFragmentation INTEGER NOT NULL,
//             $columnQty DOUBLE NOT NULL,
//             $columnNameEn TEXT NOT NULL,
//             $columnNameAr TEXT NOT NULL,
//             $columnPrice DOUBLE NOT NULL,
//             $columnNewPrice DOUBLE NOT NULL,
//             $columnImage TEXT NOT NULL
//           )
//           ''');
//   }


//   Future<int> insert(Map<String, dynamic> row) async {
//     Echo('insert');
//     row.forEach((key, value) {
//       Echo('key $key value $value');
//     });
//     Database db = await instance.database;
//     return await db.insert(table, row);
//   }

//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }

//   Future<int> queryRowCount() async {
//     Database db = await instance.database;
//     return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
//   }

//   Future<List<Map<String, dynamic>>> select(int productId) async {
//     Database db = await instance.database;
//     return await db.query(table, where: '$columnProductId = ?', whereArgs: [productId]);
//   }
//   Future<List<Map<String, dynamic>>> firstProduct() async {
//     Database db = await instance.database;
//     return await db.query(table, where: '$columnProductId > ?', whereArgs: [0]);
//   }

//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[columnProductId];
//     return await db.update(table, row, where: '$columnProductId = ?', whereArgs: [id]);
//   }

//   // Deletes the row specified by the id. The number of affected rows is
//   // returned. This should be 1 as long as the row exists.
//   Future<int> removeByProductId(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnProductId = ?', whereArgs: [id]);
//   }



//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnProductId > ?', whereArgs: [id]);
//   }
// }
