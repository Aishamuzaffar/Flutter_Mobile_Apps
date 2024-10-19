// ignore: file_names

import 'package:eccomerce_app/CheckoutScreen.dart';
import 'package:eccomerce_app/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.cartItems.isEmpty) {
            return Center(
              child: Text("Your cart is empty"),
            );
          }

          var cartItems = cart.cartItems;
          var uniqueCartItems = <String, Map<String, dynamic>>{};
          cartItems.forEach((product) {
            if (uniqueCartItems.containsKey(product['id'].toString())) {
              uniqueCartItems[product['id'].toString()]!['quantity'] += 1;
            } else {
              uniqueCartItems[product['id'].toString()] = {
                'product': product,
                'quantity': 1,
              };
            }
          });

          var total = uniqueCartItems.values.fold(0.0, (sum, item) {
            return sum + (item['product']['price'] * item['quantity']);
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: uniqueCartItems.length,
                  itemBuilder: (context, index) {
                    var item = uniqueCartItems.values.elementAt(index);
                    var product = item['product'];
                    var quantity = item['quantity'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Image.network(
                          product['image'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product['title']),
                        subtitle: Text("\$${product['price']} x $quantity"),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            cart.removeFromCart(product['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
