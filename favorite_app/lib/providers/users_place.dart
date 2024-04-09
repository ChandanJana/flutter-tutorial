import 'dart:io';

import 'package:favorite_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/place_location.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'place.db'),
      onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE user_place(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, long REAL, address TEXT)',
    );
  }, version: 1);
  return db;
}

class UsersPlaceNotifier extends StateNotifier<List<Place>> {
  UsersPlaceNotifier() : super(const []);

  Future<void> loadPlace() async {
    final db = await _getDataBase();
    final data = await db.query(
      'user_place',
    );
    print('places data $data');
    final places = data.map((item) {
      return Place(
        id: item['id'] as String,
        title: item['title'] as String,
        image: File(item['image'] as String),
        placeLocation: PlaceLocation(
            latitude: item['lat'] as double,
            longitude: item['long'] as double,
            address: item['address'] as String),
      );
    }).toList();
    print('places $places');
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation placeLocation) async {
    /// Here we storing the image in document folder

    /// Create Document path directory
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    /// Here we find the file name
    final fileName = path.basename(image.path);

    /// Here we copy image one directory to another directory
    final copyImage = await image.copy('${appDir.path}/$fileName');
    final newPlace =
        Place(title: title, image: copyImage, placeLocation: placeLocation);
    final db = await _getDataBase();
    final rowId = await db.insert('user_place', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.placeLocation.latitude,
      'long': newPlace.placeLocation.longitude,
      'address': newPlace.placeLocation.address,
    });
    print('Place Row Id $rowId');

    state = [newPlace, ...state];
  }
}

final userPlaceProvider =
    StateNotifierProvider<UsersPlaceNotifier, List<Place>>(
        (ref) => UsersPlaceNotifier());
