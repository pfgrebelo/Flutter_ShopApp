import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductsGrid(this.showFavorites);


  @override
  Widget build(BuildContext context) {
    final productsData =
        Provider.of<Products>(context); //LINKS THE LISTENER TO THE PROVIDER
    final products = showFavorites ? productsData.favoriteItems : productsData.items; //GETS THE DATA FROM THE PROVIDER
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //COLUMNS
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), //DEFINES HOW THE GRID IS STRUCUTRED (LIKE, HOW MANY COLUMNS)
      itemBuilder: (context, i) => ChangeNotifierProvider.value(  //USE VALUE INSTEAD OF BUILDER(CREATE) IN CASE OF LISTS OR GRIDS
        value: products[i],
        //create: (context) => products[i],
        child: ProductItem(
          /* id: products[i].id,
          title: products[i].title,
          imageUrl: products[i].imageUrl,
          price: products[i].price, */
        ),
      ), //BUILDS WHATS SEEN ON THE SCREEN
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
