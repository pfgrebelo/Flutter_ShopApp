import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //TO ADD MULTI PROVIDERS
      providers: [
        ChangeNotifierProvider(
          //.value(...INSTEAD OF CONSTRUCTOR, CREATE(ctx)=>Products(), CAN USE VALUE IN CASE OF SINGLE ITEM OF GRIDS OR LISTS
          //value: Products(),
          create: (context) => Products(), //WIDGET FROM PROVIDER PACKAGE
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          textTheme: TextTheme(
            titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            titleMedium: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
            titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
        },
      ),
    );
  }
}
