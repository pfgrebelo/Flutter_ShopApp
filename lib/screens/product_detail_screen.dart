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
      /* appBar: AppBar(
        title: Text(loadedProduct.title),
      ), */
      body: Scrollbar(
        thumbVisibility: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Stack(children: [  //STACK FOR TEXT STROKE, 1st THE STROKE, 2nd THE FILL
                  Text(
                    loadedProduct.title,
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    loadedProduct.title,
                    style: TextStyle(
                      foreground: Paint()     //FILLED TEXT WITH GRADIENT
                        ..shader = LinearGradient(
                          colors: <Color>[
                            Colors.indigo,
                            Colors.white,
                            Colors.blue
                            //add more color here.
                          ],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                        ..style,
                    ),
                    //
                  ),
                ]),
                background: Hero(
                  //LINKED ANIMATED IMAGE FROM PRODUCT ITEM(ProductsOverviewScreen)
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Text(
                    '€${loadedProduct.price}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
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
                  SizedBox(height: 800),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
