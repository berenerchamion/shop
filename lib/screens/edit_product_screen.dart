import 'package:flutter/material.dart';
import '../providers/product_provider.dart';

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

  Product _product = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
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

  void _saveProduct() {
    _form.currentState.save();
    print('Product: ${_product.title} Price: ${_product.price} Description: ${_product.description} ImageUrl: ${_product.imageUrl}');
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
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
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
                  );
                },
              ), //TextFormField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _product = Product(
                    id: _product.id,
                    title: _product.title,
                    price: double.parse(value),
                    description: _product.description,
                    imageUrl: _product.imageUrl,
                  );
                },
              ), //TextFormField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
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
                  );
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
                            child:
                                Image.network(_imageUrlController.text.trim()),
                            fit: BoxFit.cover,
                          ),
                  ), //Container
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
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
                        );
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
