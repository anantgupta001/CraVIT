import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/cart_provider.dart'; // Import CartProvider
import 'package:cravit/cart_page.dart'; // Import CartPage
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:cravit/favorite_provider.dart'; // Import FavoriteProvider
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/services.dart' show rootBundle; // Import for loading assets

// Data model for a menu item
class MenuItem {
  final String name;
  final double price;
  bool isFavorite; // Add this field
  double? rating; // Add this field

  MenuItem({required this.name, required this.price, this.isFavorite = false, this.rating});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
}

// Data model for a shop
class Shop {
  final String name;
  final String imageUrl;
  final List<MenuItem> menu;
  final String category;
  final double? rating;
  final int? reviewCount;
  final String? location;

  Shop({required this.name, required this.imageUrl, required this.menu, this.category = 'General', this.rating, this.reviewCount, this.location});

  factory Shop.fromJson(Map<String, dynamic> json) {
    var menuList = json['menu'] as List;
    List<MenuItem> menuItems = menuList.map((i) => MenuItem.fromJson(i)).toList();

    return Shop(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String? ?? 'General',
      menu: menuItems,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      location: json['location'] as String?,
    );
  }
}

class ShopPage extends StatefulWidget {
  final String? shopCategory;
  const ShopPage({super.key, this.shopCategory});

  static Future<List<Shop>> _loadShopData() async {
    final String response = await rootBundle.loadString('assets/shops_data.json');
    final List<dynamic> jsonData = jsonDecode(response);
    return jsonData.map((shop) => Shop.fromJson(shop)).toList();
  }

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Shop> _shops = [];

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    List<Shop> loadedShops = await ShopPage._loadShopData();
    setState(() {
      _shops = loadedShops;
      if (widget.shopCategory != null) {
        _shops = _shops.where((shop) => shop.category == widget.shopCategory).toList();
      }
    });
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Shop name
                    if (shop.location != null) ...[
                      const SizedBox(height: 4.0), // Spacing between name and location
                      Text(shop.location!,
                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)), // Shop location
                    ],
                  ],
                ),
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

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white, // Dark background color from image
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250.0, // Adjusted height for shop details
              toolbarHeight: 60.0, // Standard height for the toolbar when collapsed
              collapsedHeight: 60.0, // Height when fully collapsed
              floating: false,
              pinned: true,
              backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white, // Dark background color
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black), // Back button
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // Align title to the center
                titlePadding: const EdgeInsets.only(bottom: 20.0), // Adjust padding to position content correctly
                background: Container(
                  color: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 60.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
                      children: [
                        Text(
                          widget.shop.name, // Removed '!' as it can be non-nullable
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 32.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        if (widget.shop.rating != null && widget.shop.reviewCount != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Center rating horizontally
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: Colors.green[700], // Green background for rating
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.shop.rating!.toStringAsFixed(1)}',
                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.star, color: Colors.white, size: 14),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                '${widget.shop.reviewCount} ratings',
                                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                        ],
                        if (widget.shop.location != null)
                          Row( // Wrap location in a Row to center it
                            mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.blueGrey[700] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on, color: isDarkMode ? Colors.white70 : Colors.deepOrange, size: 18),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      widget.shop.location!,
                                      style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                title: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Calculate the scroll percentage
                    double currentHeight = constraints.biggest.height;
                    double maxHeight = MediaQuery.of(context).padding.top + kToolbarHeight; // Standard app bar height
                    double scrollPercentage = 1 - ((currentHeight - kToolbarHeight) / (250.0 - kToolbarHeight));

                    // Adjust visibility based on scrollPercentage
                    if (scrollPercentage > 0.8) { // When mostly collapsed, show shop name
                      return Text(
                        widget.shop.name,
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20.0),
                      );
                    } else { // When expanded, show nothing in the title, details are in background
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Changed color to differentiate from top
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: const SizedBox(height: 32.0), // Increased space above the search bar
              ),
              // Search bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search menu...',
                      prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white70 : Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.blueGrey[700] : Colors.grey[200],
                      hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: _filteredMenu.length,
                itemBuilder: (context, index) {
                  final menuItem = _filteredMenu[index];
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
                                Text(
                                  menuItem.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black, // Adjust based on theme
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                if (menuItem.rating != null) // Display rating if available
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: isDarkMode ? Colors.amberAccent : Colors.amber, size: 16), // Adjust based on theme
                                      Text(
                                        '${menuItem.rating!.toStringAsFixed(1)} ratings', // Display actual rating
                                        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14), // Adjust based on theme
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${menuItem.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
