import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/product.dart';
import 'package:shop_app/models/providers/products.dart';
import 'package:shop_app/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;
  const UserProductItem(this._product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              _product.imageUrl,
            ),
          ),
          title: Text(
            _product.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Colors.green,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName,
                        arguments: _product.id);
                  },
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.error,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: RichText(
                              text: TextSpan(
                                text: 'Are you sure to delete ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: _product.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            title: const Text('Confirm'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'NO',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .deleteProductById(_product.id);
                                  } catch (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Delete Failed!'),
                                      ),
                                    );
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'YES',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
