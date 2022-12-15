import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  /* final String id;
  final String title;
  final String imageUrl;
  final double price;

  const ProductItem(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl,
      required this.price}); */

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);  //GETS THE SPECIFIC PRODUCT
    return ClipRRect(       //CHANGES BORDER OF IT'S CHILD
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(   //ADDS ONTAP TO IMAGE
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,    //PASS ID AS ARGUMENT TO ACCESS DATA
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.start,
          ),
          trailing: IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),  //CHECKS IF ISFAVORITE IS TOGGLED TO USE DIFERENT ICONS ON EACH CASES
            onPressed: () {
              product.toggleFavoriteStatus();   //USES FUNCTION FROM PRODUCT.PROVIDER
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text('€${product.price}',
            textAlign: TextAlign.start,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
