import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // Disposing the focus nodes after using them prevents memory leaks.
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.svg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValidated = _formkey.currentState!.validate();
    if (!isValidated) {
      return;
    }
    _formkey.currentState!.save();
    print(editedProduct.title);
    print(editedProduct.description);
    print(editedProduct.price);
    print(editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: null,
                      title: value,
                      description: editedProduct.description,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required Field';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: null,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required Field';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a value greater than zero';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  editedProduct = Product(
                      id: null,
                      title: editedProduct.title,
                      description: value,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required Field';
                  }
                  if (value.length < 10) {
                    return 'Should be more than 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? const Text(
                            'Enter URL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : FittedBox(
                            child: Container(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: null,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Enter a valid URL';
                        }
                        if (!value.endsWith('.jpeg') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.svg')) {
                          return 'Enter a valid image URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                    onPressed: _saveForm, child: const Text('Save')),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
