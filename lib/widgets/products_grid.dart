import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);  //LINKS THE LISTENER TO THE PROVIDER
    final products = productsData.items;  //GETS THE DATA FROM THE PROVIDER
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //COLUMNS
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), //DEFINES HOW THE GRID IS STRUCUTRED (LIKE, HOW MANY COLUMNS)
      itemBuilder: (context, i) => ProductItem(
        id: products[i].id,
        title: products[i].title,
        imageUrl: products[i].imageUrl,
        price: products[i].price,
      ), //BUILDS WHATS SEEN ON THE SCREEN
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}