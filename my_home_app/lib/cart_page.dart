import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay Flutter
import 'package:provider/provider.dart';
import 'package:cravit/cart_provider.dart';
import 'package:cravit/shop_page.dart'; // For MenuItem
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cravit/cart_provider.dart' show CartItem; // Explicitly import CartItem

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: ${response.paymentId!}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: ${response.code} - ${response.message!}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}");
  }

  void openCheckout(double amount) async {
    var options = {
      'key': 'rzp_test_RWad9ZcPyJVPw3', // Replace with your actual Razorpay Key ID
      'amount': (amount * 100).toInt(), // Amount in smallest currency unit (e.g., paise for INR)
      'name': 'Food App',
      'description': 'Food Order',
      'prefill': {
        'contact': '8888888888', // Pre-fill with user's contact
        'email': 'test@razorpay.com' // Pre-fill with user's email
      },
      'external': {
        'wallets': ['paytm', 'gpay', 'phonepe', 'bhim'] // Explicitly list UPI wallets
      },
      'method': {
        'upi': true, // Enable UPI payment method
        'card': false,
        'netbanking': false,
        'wallet': false,
        'emi': false,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black), // Custom back button
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Cart',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold), // Bold title
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // Adjust app bar based on theme
        elevation: 0, // Remove shadow
        centerTitle: false, // Align title to the left
      ),
      body: Stack(
        children: [
          cart.items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 24, color: isDarkMode ? Colors.white70 : Colors.black54),
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
                        isDarkMode: isDarkMode, // Pass isDarkMode to _CartItemWidget
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
                if (cart.items.isEmpty) {
                  return SizedBox.shrink(); // Hide the checkout button when cart is empty
                }
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.blueGrey[800] : Color(0xFFFEECE7), // Adjust background for bottom bar
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PAY USING',
                            style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.black54),
                          ),
                          Text(
                            'GPAY',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          openCheckout(cart.totalAmount);
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
                                Text(
                                  '\$ Total Amount',
                                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
                                ),
                                Text(
                                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8.0),
                            Text(
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
  final bool isDarkMode;

  const _CartItemWidget({required this.cartItem, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isDarkMode ? Colors.blueGrey[100] : Color(0xFFFEECE7), // Light pink color from image
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                    Text(
                      '\$${cartItem.menuItem.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.black54 : Colors.white70),
                    ),
                    Text(
                      'Edit >',
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.orange : Colors.amberAccent),
                    ), // Placeholder for Edit
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: isDarkMode ? Colors.white : Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: isDarkMode ? Colors.black : Colors.white),
                            onPressed: () {
                              cartProvider.decrementItem(cartItem.menuItem.name, cartItem.shopName);
                            },
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.black : Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: isDarkMode ? Colors.black : Colors.white),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.black : Colors.white),
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
                  icon: Icon(Icons.edit_note, color: isDarkMode ? Colors.black54 : Colors.white70),
                  label: Text('Add a note for the order', style: TextStyle(color: isDarkMode ? Colors.black54 : Colors.white70)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDarkMode ? Colors.black38 : Colors.white38), // Border color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
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
