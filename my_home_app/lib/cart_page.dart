import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_home_app/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Custom back button
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Bold title
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
        centerTitle: false, // Align title to the left
      ),
      body: Stack(
        children: [
          cart.items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 100.0, left: 16.0, right: 16.0), // Added horizontal padding here
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return _CartItemWidget(
                        cartItem: cartItem,
                      );
                    },
                  ),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEECE7), // Light pink background for the bottom bar
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'PAY USING',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            'GPAY',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle place order
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange, // Orange color from image
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '\$ Total Amount',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'Place Order >',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const _CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color(0xFFFEECE7), // Light pink color from image
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.menuItem.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${cartItem.menuItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const Text(
                      'Edit >',
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ), // Placeholder for Edit
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.black),
                            onPressed: () {
                              cartProvider.decrementItem(cartItem.menuItem.name, cartItem.shopName);
                            },
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              cartProvider.addItem(cartItem.menuItem, cartItem.shopName);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '\$${(cartItem.menuItem.price * cartItem.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle add note
                  },
                  icon: const Icon(Icons.edit_note, color: Colors.black54),
                  label: const Text('Add a note for the order', style: TextStyle(color: Colors.black54)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black38), // Border color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    cartProvider.removeItem(cartItem.menuItem.name, cartItem.shopName);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
