import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';
import '../screens/user_products_screen.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  //This key makes teh connection between the form
  // elements and access to them outside teh build method
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  //will get initialized below in didChangeDependencies()
  Product _product;

  Product _initValues = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      _product = ModalRoute.of(context).settings.arguments as Product;
      if (_product != null) {
        _initValues = Product(
          id: _product.id,
          title: _product.title,
          price: _product.price,
          description: _product.description,
          imageUrl: '',
        );
        //imageUrl cannot be set in the same way as the others because of the text controller
        //you can't set the initialValue on the field if you have a controller
        //Have to set the controller here instead.
        _imageUrlController.text = _product.imageUrl;
      } else {
        _product = Product(
          id: null,
          title: '',
          price: 0,
          description: '',
          imageUrl: '',
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
    _imageUrlController.text = _imageUrlController.text.trim();
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future <void> _saveProduct() async {
    final bool isValid = _form.currentState.validate();

    if (isValid) {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });

      if (_product.id != null) {
        Provider.of<Products>(
          context,
          listen: false,
        ).updateProduct(_product);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(
            context,
            listen: false,
          ).addProduct(_product);
        } catch (error) {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('An Error Occurred!'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
        }
        finally {
          setState(() {
            _isLoading = false;
          });
          //I like this experience better in terms of where to land after an
          //error in the save call. 
          Navigator.of(context)
              .popAndPushNamed(UserProductsScreen.routeName);
        }
      }
    } else {
      print('Bogus product!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveProduct();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: value.trim(),
                          price: _product.price,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title cannot be an empty string';
                        } else {
                          return null;
                        }
                      },
                    ), //TextFormField
                    TextFormField(
                      initialValue: _initValues.price.toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: double.parse(value),
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You need to enter a price';
                        } else if (double.tryParse(value) != null) {
                          if (double.parse(value) <= 0.00) {
                            return 'A price has to be greater than zero.';
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ), //TextFormField
                    TextFormField(
                      initialValue: _initValues.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        errorStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          price: _product.price,
                          description: value.trim(),
                          imageUrl: _product.imageUrl,
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 25) {
                          return 'Come on, you need a decent description!';
                        } else {
                          return null;
                        }
                      },
                    ), //TextFormField
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ), //BoxDecoration
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                      _imageUrlController.text.trim()),
                                  fit: BoxFit.cover,
                                ),
                        ), //Container
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                              errorStyle: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            //"_" tells flutter to ignore the parameter
                            onFieldSubmitted: (_) {
                              _saveProduct();
                            },
                            onSaved: (value) {
                              _product = Product(
                                id: _product.id,
                                title: _product.title,
                                price: _product.price,
                                description: _product.description,
                                imageUrl: value.trim(),
                                isFavorite: _product.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Image URL cannot be empty.';
                              } else if (!value.startsWith('https://')) {
                                return 'Hey, wake up https is required these days!.';
                              } else if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Hey, what kind of image is that? PNG or JPEG please.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ), //Row
                  ],
                ), //ListView
              ),
            ), //Padding
    );
  }
}
