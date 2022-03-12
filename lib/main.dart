import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/auth.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:shop_app/models/providers/order.dart';
import 'package:shop_app/models/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/orders.dart';
import 'package:shop_app/screens/product_detail.dart';
import 'package:shop_app/screens/product_overview.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(), //must be the start
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (context) => ProductsProvider(),
            update: (ctx, authProvider, previousProduct) {
              previousProduct!.updateToken(authProvider.getToken ?? '');
              previousProduct.updateuserId(authProvider.getuserId ?? '');
              return previousProduct;
            },
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (context) => OrdersProvider(),
            update: (ctx, authProvider, previousProvider) {
              previousProvider!.updateToken(authProvider.getToken!);
              previousProvider.updateuserId(authProvider.getuserId!);
              return previousProvider;
            },
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.purple,
              fontFamily: 'QuickSand',
              appBarTheme: AppBarTheme(
                  titleTextStyle: ThemeData.light()
                      .textTheme
                      .copyWith(
                        titleMedium: const TextStyle(
                          fontFamily: 'QuickSand',
                          fontSize: 20,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .titleMedium),
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline1: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    labelMedium: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    headline2: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.amber,
              ).copyWith(
                primary: Colors.amber,
                secondary: Colors.red,
                tertiary: Colors.purple,
              ),
              // inputDecorationTheme: InputDecorationTheme()
            ),
            home: authProvider.isAuthenticated
                ? const ProductOverviewScreen()
                : const AuthScreen(),
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(builder: (ctx) => const AuthScreen());
            },
            routes: {
              AuthScreen.routeName: (_) => const AuthScreen(),
              ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
              CartScreen.routeName: (_) => const CartScreen(),
              OrdersScreen.routeName: (_) => const OrdersScreen(),
              UserProductScreen.routeName: (_) => const UserProductScreen(),
              EditProductScreen.routeName: (_) => const EditProductScreen(),
            },
          ),
        ));
  }
}
