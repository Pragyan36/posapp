import 'package:path/path.dart';
import 'package:pos_app/models/bill.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();


  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
  // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), 'posapp.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){

      },
      onCreate: ( Database db, int version)async{
       await db.execute("CREATE TABLE POSCOLLECTION("
       "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
       "LITER TEXT NOT NULL,"
       "PRICE TEXT NOT NULL,"
       "FUELTYPE TEXT NOT NULL,"
       "DATE TEXT NOT NULL"
       ")");
         
      },
    );
  }
  insertbill(Bill newEntries) async {
  final db = await database;

  var res = await db.insert("POSCOLLECTION", newEntries.toJson());

  if (res != -1) {
    print("Data inserted successfully with ID: $res");
    var insertedData = await db.query("POSCOLLECTION", where: "ID = ?", whereArgs: [res]);
    if (insertedData.isNotEmpty) {
      print("Inserted Data: ${insertedData.first}");
    } else {
      print("Failed to fetch inserted data");
    }
    return {
      "message": "Data inserted successfully",
        "id": res,
    } ;
    
    
  } else {
    print("Failed to insert data");
    return "Failed to insert data"; 
  }
}
  Future<List<Bill>> getbill() async {
  final db = await database;
  var res = await db.query("POSCOLLECTION");
  print("Bills    : $res"); 
  
  List<Bill> list =
      res.isNotEmpty ? res.map((c) => Bill.fromJson(c)).toList() : [];
    print("err $list");
  return list;

}


}