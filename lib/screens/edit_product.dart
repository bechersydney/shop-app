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

  Product _editedProduct = Product(
      id: DateTime.now().toString(),
      title: '',
      description: '',
      price: 0.0,
      imageUrl: '');

  void _saveForm() {
    _form.currentState!.save();
    print(_editedProduct.id);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.title);
    print(_editedProduct.imageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
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
    final _productProvider = Provider.of<ProductsProvider>(context);
    // final _productId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
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
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: ' Title',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: ' Price',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    labelText: ' Description',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                    );
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
                          labelStyle: TextStyle(
                            color: Colors.purple,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value,
                          );
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
