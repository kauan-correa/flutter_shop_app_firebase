import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = <String, Object?>{};
  bool _isLoading = false;
  Product? product;

  void _updateImage() {
    setState(() {});
  }

  void _saveForm() async {
    if (!_form.currentState!.validate()) return;

    _form.currentState!.save();
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    final newProduct = Product(
      id: product?.id ?? Random().nextDouble().toString(),
      title: _formData["title"] as String,
      description: _formData["description"] as String,
      price: _formData["price"] as double,
      imageUrl: _formData["imageUrl"] as String,
    );

    setState(() {
      _isLoading = true;
    });

    late String message;
    bool success = false;
    try {
      if (product == null) {
        success = await productsProvider.addProduct(newProduct);
        message = success ? "Product created!" : "Error creating product!";
      } else {
        productsProvider.updateProduct(newProduct);
        success = true;
        message = "Product updated!";
      }
    } catch (error) {
      message = "An unexpected error occurred.";
    }
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));

    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImage);
  }

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)?.settings.arguments as Product?;
    _imageUrlController.text = product == null ? "" : product!.imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Form"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: product == null ? "" : product!.title,
                      decoration: const InputDecoration(
                        label: Text("Title"),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData["title"] = value,
                      validator: (value) {
                        return value!.trim().isEmpty
                            ? "Title is required"
                            : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        initialValue:
                            product == null ? "" : product!.price.toString(),
                        decoration: const InputDecoration(
                          label: Text("Price"),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) =>
                            _formData["price"] = double.parse(value!),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Price is required";
                          }
                          if (double.tryParse(value) == null) {
                            return "Invalid price";
                          }
                          if (double.parse(value) <= 0) {
                            return "Price must be greater than 0";
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: product == null ? "" : product!.description,
                      decoration: const InputDecoration(
                        label: Text("Description"),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageFocusNode);
                      },
                      onSaved: (value) => _formData["description"] = value,
                      validator: (value) => value!.trim().isEmpty
                          ? "Description is required"
                          : null,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Image URL"),
                              errorStyle: TextStyle(color: Colors.red),
                            ),
                            textInputAction: TextInputAction.done,
                            focusNode: _imageFocusNode,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _formData["imageUrl"] = value,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Image URL is required";
                              }
                              if (!Uri.tryParse(value)!.hasAbsolutePath) {
                                return "Invalid URL";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "Invalid URL";
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return "Invalid image URL";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  "Preview",
                                  textAlign: TextAlign.center,
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      "Invalid URL",
                                      textAlign: TextAlign.center,
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
