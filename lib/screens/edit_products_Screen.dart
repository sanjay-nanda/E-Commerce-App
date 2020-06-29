import '../provider/product.dart';
import '../provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products-screen ';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusNode = FocusNode();
  final _descriptionfocusNode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, description: '', imageUrl: '', price: 0.0, title: '');
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _init = true;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .items
            .firstWhere((element) => element.id == productId);
        _initValue = {
          'title': _editedProduct.title,
          'imageUrl': '',
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlcontroller.text = _editedProduct.imageUrl;
      }
      _init = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlcontroller.text.isEmpty ||
          (!_imageUrlcontroller.text.startsWith('http') &&
              !_imageUrlcontroller.text.startsWith('https')) ||
          (!_imageUrlcontroller.text.endsWith('.png') &&
              !_imageUrlcontroller.text.endsWith('.jpeg') &&
              !_imageUrlcontroller.text.endsWith('.jpg'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final _valid = _form.currentState.validate();

    if (!_valid) {
      return;
    }

    _form.currentState.save();
    if (_editedProduct.id != null) {
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _pricefocusNode.dispose();
    _descriptionfocusNode.dispose();
    _imageUrlcontroller.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  initialValue: _initValue['title'],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_pricefocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        title: value,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the name!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  initialValue: _initValue['price'],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _pricefocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionfocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value),
                        title: _editedProduct.title);
                  },
                  validator: (value) {
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number!';
                    }
                    if (value.isEmpty) {
                      return 'Please enter the price!';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  initialValue: _initValue['description'],
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionfocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        description: value,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        title: _editedProduct.title);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Should be atleast 10 characters';
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
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlcontroller.text.isEmpty
                          ? Text('Enter a valid Url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlcontroller.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'ImageUrl'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlcontroller,
                        focusNode: _imageFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              description: _editedProduct.description,
                              imageUrl: value,
                              price: _editedProduct.price,
                              title: _editedProduct.title);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field cannot be empty!';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpeg') &&
                              !value.endsWith('.jpg')) {
                            return 'Please enter an image URL.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
