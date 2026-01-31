import 'package:flutter/material.dart';
import 'package:quick_cart/core/constants/app_routes.dart';

// ==================== UI HELPER CLASS ====================
class UiHelper {
  static Widget CustomImage({required String img}) {
    return Image.asset(
      "assets/images/$img",
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image, color: Colors.grey),
        );
      },
    );
  }

  static Widget CustomText({
    required String text,
    required Color color,
    required FontWeight fontweight,
    String? fontfamily,
    required double fontsize,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontsize,
        fontFamily: fontfamily ?? "regular",
        fontWeight: fontweight,
        color: color,
      ),
    );
  }

  static Widget CustomTextField({required TextEditingController controller}) {
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
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search 'ice-cream'",
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

  static Widget CustomButton(VoidCallback callback, {bool isAdded = false}) {
    return GestureDetector(
      onTap: callback,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 32,
        width: isAdded ? 70 : 65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAdded
                ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                : [const Color(0xFFFFD700), const Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color:
                  (isAdded ? const Color(0xFF4CAF50) : const Color(0xFFFFA500))
                      .withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isAdded ? Icons.check : Icons.add_shopping_cart,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isAdded ? "Added" : "Add",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  Set<int> addedProducts = {};
  Set<int> addedGrocery = {};

  final List<Map<String, String>> diwaliSaleData = [
    {"img": "image 50.png", "text": "Lights, Diyas\n& Candles"},
    {"img": "image 51.png", "text": "Diwali\nGifts"},
    {"img": "image 52.png", "text": "Appliances\n& Gadgets"},
    {"img": "image 53.png", "text": "Home\n& Living"},
    {"img": "image 50.png", "text": "Decorations\n& Rangoli"},
    {"img": "image 51.png", "text": "Sweet\nBoxes"},
    {"img": "image 52.png", "text": "Festival\nLights"},
    {"img": "image 53.png", "text": "Pooja\nItems"},
    {"img": "image 50.png", "text": "Traditional\nDecor"},
    {"img": "image 51.png", "text": "Gift\nHampers"},
  ];

  final List<Map<String, String>> categoryData = [
    {
      "img": "image 54.png",
      "text": "Golden Glass Wooden Lid Candle",
      "time": "16",
      "price": "79",
    },
    {
      "img": "image 57.png",
      "text": "Royal Gulab Jamun By Bikano",
      "time": "16",
      "price": "149",
    },
    {
      "img": "image 63.png",
      "text": "Premium Scented Candle",
      "time": "16",
      "price": "79",
    },
    {
      "img": "image 33.png",
      "text": "Decorative Items Set",
      "time": "20",
      "price": "199",
    },
    {
      "img": "image 34.png",
      "text": "Festive Sweet Box",
      "time": "15",
      "price": "129",
    },
    {
      "img": "image 35.png",
      "text": "Aroma Therapy Candle",
      "time": "18",
      "price": "89",
    },
    {
      "img": "image 36.png",
      "text": "Gift Hamper Special",
      "time": "22",
      "price": "249",
    },
    {
      "img": "image 37.png",
      "text": "Traditional Sweets Pack",
      "time": "12",
      "price": "179",
    },
    {
      "img": "image 38.png",
      "text": "Luxury Candle Set",
      "time": "25",
      "price": "299",
    },
    {
      "img": "image 39.png",
      "text": "Festive Combo Pack",
      "time": "14",
      "price": "159",
    },
    {
      "img": "image 40.png",
      "text": "Premium Gift Set",
      "time": "18",
      "price": "189",
    },
    {
      "img": "image 54.png",
      "text": "Scented Candle Collection",
      "time": "20",
      "price": "119",
    },
    {
      "img": "image 55.png",
      "text": "Deluxe Sweet Platter",
      "time": "15",
      "price": "229",
    },
    {
      "img": "image 60.png",
      "text": "Traditional Diya Set",
      "time": "12",
      "price": "99",
    },
    {
      "img": "image 61.png",
      "text": "Festival Special Pack",
      "time": "16",
      "price": "169",
    },
  ];

  final List<Map<String, String>> groceryKitchenData = [
    {"img": "image 41.png", "text": "Vegetables &\nFruits"},
    {"img": "image 42.png", "text": "Atta, Dal &\nRice"},
    {"img": "image 43.png", "text": "Oil, Ghee &\nMasala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread &\nMilk"},
    {"img": "image 45 (1).png", "text": "Biscuits &\nBakery"},
    {"img": "image 41.png", "text": "Snacks &\nBeverages"},
    {"img": "image 42.png", "text": "Cleaning &\nHousehold"},
    {"img": "image 43.png", "text": "Personal\nCare"},
    {"img": "image 40.png", "text": "Frozen\nFood"},
    {"img": "image 41.png", "text": "Health &\nNutrition"},
    {"img": "image 42.png", "text": "Baby\nCare"},
    {"img": "image 43.png", "text": "Pet\nSupplies"},
  ];

  void _onBottomNavTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.category);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.cart);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  void _showAllDiwaliSale() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllItemsScreen(
          title: "Mega Diwali Sale",
          items: diwaliSaleData,
          type: "diwali",
        ),
      ),
    );
  }

  void _showAllProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllItemsScreen(
          title: "Featured Products",
          items: categoryData,
          type: "products",
        ),
      ),
    );
  }

  void _showAllGrocery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllItemsScreen(
          title: "Grocery & Kitchen",
          items: groceryKitchenData,
          type: "grocery",
        ),
      ),
    );
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UiHelper.CustomText(
                                  text: "QuickCart in",
                                  color: const Color(0xFFFFFFFF),
                                  fontweight: FontWeight.w400,
                                  fontsize: 14,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    UiHelper.CustomText(
                                      text: "16 minutes",
                                      color: const Color(0xFFFFFFFF),
                                      fontweight: FontWeight.bold,
                                      fontsize: 22,
                                      fontfamily: "bold",
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
                                    Expanded(
                                      child: UiHelper.CustomText(
                                        text: "HOME - Your Location",
                                        color: const Color(0xFFFFFFFF),
                                        fontweight: FontWeight.w300,
                                        fontsize: 12,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: UiHelper.CustomTextField(
                        controller: searchController,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Mega Diwali Sale Section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.celebration,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          UiHelper.CustomText(
                            text: "Mega Diwali Sale",
                            color: Colors.white,
                            fontweight: FontWeight.bold,
                            fontsize: 20,
                            fontfamily: "bold",
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.celebration,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Horizontal List
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: diwaliSaleData.length > 4
                            ? 4
                            : diwaliSaleData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: UiHelper.CustomImage(
                                    img: diwaliSaleData[index]["img"]!,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: UiHelper.CustomText(
                                    text: diwaliSaleData[index]["text"]!,
                                    color: Colors.black87,
                                    fontweight: FontWeight.w600,
                                    fontsize: 9,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    // See All Button
                    if (diwaliSaleData.length > 4)
                      TextButton(
                        onPressed: _showAllDiwaliSale,
                        child: const Text(
                          "See All →",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Featured Products Section
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UiHelper.CustomText(
                      text: "Featured Products",
                      color: Colors.black87,
                      fontweight: FontWeight.bold,
                      fontsize: 18,
                      fontfamily: "bold",
                    ),
                    TextButton(
                      onPressed: _showAllProducts,
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFFFA500),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Products Horizontal List
              SizedBox(
                height: 240,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoryData.length > 3 ? 3 : categoryData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: UiHelper.CustomImage(
                                img: categoryData[index]["img"]!,
                              ),
                            ),
                          ),
                          // Product Details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  UiHelper.CustomText(
                                    text: categoryData[index]["text"]!,
                                    color: Colors.black87,
                                    fontweight: FontWeight.w600,
                                    fontsize: 10,
                                    maxLines: 2,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Color(0xFF9C9C9C),
                                          ),
                                          const SizedBox(width: 4),
                                          UiHelper.CustomText(
                                            text:
                                                "${categoryData[index]["time"]} MINS",
                                            color: const Color(0xFF9C9C9C),
                                            fontweight: FontWeight.normal,
                                            fontsize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "₹",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFFA500),
                                                ),
                                              ),
                                              UiHelper.CustomText(
                                                text:
                                                    categoryData[index]["price"]!,
                                                color: const Color(0xFFFFA500),
                                                fontweight: FontWeight.bold,
                                                fontsize: 16,
                                              ),
                                            ],
                                          ),
                                          UiHelper.CustomButton(
                                            () {
                                              setState(() {
                                                if (addedProducts.contains(
                                                  index,
                                                )) {
                                                  addedProducts.remove(index);
                                                } else {
                                                  addedProducts.add(index);
                                                }
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    addedProducts.contains(
                                                          index,
                                                        )
                                                        ? '${categoryData[index]["text"]} added to cart!'
                                                        : '${categoryData[index]["text"]} removed from cart!',
                                                  ),
                                                  backgroundColor: const Color(
                                                    0xFFFFA500,
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            isAdded: addedProducts.contains(
                                              index,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Grocery & Kitchen Section
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UiHelper.CustomText(
                      text: "Grocery & Kitchen",
                      color: Colors.black87,
                      fontweight: FontWeight.bold,
                      fontsize: 18,
                      fontfamily: "bold",
                    ),
                    TextButton(
                      onPressed: _showAllGrocery,
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFFFA500),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Grocery Items Horizontal List
              SizedBox(
                height: 135,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: groceryKitchenData.length > 5
                      ? 5
                      : groceryKitchenData.length,
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
                            child: UiHelper.CustomImage(
                              img: groceryKitchenData[index]["img"]!,
                            ),
                          ),
                          const SizedBox(height: 8),
                          UiHelper.CustomText(
                            text: groceryKitchenData[index]["text"]!,
                            color: Colors.black87,
                            fontweight: FontWeight.w500,
                            fontsize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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

class AllItemsScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;
  final String type;

  const AllItemsScreen({
    super.key,
    required this.title,
    required this.items,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA500),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
          ),
        ),
      ),
      body: type == "diwali"
          ? _buildDiwaliGrid(context)
          : type == "products"
          ? _buildProductsGrid(context)
          : _buildGroceryGrid(context),
    );
  }

  Widget _buildDiwaliGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: UiHelper.CustomImage(img: items[index]["img"]!),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: UiHelper.CustomText(
                  text: items[index]["text"]!,
                  color: Colors.black87,
                  fontweight: FontWeight.w600,
                  fontsize: 12,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: UiHelper.CustomImage(img: items[index]["img"]!),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UiHelper.CustomText(
                        text: items[index]["text"]!,
                        color: Colors.black87,
                        fontweight: FontWeight.w600,
                        fontsize: 11,
                        maxLines: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 12,
                                color: Color(0xFF9C9C9C),
                              ),
                              const SizedBox(width: 4),
                              UiHelper.CustomText(
                                text: "${items[index]["time"]} MINS",
                                color: const Color(0xFF9C9C9C),
                                fontweight: FontWeight.normal,
                                fontsize: 10,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "₹",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFA500),
                                    ),
                                  ),
                                  UiHelper.CustomText(
                                    text: items[index]["price"]!,
                                    color: const Color(0xFFFFA500),
                                    fontweight: FontWeight.bold,
                                    fontsize: 16,
                                  ),
                                ],
                              ),
                              UiHelper.CustomButton(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${items[index]["text"]} added!',
                                    ),
                                    backgroundColor: const Color(0xFFFFA500),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroceryGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 95,
              width: 95,
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
              padding: const EdgeInsets.all(10),
              child: UiHelper.CustomImage(img: items[index]["img"]!),
            ),
            const SizedBox(height: 8),
            UiHelper.CustomText(
              text: items[index]["text"]!,
              color: Colors.black87,
              fontweight: FontWeight.w500,
              fontsize: 10,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }
}
