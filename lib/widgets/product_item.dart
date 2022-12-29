import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

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
    //final product = Provider.of<Product>(context);  //GETS THE SPECIFIC PRODUCT
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      //WIDGET CONSUMER TO REPLACE PROVIDER.OF
      builder: (context, product, child) => ClipRRect(
        //CHANGES BORDER OF IT'S CHILD
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            //ADDS ONTAP TO IMAGE
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id, //PASS ID AS ARGUMENT TO ACCESS DATA
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          header: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.start,
            ),
            trailing: IconButton(
              icon: Icon(product.isFavorite
                  ? Icons.favorite
                  : Icons
                      .favorite_border), //CHECKS IF ISFAVORITE IS TOGGLED TO USE DIFERENT ICONS ON EACH CASES
              onPressed: () {
                product
                    .toggleFavoriteStatus(authData.token!, authData.userId); //USES FUNCTION FROM PRODUCT.PROVIDER
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              '€${product.price}',
              textAlign: TextAlign.start,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();    //IF THERE IS AN ACTIVE SNACKBAR TOAST, IT HIDES TO SHOW THE NEW ONE
                ScaffoldMessenger.of(context).showSnackBar(    //REACHS THE NEAREST SCAFFOLD
                  SnackBar(     //ADDS A TOAST BAR BELLOW THE SCAFFOLD
                    content: Text('Added item to cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(label: 'UNDO', onPressed: () {   //REMOVES THE LATEST ITEM ADDED
                      cart.removeSingleItem(product.id);    
                    } ,),
                  ),
                );
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
