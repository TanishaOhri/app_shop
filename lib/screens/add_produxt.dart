import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class Addproduct extends StatefulWidget {
  Addproduct({Key? key}) : super(key: key);
  static const routeName = '/add-product';

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final _pricefocus = FocusNode();
  final _descripfocus = FocusNode();
  TextEditingController _imageUrlController = TextEditingController();
  final _imgFocus = FocusNode();
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    imageurl: null,
    description: null,
    price: null,
    title: null,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };
  var _isInit = true;

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_edittedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id!, _edittedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_edittedProduct)!;
      } catch (error) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(error.toString()),
                  actions: [
                    ElevatedButton
                    (
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _imgFocus.addListener(updateImgUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _edittedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _edittedProduct.title!,
          'description': _edittedProduct.description!,
          'price': _edittedProduct.price!.toString(),
          'imageurl': '',
        };
        _imageUrlController.text = _edittedProduct.imageurl!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImgUrl() {
    if (!_imgFocus.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
              !_imageUrlController.text.startsWith('http') &&
                  !_imageUrlController.text.startsWith('https')
          // ||
          // !_imageUrlController.text.endsWith('.png') &&
          //     !_imageUrlController.text.endsWith(' .jpg') &&
          //     !_imageUrlController.text.endsWith('.jpeg')
          ) return;

      setState(() {});
    }
  }

  void dispose() {
    _imgFocus.removeListener(updateImgUrl);

    _pricefocus.dispose();
    _descripfocus.dispose();
    _imageUrlController.dispose();
    _imgFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: primary,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            labelText: "Title",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_pricefocus);
                          },
                          onSaved: (value) {
                            _edittedProduct = Product(
                              title: value,
                              price: _edittedProduct.price,
                              description: _edittedProduct.description,
                              imageurl: _edittedProduct.imageurl,
                              id: _edittedProduct.id,
                              isFav: _edittedProduct.isFav,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            labelText: "Price",
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _pricefocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descripfocus);
                          },
                          onSaved: (value) {
                            _edittedProduct = Product(
                              title: _edittedProduct.title,
                              price: double.parse(value.toString()),
                              description: _edittedProduct.description,
                              imageurl: _edittedProduct.imageurl,
                              id: _edittedProduct.id,
                              isFav: _edittedProduct.isFav,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid number";
                            }
                            if (double.parse(value) <= 0) {
                              return "Please enter a number > 0";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: "Desription",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a description";
                            }
                            if (value.length < 10) {
                              return "Should be atleast 10 characters long";
                            }
                            return null;
                          },
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descripfocus,
                          onSaved: (value) {
                            _edittedProduct = Product(
                              title: _edittedProduct.title,
                              price: _edittedProduct.price,
                              description: value,
                              imageurl: _edittedProduct.imageurl,
                              id: _edittedProduct.id,
                              isFav: _edittedProduct.isFav,
                            );
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.h,
                              margin: EdgeInsets.only(top: 8.h, right: 10.w),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text("Enter URL")
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter image Url";
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return "Please enter a valid url";
                                  }
                                  // if (!value.endsWith('.png') &&
                                  //     !value.endsWith(' .jpg') &&
                                  //     !value.endsWith('.jpeg')) {
                                  //   return "Please enter a valid url";
                                  // }
                                  return null;
                                },
                                focusNode: _imgFocus,
                                onSaved: (value) {
                                  _edittedProduct = Product(
                                    title: _edittedProduct.title,
                                    price: _edittedProduct.price,
                                    description: _edittedProduct.description,
                                    imageurl: value,
                                    id: _edittedProduct.id,
                                    isFav: _edittedProduct.isFav,
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  // _saveForm();
                                },
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primary)),
                          onPressed: () {
                            _saveForm();
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
