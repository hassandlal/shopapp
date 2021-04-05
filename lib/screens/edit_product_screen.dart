import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = ProductProvider(
    id: null,
    title: '',
    description: '',
    price: 0,
    imgUrl: '',
  );
  var _initialValues = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': ''
  };
  var _isLoading = false;
  var _isInit = true;

  initState() {
    super.initState();
    _imgUrlFocusNode.addListener(_updateImageUrl);
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imgUrl': '', //_editedProduct.imgUrl,
        };
        _imgUrlController.text = _editedProduct.imgUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if ((_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('http')) ||
          (!_imgUrlController.text.endsWith('.png') &&
              !_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error Occurred'),
                  content: Text('Something Went Wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('ok'))
                  ],
                ));
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imgUrl: _editedProduct.imgUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['price'],
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'price',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        if (double.tryParse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imgUrl: _editedProduct.imgUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['description'],
                      decoration: InputDecoration(
                        labelText: 'description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'the description must be more than 10 letters';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imgUrl: _editedProduct.imgUrl);
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
                          )),
                          child: _imgUrlController.text.isEmpty
                              ? Text('Enter a url')
                              : FittedBox(
                                  child: Image.network(
                                    _imgUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imgUrlController,
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            focusNode: _imgUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please enter a vaild url';
                              }
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'please enter a vaild url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = ProductProvider(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imgUrl: value);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
        title: Text('Edit Product'),
      ),
    );
  }
}
