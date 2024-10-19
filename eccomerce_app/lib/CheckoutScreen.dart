import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eccomerce_app/cartprovider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'COD'; // Default payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Cash on Delivery'),
                leading: Radio<String>(
                  value: 'COD',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Online Payment'),
                leading: Radio<String>(
                  value: 'Online',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the checkout
                    Provider.of<CartProvider>(context, listen: false)
                        .clearCart();
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Order Confirmed'),
                          content:
                              Text('Your order has been placed successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
