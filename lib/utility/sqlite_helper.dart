import 'package:shoppingmall/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //join();

class SQLiteHelper {
  final String nameDatabase = 'shoppingmall.db';
  final int version = 1;
  final String tableDatabase = 'myTableOrder';
  final String columnId = 'id';
  final String columnIdSeller = 'idSeller';
  final String columnIdProduct = 'idProduct';
  final String columnName = 'name';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLiteHelper() {
    initiakDatabase();
  }
  Future<Null> initiakDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnIdSeller TEXT, $columnIdProduct TEXT, $columnName TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT )'),
      version: version,
    );
  }

  Future<Database> connectdDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Database database = await connectdDatabase();
    List<SQLiteModel> result = [];
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    print('### map on SQLiteHelper => $maps');
    for (var item in maps) {
      SQLiteModel model = SQLiteModel.fromMap(item);
      result.add(model);
    }
    return result;
  }

  Future<Null> insertValueToSQLite(SQLiteModel sqLiteModel) async {
    Database database = await connectdDatabase();
    await database
        .insert(tableDatabase, sqLiteModel.toMap())
        .then((value) => print('###Insert ${sqLiteModel.name} Success'));
  }
}
