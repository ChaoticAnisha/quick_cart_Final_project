import 'package:flutter/material.dart';
import 'package:quick_cart/core/constants/app_routes.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 1;

  final grocerykitchen = [
    {"img": "image 41.png", "text": "Vegetables & \nFruits"},
    {"img": "image 42.png", "text": "Atta, Dal & \nRice"},
    {"img": "image 43.png", "text": "Oil, Ghee & \nMasala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread & \nMilk"},
    {"img": "image 45 (1).png", "text": "Biscuits & \nBakery"},
  ];

  final secondgrocery = [
    {"img": "image 33.png", "text": "Dry Fruits &\n Cereals"},
    {"img": "image 34.png", "text": "Kitchen &\n Appliances"},
    {"img": "image 35.png", "text": "Tea & \nCoffees"},
    {"img": "image 36.png", "text": "Ice Creams & \nmuch more"},
    {"img": "image 37.png", "text": "Noodles & \nPacket Food"},
  ];

  final snacksanddrinks = [
    {"img": "image 54.png", "text": "Chips &\n Namkeens"},
    {"img": "image 55.png", "text": "Sweets & \nChocolates"},
    {"img": "image 57.png", "text": "Drinks & \nJuices"},
    {"img": "image 60.png", "text": "Sauces &\n Spreads"},
    {"img": "image 61.png", "text": "Beauty &\n Cosmetics"},
  ];

  final household = [
    {"img": "image 38.png", "text": "Cleaning\nSupplies"},
    {"img": "image 39.png", "text": "Bathroom\nEssentials"},
    {"img": "image 40.png", "text": "Home\nCare"},
    {"img": "image 50.png", "text": "Paper\nProducts"},
    {"img": "image 51.png", "text": "Laundry\nItems"},
  ];

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.cart);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section with Gradient
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText(
                                "QuickCart in",
                                14,
                                FontWeight.w400,
                                Colors.white,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildText(
                                    "16 minutes",
                                    22,
                                    FontWeight.bold,
                                    Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  _buildText(
                                    "HOME - Your Location",
                                    12,
                                    FontWeight.w300,
                                    Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.profile);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFFFA500),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSearchBar(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Grocery & Kitchen Section
              _buildSectionTitle("Grocery & Kitchen"),
              const SizedBox(height: 10),
              _buildHorizontalList(grocerykitchen),

              const SizedBox(height: 15),
              _buildHorizontalList(secondgrocery),

              const SizedBox(height: 30),

              // Snacks & Drinks Section
              _buildSectionTitle("Snacks & Drinks"),
              const SizedBox(height: 10),
              _buildHorizontalList(snacksanddrinks),

              const SizedBox(height: 30),

              // Household Essentials Section
              _buildSectionTitle("Household Essentials"),
              const SizedBox(height: 10),
              _buildHorizontalList(household),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search categories",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.search, color: Colors.grey, size: 22),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.mic, color: Colors.grey, size: 22),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, String>> items) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFFFF8DC),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/images/${items[index]["img"]}",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                if (items[index].containsKey("text"))
                  Text(
                    items[index]["text"]!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildText(String text, double size, FontWeight weight, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: weight, color: color),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFFA500),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
