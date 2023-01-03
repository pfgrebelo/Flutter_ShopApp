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
      listen: false, //DO NOT REBUILD ON CHANGES, DEACTIVATE LISTENER
    ).findById(productId); //GETS THE SPECIFIC PRODUCT
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Hero(                //LINKED ANIMATED IMAGE FROM PRODUCT ITEM(ProductsOverviewScreen)
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '€${loadedProduct.price}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
