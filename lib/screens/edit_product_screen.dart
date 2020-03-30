import 'package:flutter/material.dart';
import 'package:flutter_tutorial_shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key key}) : super(key: key);

  static const routeName = 'edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFoucsNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: null, title:'', price: 0, description: '', imageUrl: '');

  @override
  void dispose(){
    super.dispose();
    //Any listener should be disposed of, to prevent memory leaks
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    //Focus nodes need to be disposed of
    _priceFoucsNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    //Controllers need to be disposed of
    _imageUrlController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    //Execute the _updateImageUrl function when the focus node changes 
    //Using _updateImageUrl and not _updateImageUrl() makes this a pointer to the function.
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl(){
    if(_imageUrlFocusNode.hasFocus){
      if((_imageUrlController.text.isEmpty) || 
      (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) || 
      (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))){
        return;
      }
      setState(() {});
    }
  }

  void _saveForm(){
    final isValid = _form.currentState.validate(); //returns true if none of the vaildators return a value (all return null)
    if(!isValid){
      return;
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {FocusScope.of(context).requestFocus(_priceFoucsNode);}, //Automatically go to next input from this input
                onSaved: (value) {_editedProduct = Product(title: value, price: _editedProduct.price, description: _editedProduct.description, id: null, imageUrl: _editedProduct.imageUrl);},
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFoucsNode, //When focus node is acticated, the user will be naviagated automatically to the next field in the form
                onFieldSubmitted: (_) {FocusScope.of(context).requestFocus(_descriptionFocusNode);},
                onSaved: (value) {_editedProduct = Product(title: _editedProduct.title, price: double.parse(value), description: _editedProduct.description, id: null, imageUrl: _editedProduct.imageUrl);},
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please enter a price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3, //Determines how many lines wil be used for the text field
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {_editedProduct = Product(title: _editedProduct.title, price: _editedProduct.price, description: value, id: null, imageUrl: _editedProduct.imageUrl);},
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please provide a value';
                  }
                  if(value.length < 10){
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right:10),
                    decoration: BoxDecoration(border: Border.all(width:1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty ? Text('Enter a URL') : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover,),
                  ),
                  Expanded(
                                      child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {_saveForm();},
                      onSaved: (value) {_editedProduct = Product(title: _editedProduct.title, price: _editedProduct.price, description: _editedProduct.description, id: null, imageUrl: value);},
                      validator: (value) {
                        if(value.isEmpty){
                          return 'Please provide an image URL';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please enter a valid URL';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                    ),
                  )
                ],
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
