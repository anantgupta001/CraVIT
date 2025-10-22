import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart'; // Import provider
import 'package:my_home_app/cart_provider.dart'; // Import CartProvider
import 'package:my_home_app/cart_page.dart'; // Import CartPage

// Data model for a menu item
class MenuItem {
  final String name;
  final double price;

  MenuItem({required this.name, required this.price});
}

// Data model for a shop
class Shop {
  final String name;
  final String imageUrl;
  final List<MenuItem> menu;

  Shop({required this.name, required this.imageUrl, required this.menu});
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<Shop> _shops = [];

  @override
  void initState() {
    super.initState();
    _generateDummyShops();
  }

  void _generateDummyShops() {
    final List<String> shopNames = [
      'The Grand Cafe', 'Pizza Palace', 'Burger Barn', 'Sushi Spot', 'Taco Town',
      'Noodle Nook', 'Healthy Bites', 'Sweet Treats', 'Coffee Corner', 'Juice Junction'
    ];
    final List<String> foodItems = [
      'Burger', 'Pizza', 'Sushi', 'Taco', 'Noodles', 'Salad', 'Cake', 'Coffee', 'Juice', 'Sandwich'
    ];
    final Random random = Random();

    for (int i = 0; i < 10; i++) {
      final String shopName = shopNames[random.nextInt(shopNames.length)];
      final String imageUrl = 'https://picsum.photos/200/200?random=$i'; // Random image
      final List<MenuItem> menu = [];

      for (int j = 0; j < 5; j++) { // Each shop has 5 random menu items
        final String itemName = foodItems[random.nextInt(foodItems.length)];
        final double itemPrice = (random.nextDouble() * 10 + 5).roundToDouble(); // Price between 5 and 15
        menu.add(MenuItem(name: itemName, price: itemPrice));
      }
      _shops.add(Shop(name: shopName, imageUrl: imageUrl, menu: menu));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: ListView.builder(
        itemCount: _shops.length,
        itemBuilder: (context, index) {
          final shop = _shops[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(shop.imageUrl),
              ),
              title: Text(shop.name),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopDetailPage(shop: shop),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ShopDetailPage extends StatefulWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return DefaultTabController(
      length: 1, // Only "Food Menu" tab now
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E), // Dark background color from image
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0, // Reduced height to bring the orange box higher
                floating: true, // Allow the app bar to float
                pinned: true,
                snap: true, // Snap to the collapsed or expanded state
                backgroundColor: const Color(0xFF1A1A2E), // Dark background color
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Back button
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 90.0), // Adjusted padding to position name below back arrow and above orange box
                  title: Text(
                    widget.shop.name.toUpperCase(), // SHOP NAME
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.shop.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 80)),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xFF1A1A2E),
                            ],
                            stops: [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0), // Height of the TabBar
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEECE7), // Orange background from image
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: const TabBar(
                      indicatorColor: Colors.orange, // Orange indicator for selected tab
                      labelColor: Colors.black, // Black text for selected tab
                      unselectedLabelColor: Colors.grey, // Grey text for unselected tabs
                      tabs: [
                        Tab(text: 'Food Menu'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Food Menu Tab Content
              Container(
                color: const Color(0xFFFEECE7), // Orange background from image
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: widget.shop.menu.length + 3, // +3 for Search, Today's Special, and Today's Special Card
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search dishes, restaurants',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                        ),
                      );
                    } else if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Today's Special",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.shop.name, // Shop Name for Today's Special
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Aloo Paratha',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const Text(
                                'Chutney',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const Text(
                                'Dahi',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const Text(
                                'Egg',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final menuItem = widget.shop.menu[index - 3]; // Adjust index for the added widgets
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menuItem.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: const [
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        Text(
                                          '193 ratings',
                                          style: TextStyle(color: Colors.black54, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '\$${menuItem.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Bahut mehenat krke banai hain ...',
                                      style: TextStyle(color: Colors.black54, fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        widget.shop.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                      ),
                                    ),
                                  ),
                                  Consumer<CartProvider>(
                                    builder: (context, cart, child) {
                                      final existingCartItem = cart.items.firstWhere(
                                        (item) => item.menuItem.name == menuItem.name && item.shopName == widget.shop.name,
                                        orElse: () => CartItem(menuItem: menuItem, shopName: widget.shop.name, quantity: 0),
                                      );

                                      if (existingCartItem.quantity > 0) {
                                        return Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                                                  onPressed: () {
                                                    cart.decrementItem(menuItem.name, widget.shop.name);
                                                  },
                                                ),
                                              ),
                                              Text(
                                                '${existingCartItem.quantity}',
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                                  onPressed: () {
                                                    cart.addItem(menuItem, widget.shop.name);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              cart.addItem(menuItem, widget.shop.name);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Item added to cart', style: TextStyle(color: Colors.white)),
                                                  backgroundColor: Colors.black87,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  margin: const EdgeInsets.all(10.0),
                                                  action: SnackBarAction(
                                                    label: 'View Cart',
                                                    textColor: Colors.orange,
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => const CartPage(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  duration: const Duration(seconds: 3),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                            ),
                                            child: const Text('ADD', style: TextStyle(color: Colors.white, fontSize: 14)),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
