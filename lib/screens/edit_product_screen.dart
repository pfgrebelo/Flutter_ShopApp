import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode(); //TO SAVE URL IMAGE ON CHANGE FOCUS
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode
        .addListener(_updateImageUrl); //UPDATE IMAGE URL ON CHANGE FOCUS
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(
        _updateImageUrl); //CLEARS LISTENER FOR MEMORY PERFORMANCE
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    //METHOD TO UPDATE IMAGE URL ON CHANGE FOCUS
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            //FOR LONGER LISTS, INSTEAD OF LISTVIEW, USE A Column (combined with SingleChildScrollView)
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please write the title.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: newValue.toString(),
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(newValue.toString()),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: newValue.toString(),
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode:
                          _imageUrlFocusNode, //TO SAVE URL IMAGE ON CHANGE FOCUS
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue.toString(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
