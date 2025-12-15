import 'package:flutter/material.dart';
// Assuming your UiHelper is in this path, adjust as needed
// import 'package:your_app/widgets/uihelper.dart';

class UiHelper {
  static CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static CustomText({
    required String text,
    required Color color,
    required FontWeight fontweight,
    String? fontfamily,
    required double fontsize,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontFamily: fontfamily ?? "regular",
        fontWeight: fontweight,
        color: color,
      ),
    );
  }

  static CustomTextField({required TextEditingController controller}) {
    return Container(
      height: 40,
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Color(0XFFC5C5C5)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search 'ice-cream'",
          prefixIcon: Image.asset("assets/images/search.png"),
          suffixIcon: Image.asset("assets/images/mic 1.png"),
          border: InputBorder.none,
        ),
      ),
    );
  }

  static CustomButton(VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 18,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0XFF27AF34)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            "Add",
            style: TextStyle(fontSize: 8, color: Color(0XFF27AF34)),
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

  // Data for Diwali Sale section
  var diwaliSaleData = [
    {"img": "image 50.png", "text": "Lights, Diyas \n & Candles"},
    {"img": "image 51.png", "text": "Diwali \n Gifts"},
    {"img": "image 52.png", "text": "Appliances  \n & Gadgets"},
    {"img": "image 53.png", "text": "Home \n & Living"},
  ];

  // Data for Category section
  var categoryData = [
    {
      "img": "image 54.png",
      "text": "Golden Glass\n Wooden Lid Candle (Oudh)",
      "time": "16",
      "price": "79",
    },
    {
      "img": "image 57.png",
      "text": "Royal Gulab Jamun\n By Bikano",
      "time": "16",
      "price": "149",
    },
    {
      "img": "image 63.png",
      "text": "Golden Glass\n Wooden Lid Candle (Oudh)",
      "time": "16",
      "price": "79",
    },
  ];

  // Data for Grocery & Kitchen section
  var groceryKitchenData = [
    {"img": "image 41.png", "text": "Vegetables & \nFruits"},
    {"img": "image 42.png", "text": "Atta, Dal & \nRice"},
    {"img": "image 43.png", "text": "Oil, Ghee & \nMasala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread & \nMilk"},
    {"img": "image 45 (1).png", "text": "Biscuits & \nBakery"},
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on index
    switch (index) {
      case 0:

        break;
      case 1:
        // Category
        // Navigator.pushNamed(context, '/category');
        break;
      case 2:
        // Print/Cart
        // Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        // Profile
        // Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),

          // Header Section with Red Background
          Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                color: Color(0XFFEC0505),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        UiHelper.CustomText(
                          text: "QuickCart in",
                          color: Color(0XFFFFFFFF),
                          fontweight: FontWeight.bold,
                          fontsize: 15,
                          fontfamily: "bold",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        UiHelper.CustomText(
                          text: "16 minutes",
                          color: Color(0XFFFFFFFF),
                          fontweight: FontWeight.bold,
                          fontsize: 20,
                          fontfamily: "bold",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        UiHelper.CustomText(
                          text: "HOME ",
                          color: Color(0XFFFFFFFF),
                          fontweight: FontWeight.bold,
                          fontsize: 14,
                        ),
                        UiHelper.CustomText(
                          text: "- Your Location Address",
                          color: Color(0XFFFFFFFF),
                          fontweight: FontWeight.bold,
                          fontsize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 100,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: UiHelper.CustomTextField(controller: searchController),
              ),
            ],
          ),

          // Divider
          Container(height: 1, width: double.infinity, color: Colors.white),

          // Mega Diwali Sale Section
          Container(
            height: 196,
            width: double.infinity,
            color: Color(0XFFEC0505),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UiHelper.CustomImage(img: "image 60.png"),
                    UiHelper.CustomImage(img: "image 55.png"),
                    UiHelper.CustomText(
                      text: "Mega Diwali Sale",
                      color: Colors.white,
                      fontweight: FontWeight.bold,
                      fontsize: 20,
                      fontfamily: "bold",
                    ),
                    UiHelper.CustomImage(img: "image 55.png"),
                    UiHelper.CustomImage(img: "image 61.png"),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 1,
                            bottom: 1,
                          ),
                          child: Container(
                            height: 108,
                            width: 86,
                            decoration: BoxDecoration(
                              color: Color(0XFFEAD3D3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UiHelper.CustomText(
                                  text: diwaliSaleData[index]["text"]
                                      .toString(),
                                  color: Colors.black,
                                  fontweight: FontWeight.bold,
                                  fontsize: 10,
                                ),
                                SizedBox(height: 5),
                                UiHelper.CustomImage(
                                  img: diwaliSaleData[index]["img"].toString(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: diwaliSaleData.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Products Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 108,
                          width: 93,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: UiHelper.CustomImage(
                            img: categoryData[index]["img"].toString(),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          width: 93,
                          child: UiHelper.CustomText(
                            text: categoryData[index]["text"].toString(),
                            color: Colors.black,
                            fontweight: FontWeight.bold,
                            fontsize: 8,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            UiHelper.CustomImage(img: "timer 4.png"),
                            SizedBox(width: 3),
                            UiHelper.CustomText(
                              text: "${categoryData[index]["time"]} MINS",
                              color: Color(0XFF9C9C9C),
                              fontweight: FontWeight.normal,
                              fontsize: 10,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            UiHelper.CustomImage(img: "image 50 (1).png"),
                            SizedBox(width: 3),
                            UiHelper.CustomText(
                              text: categoryData[index]["price"].toString(),
                              color: Color(0XFF9C9C9C),
                              fontweight: FontWeight.bold,
                              fontsize: 15,
                            ),
                            SizedBox(width: 10),
                            UiHelper.CustomButton(() {
                              // Add to cart functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${categoryData[index]["text"]} added to cart!',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount: categoryData.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),

          // Grocery & Kitchen Section Title
          Row(
            children: [
              SizedBox(width: 20),
              UiHelper.CustomText(
                text: "Grocery & Kitchen",
                color: Colors.black,
                fontweight: FontWeight.bold,
                fontsize: 14,
                fontfamily: "bold",
              ),
            ],
          ),
          SizedBox(height: 10),

          // Grocery & Kitchen Items
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 78,
                          width: 71,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0XFFD9EBEB),
                          ),
                          child: UiHelper.CustomImage(
                            img: groceryKitchenData[index]["img"].toString(),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          width: 71,
                          child: UiHelper.CustomText(
                            text: groceryKitchenData[index]["text"].toString(),
                            color: Colors.black,
                            fontweight: FontWeight.normal,
                            fontsize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: groceryKitchenData.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0XFFEC0505),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Print'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
