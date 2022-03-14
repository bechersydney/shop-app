import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false, // do not listen if notifylistener is called
    ).getProductById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
