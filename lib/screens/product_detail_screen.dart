import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  /* final String title;

  ProductDetailScreen({
    this.title = "",
  }); */

  static const routeName = '/product-detail'; //NAME TO USE IN MAIN ROUTE

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments
        as String; //GETS THE ID OF PRODUCT FROM ROUTE ARGUMENTS
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,    //DO NOT REBUILD ON CHANGES, DEACTIVATE LISTENER
    ).findById(productId); //GETS THE SPECIFIC PRODUCT
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
