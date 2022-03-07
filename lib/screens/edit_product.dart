import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/product.dart';
import 'package:shop_app/models/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  // final bool isEdit;
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _imageUrlFocusNode = FocusNode();
  bool _isInit = true;
  bool _isLoading = false;
  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  Map<String, dynamic> _initialValue = {
    'title': '',
    'price': '0.0',
    'description': '',
    'imageURL': ''
  };

  void _saveForm() {
    final _isFormValid = _form.currentState!.validate();
    if (!_isFormValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isEmpty) {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError(
        (err) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occured'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'))
              ],
            ),
          );
        },
      ).then(
        (value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProductById(_editedProduct.id, _editedProduct)
          .then(
        (value) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
  }

  void _updateImageUrl() {
    final value = _imageURLController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!value.startsWith('http') && !value.startsWith('https')) ||
          (!value.endsWith('.png') &&
              !value.endsWith('.jpeg') &&
              !value.endsWith('.jpg'))) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final _productId = ModalRoute.of(context)?.settings.arguments as String;
      if (_productId.isNotEmpty) {
        _editedProduct =
            Provider.of<ProductsProvider>(context).getProductById(_productId);
        _initialValue = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          // 'imageURL': _editedProduct.imageUrl, // you can't use controller and initial value at the same time
        };
        _imageURLController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageURLController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                          initialValue: _initialValue['title'],
                          cursorColor: Colors.purple,
                          decoration: const InputDecoration(
                            // border: InputBorder.none,
                            labelText: ' Title',
                            // labelStyle: TextStyle(
                            //   color: Colors.purple,
                            // ),
                            // // errorStyle: TextStyle(color: Theme.of(context).errorColor),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Colors.purple,
                            //     width: 1,
                            //   ),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Colors.purple,
                            //     width: 1,
                            //   ),
                            // ),
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value!,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        initialValue: _initialValue['price'],
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.purple,
                        decoration: const InputDecoration(
                          // border: InputBorder.none,
                          labelText: ' Price',
                          // labelStyle: TextStyle(
                          //   color: Colors.purple,
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.purple,
                          //     width: 1,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.purple,
                          //     width: 1,
                          //   ),
                          // ),
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Price is required';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        initialValue: _initialValue['description'],
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.purple,
                        decoration: const InputDecoration(
                          labelText: ' Description',
                          // labelStyle: TextStyle(
                          //   color: Colors.purple,
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.purple,
                          //     width: 1,
                          //   ),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.purple,
                          //     width: 1,
                          //   ),
                          // ),
                        ),
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Descripton is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: _imageURLController.text.isEmpty
                                ? const Center(
                                    child: Text('No Image'),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageURLController.text,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _imageUrlFocusNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _saveForm(),
                              keyboardType: TextInputType.url,
                              controller: _imageURLController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                                // labelStyle: TextStyle(
                                //   color: Colors.purple,
                                // ),
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: Colors.purple,
                                //     width: 1,
                                //   ),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: Colors.purple,
                                //     width: 1,
                                //   ),
                                // ),
                              ),
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value!,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Image URL is required';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please input valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.jpg')) {
                                  return 'Please input valid URL';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
