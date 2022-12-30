import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];
  //var _showFavoritesOnly = false;   //FILTERS GLOBALLY

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    //GETTER TO ACCESS DATA FROM _PRIVATE
    /* if (_showFavoritesOnly) {    //FILTERS GLOBALLY
      //RETURNS LIST WITH ONLY FAVORITED ITEMS
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    } */
    return [..._items]; //RETURN ALL ITEMS
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /* void showFavoritesOnly() {      //METHODS TO SHOW FAVORITES OR ALL, CALLED IN PRODUCTS OVERVIEW
    _showFavoritesOnly = true;    //FILTERS GLOBALLY
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;   //FILTERS GLOBALLY
    notifyListeners();
  } */

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shop-c0e34-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-shop-c0e34-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken'); //CONNECTING FAVORITES TO USER
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach(
        (key, value) {
          loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
            imageUrl: value['imageUrl'],
          ));
        },
      );
      _items = loadedProducts;
      notifyListeners();
      //print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-c0e34-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          //ADDS A PRODUCT IN FIREBASE REALTIME_DB
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      print(json
          .decode(response.body)); //GOT IN CONSOLE {name: -NJjTHuY7SCafFSOaD7A}
      final newProduct = Product(
          id: json
              .decode(response.body)['name'], //ADDS THE AUTO_ID FROM FIREBASE
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      //_items.insert(0, newProduct); //AT THE START OF THE LIST
      notifyListeners(); //FROM 'with ChangeNotifier' SENDS INFO TO LISTENERS
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    //UPDATES PRODUCT ON FIREBASE
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-c0e34-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
      http.patch(url,
          body: json.encode({
            //UPDATES A PRODUCT IN FIREBASE REALTIME_DB
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  /* void updateProduct(String id, Product newProduct) {   //UPDATES PRODUCT LOCALLY
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  } */

  void deleteProduct(String id) {
    //DELETES ON DB
    final url = Uri.parse(
        'https://flutter-shop-c0e34-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    http.delete(url);
    notifyListeners();
  }

  /* void deleteProduct(String id) {   //DELETES LOCALLY
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  } */
}
