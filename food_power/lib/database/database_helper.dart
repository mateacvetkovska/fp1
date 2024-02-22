import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Order.dart';
import '../models/item.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 4, onCreate: _createDB, onUpgrade: _upgradeDB);
  }


  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE catalog(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT,
        rating REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items(
        id TEXT PRIMARY KEY,
        catalogId TEXT,
        userId TEXT,
        quantity INTEGER,
        FOREIGN KEY (catalogId) REFERENCES catalog(id)
      )
    ''');

    await db.execute('''
  CREATE TABLE orders(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId TEXT,
    totalPrice REAL,
    deliveryAddress TEXT,
    deliveryFee REAL,
    dateTime TEXT,
    isPickup INTEGER
  )
''');

    await db.execute('''
    CREATE TABLE reviews (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT,
      orderId INTEGER,
      photoPath TEXT,
      reviewText TEXT,
      FOREIGN KEY (orderId) REFERENCES orders(id)
    )
  ''');



    await _insertInitialData(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE orders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId TEXT,
          totalPrice REAL,
          deliveryAddress TEXT,
          deliveryFee REAL,
          dateTime TEXT,
          isPickup INTEGER
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        orderId INTEGER,
        photoPath TEXT,
        reviewText TEXT,
        FOREIGN KEY (orderId) REFERENCES orders(id)
      )
    ''');
    }
  }



  Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> existingData = await db.query('catalog');
    if (existingData.isEmpty) {
      await db.rawInsert('''
      INSERT INTO catalog (id, name, description, price, imageUrl, rating) VALUES 
      ('1', 'Cheese Burger', 'A delicious cheeseburger with lettuce, tomato, and cheese.', 8.99, 'assets/burger.png', 4.5),
      ('2', 'Steak with Potatoes', 'Grilled steak served with potatoes on the side.', 15.99, 'assets/steak_with_potatoes.png', 4.7),
      ('3', 'Chicken Steak', 'Perfectly cooked chicken steak served with vegetables.', 10.99, 'assets/chicken_steak.png', 4.4),
      ('4', 'Veggie Pizza', 'A delightful pizza topped with olives, bell peppers, onions, and tomatoes.', 12.99, 'assets/veggie_pizza.png', 4.8),
      ('5', 'Spaghetti Carbonara', 'Classic spaghetti carbonara with creamy sauce, bacon, and a sprinkle of parsley.', 11.50, 'assets/spaghetti_carbonara.png', 4.6),
      ('6', 'Caesar Salad', 'Crisp romaine lettuce, Parmesan cheese, and croutons, all tossed in a Caesar dressing.', 9.99, 'assets/caesar_salad.png', 4.2),
      ('7', 'Sushi Platter', 'Assorted sushi platter featuring salmon, tuna, and avocado rolls.', 16.99, 'assets/sushi_platter.png', 4.9),
      ('8', 'BBQ Ribs', 'Tender, slow-cooked ribs coated in a smoky BBQ sauce.', 18.99, 'assets/bbq_ribs.png', 4.8),
      ('9', 'Falafel Wrap', 'A delicious wrap filled with crispy falafel balls, fresh veggies, and tahini sauce.', 8.99, 'assets/falafel_wrap.png', 4.3),
      ('10', 'Mushroom Risotto', 'Creamy risotto with sautéed mushrooms and a touch of Parmesan.', 13.99, 'assets/mushroom_risotto.png', 4.5),
      ('11', 'Pad Thai', 'Authentic Pad Thai with stir-fried rice noodles, shrimp, peanuts, and lime.', 14.50, 'assets/pad_thai.png', 4.6),
      ('12', 'Chocolate Cake', 'Rich and moist chocolate cake topped with chocolate ganache and cherries.', 6.99, 'assets/chocolate_cake.png', 4.9),
      ('13', 'Margarita Cocktail', 'Classic Margarita cocktail with tequila, lime juice, and Cointreau.', 7.99, 'assets/margarita_cocktail.png', 4.7),
      ('14', 'French Fries', 'Crispy golden French fries served with a side of ketchup.', 4.99, 'assets/french_fries.png', 4.1);
    ''');
    }
  }

  Future<void> clearCart(String userId) async {
    final db = await database;
    await db.delete('cart_items', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> insertReview(String userId, int orderId, String photoPath, String reviewText) async {
    final db = await database;
    Map<String, dynamic> reviewData = {
      'userId': userId,
      'orderId': orderId,
      'photoPath': photoPath,
      'reviewText': reviewText,
    };
    await db.insert('reviews', reviewData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getReviewsByUserId(String userId) async {
    final db = await database;
    List<Map<String, dynamic>> reviews = await db.query(
      'reviews',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return reviews;
  }

  Future<void> addToCart(String catalogId, String userId, int quantity) async {
    final db = await database;
    await db.insert('cart_items', {
      'id': '$catalogId-$userId',
      'catalogId': catalogId,
      'userId': userId,
      'quantity': quantity
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateItemQuantity(String catalogId, String userId, int quantity) async {
    final db = await database;
    await db.update('cart_items', {'quantity': quantity},
        where: 'catalogId = ? AND userId = ?', whereArgs: [catalogId, userId]);
  }

  Future<void> removeItemFromCart(String catalogId, String userId) async {
    final db = await database;
    await db.delete('cart_items', where: 'catalogId = ? AND userId = ?', whereArgs: [catalogId, userId]);
  }

  Future<List<Item>> getCartItems(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    List<Item> items = [];
    for (var map in maps) {
      final catalogMap = await db.query(
        'catalog',
        where: 'id = ?',
        whereArgs: [map['catalogId']],
      );
      if (catalogMap.isNotEmpty) {
        final item = Item.fromMap(catalogMap.first);
        items.add(item.copyWith(quantity: map['quantity']));
      }
    }
    return items;
  }

  Future<double> getTotalCartPrice(String userId) async {
    final db = await database;
    var total = 0.0;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT SUM(c.price * ci.quantity) as total FROM cart_items ci JOIN catalog c ON ci.catalogId = c.id WHERE ci.userId = ?',
        [userId]
    );
    if (maps.isNotEmpty && maps.first['total'] != null) {
      total = maps.first['total'];
    }
    return total;
  }

  Future<List<Item>> getAllCatalogItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('catalog');

    return maps.map((map) => Item.fromMap(map)).toList();
  }


  Future<int> insertOrder(Order order) async {
    final db = await database;
    final orderMap = order.toMap()..removeWhere((key, value) => key == 'id' && value == null);
    int orderId = await db.insert(
      'orders',
      orderMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return orderId;
  }

  Future<List<Order>> getUserOrders(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: "userId = ?",
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<void> cancelOrder(int orderId) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}