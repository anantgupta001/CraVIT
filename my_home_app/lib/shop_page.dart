import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/cart_provider.dart'; // Import CartProvider
import 'package:cravit/cart_page.dart'; // Import CartPage
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:cravit/favorite_provider.dart'; // Import FavoriteProvider

// Data model for a menu item
class MenuItem {
  final String name;
  final double price;
  bool isFavorite; // Add this field

  MenuItem({required this.name, required this.price, this.isFavorite = false});
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
        menu.add(MenuItem(name: itemName, price: itemPrice, isFavorite: false)); // Initialize isFavorite to false
      }
      _shops.add(Shop(name: shopName, imageUrl: imageUrl, menu: menu));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Shop', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: ListView.builder(
          itemCount: _shops.length,
          itemBuilder: (context, index) {
            final shop = _shops[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Changed margin to only vertical
              color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust card color based on theme
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(shop.imageUrl),
                ),
                title: Text(shop.name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust text color
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<MenuItem> _filteredMenu = [];

  @override
  void initState() {
    super.initState();
    _filteredMenu = widget.shop.menu; // Initialize with all menu items
    _searchController.addListener(_filterMenu);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMenu);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMenu() {
    setState(() {
      _searchQuery = _searchController.text;
      if (_searchQuery.isEmpty) {
        _filteredMenu = widget.shop.menu;
      } else {
        _filteredMenu = widget.shop.menu.where((item) {
          // Use regex for case-insensitive search
          final regex = RegExp(_searchQuery, caseSensitive: false);
          return regex.hasMatch(item.name);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return DefaultTabController(
      length: 1, // Only "Food Menu" tab now
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white, // Dark background color from image
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0, // Reduced height to bring the orange box higher
                floating: true, // Allow the app bar to float
                pinned: true,
                snap: true, // Snap to the collapsed or expanded state
                backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white, // Dark background color
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black), // Back button
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 90.0), // Adjusted padding to position name below back arrow and above orange box
                  title: Text(
                    widget.shop.name.toUpperCase(), // SHOP NAME
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                            Icon(Icons.broken_image, color: isDarkMode ? Colors.grey : Colors.grey[700], size: 80), // Adjust based on theme
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              isDarkMode ? const Color(0xFF1A1A2E) : Colors.white.withOpacity(0.8), // Adjust based on theme
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0), // Height of the TabBar
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.blueGrey[800] : const Color(0xFFFEECE7), // Orange background from image
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: TabBar(
                      indicatorColor: isDarkMode ? Colors.amber : Colors.deepOrange, // Orange indicator for selected tab
                      labelColor: isDarkMode ? Colors.white : Colors.black, // Black text for selected tab
                      unselectedLabelColor: isDarkMode ? Colors.grey : Colors.grey[600], // Grey text for unselected tabs
                      tabs: const [
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
                color: isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFFEECE7), // Orange background from image
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // Changed to vertical padding
                  itemCount: _filteredMenu.length + 3, // +3 for Search, Today's Special, and Today's Special Card
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0), // Added horizontal padding
                        child: TextField(
                          controller: _searchController, // Assign the controller
                          decoration: InputDecoration(
                            hintText: 'Search dishes, restaurants',
                            hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]), // Adjust based on theme
                            prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]), // Adjust based on theme
                            filled: true,
                            fillColor: isDarkMode ? Colors.blueGrey[700] : Colors.white, // Adjust based on theme
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Adjust text color
                        ),
                      );
                    } else if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0), // Added horizontal padding
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Today's Special",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.grey[800], // Adjust based on theme
                            ),
                          ),
                        ),
                      );
                    } else if (index == 2) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0), // Added horizontal padding
                        color: isDarkMode ? Colors.blueGrey[800] : Colors.white, // Adjust card color based on theme
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black, // Adjust based on theme
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Aloo Paratha',
                                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87), // Adjust based on theme
                              ),
                              Text(
                                'Chutney',
                                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87), // Adjust based on theme
                              ),
                              Text(
                                'Dahi',
                                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87), // Adjust based on theme
                              ),
                              Text(
                                'Egg',
                                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87), // Adjust based on theme
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final menuItem = _filteredMenu[index - 3]; // Adjust index for the added widgets
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0), // Added horizontal padding
                        color: isDarkMode ? Colors.blueGrey[800] : Colors.white, // Adjust card color based on theme
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
                                    Row( // Wrap Text and IconButton in a Row
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out title and icon
                                      children: [
                                        Text(
                                          menuItem.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : Colors.black, // Adjust based on theme
                                          ),
                                        ),
                                        Consumer<FavoriteProvider>(
                                          builder: (context, favoriteProvider, child) {
                                            bool isFav = favoriteProvider.isFavorite(menuItem);
                                            return IconButton(
                                              icon: Icon(
                                                isFav ? Icons.favorite : Icons.favorite_border,
                                                color: isFav ? Colors.red : (isDarkMode ? Colors.white70 : Colors.black54),
                                              ),
                                              onPressed: () {
                                                favoriteProvider.toggleFavorite(menuItem);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: isDarkMode ? Colors.amberAccent : Colors.amber, size: 16), // Adjust based on theme
                                        Text(
                                          '193 ratings',
                                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14), // Adjust based on theme
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '\$${menuItem.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black, // Adjust based on theme
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Bahut mehenat krke banai hain ...',
                                      style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14), // Adjust based on theme
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
                                      color: isDarkMode ? Colors.blueGrey[700] : Colors.grey[200], // Adjust based on theme
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        widget.shop.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, color: isDarkMode ? Colors.grey[400] : Colors.grey, size: 40), // Adjust based on theme
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
                                            color: isDarkMode ? Colors.orange[700] : Colors.orange, // Adjust based on theme
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
                                                  content: Text('Item added to cart', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust based on theme
                                                  backgroundColor: isDarkMode ? Colors.black87 : Colors.blueGrey[100], // Adjust based on theme
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  margin: const EdgeInsets.all(10.0),
                                                  action: SnackBarAction(
                                                    label: 'View Cart',
                                                    textColor: isDarkMode ? Colors.amber : Colors.orange, // Adjust based on theme
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
                                              backgroundColor: isDarkMode ? Colors.green[700] : Colors.green, // Adjust based on theme
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
