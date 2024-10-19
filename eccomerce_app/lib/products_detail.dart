import 'package:eccomerce_app/cartprovider.dart';
import 'package:eccomerce_app/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eccomerce_app/CartScreen.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  const ProductDetails(this.id);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Map<String, dynamic>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ApiService().getSingleProduct(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (snapshot.hasData) {
                var product = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product['image'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        product['title'],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Chip(
                        label: Text(
                          product['category'].toString().toUpperCase(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        backgroundColor: Colors.blueGrey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        product['description'],
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return FloatingActionButton(
            child: Icon(Icons.add_shopping_cart, color: Colors.white),
            backgroundColor: Colors.deepPurple,
            onPressed: () async {
              try {
                var product = await _productFuture;
                cart.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart'),
                ));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to add to cart: $error'),
                ));
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
