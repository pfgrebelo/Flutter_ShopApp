import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/auth.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //TO ADD MULTI PROVIDERS
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          //.value(...INSTEAD OF CONSTRUCTOR, CREATE(ctx)=>Products(), CAN USE VALUE IN CASE OF SINGLE ITEM OF GRIDS OR LISTS
          //value: Products(),
          create: (context) => Products('', '', []),
          update: (context, auth, previous) => Products(auth.token.toString(),
              auth.userId.toString(), previous == null ? [] : previous.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(), //WIDGET FROM PROVIDER PACKAGE
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previous) => Orders(auth.token.toString(),
              auth.userId.toString(), previous == null ? [] : previous.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop2',
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
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            })
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ), //CHECKS HOMESCREEN IF AUTHENTICATED
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
