import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../widgets/loading_spinner.dart';

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

  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;
  var _isDialogShown = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != 'newProduct') {
        _editedProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title!,
          'description': _editedProduct.description!,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

  Future<void> _saveForm() async {
    final isValidated = _formkey.currentState!.validate();

    if (!isValidated) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: const Text('Product updated successfully!')));

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        _isDialogShown = true;
        await showDialog<void>(
            context: context,
            builder: ((ctx) => AlertDialog(
                  title: const Text('An error occured!'),
                  content: const Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Okay'))
                  ],
                )));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();

        if (!_isDialogShown) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: const Text('Product added')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color sec2Color = const Color.fromARGB(255, 50, 128, 52);
    bool sysTheme = ThemeData.light().useMaterial3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: sec2Color),
        title: Text(
          'Edit Product',
          style: TextStyle(color: sec2Color),
        ),
      ),
      body: _isLoading
          ? const LoadingSpinner(
              text: 'Loading...',
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: sysTheme == true ? Colors.black : Colors.white,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
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
                      style: TextStyle(
                        color: sysTheme == true ? Colors.black : Colors.white,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
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
                      style: TextStyle(
                        color: sysTheme == true ? Colors.black : Colors.white,
                      ),
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
                              ? Text(
                                  'Enter URL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: sysTheme == true
                                        ? Colors.black
                                        : Colors.white,
                                  ),
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
                            /* You can have an initialValue and a controller at the set time. 
                      To set the initial value, set it at the controller.*/
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
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
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                  isFavourite: _editedProduct.isFavourite);
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
                            style: TextStyle(
                                color: sysTheme ? Colors.black : Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 125,
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(backgroundColor: sec2Color),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
