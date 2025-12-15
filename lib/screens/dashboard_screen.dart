import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    var data = [
      {"img": "image 50.png", "text": "Lights, Diyas \n & Candles"},
      {"img": "image 51.png", "text": "Diwali \n Gifts"},
      {"img": "image 52.png", "text": "Appliances  \n & Gadgets"},
      {"img": "image 53.png", "text": "Home \n & Living"},
    ];

    var category = [
      {
        "img": "image 54.png",
        "text": "Golden Glass\n Wooden Lid Candle (Oudh)",
      },
      {"img": "image 57.png", "text": "Royal Gulab Jamun\n By Bikano"},
      {
        "img": "image 63.png",
        "text": "Golden Glass\n Wooden Lid Candle (Oudh)",
      },
    ];

    var groceryKitchen = [
      {"img": "image 41.png", "text": "Vegetables & \nFruits"},
      {"img": "image 42.png", "text": "Atta, Dal & \nRice"},
      {"img": "image 43.png", "text": "Oil, Ghee & \nMasala"},
      {"img": "image 44 (1).png", "text": "Dairy, Bread & \nMilk"},
      {"img": "image 45 (1).png", "text": "Biscuits & \nBakery"},
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Stack(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                color: const Color(0XFFEC0505),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        _customText(
                          text: "QuickCart in",
                          color: const Color(0XFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        _customText(
                          text: "16 minutes",
                          color: const Color(0XFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        _customText(
                          text: "HOME ",
                          color: const Color(0XFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        _customText(
                          text: "- Your Location Address",
                          color: const Color(0XFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                child: _customTextField(controller: searchController),
              ),
            ],
          ),
          Container(height: 1, width: double.infinity, color: Colors.white),
          Container(
            height: 196,
            width: double.infinity,
            color: const Color(0XFFEC0505),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _customImage(img: "image 60.png"),
                    _customImage(img: "image 55.png"),
                    _customText(
                      text: "Mega Diwali Sale",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    _customImage(img: "image 55.png"),
                    _customImage(img: "image 61.png"),
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
                              color: const Color(0XFFEAD3D3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                _customText(
                                  text: data[index]["text"].toString(),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                                _customImage(
                                  img: data[index]["img"].toString(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 108,
                          width: 93,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _customImage(
                            img: category[index]["img"].toString(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: _customText(
                          text: category[index]["text"].toString(),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Row(
                          children: [
                            _customImage(img: "timer 4.png"),
                            _customText(
                              text: "16 MINS",
                              color: const Color(0XFF9C9C9C),
                              fontWeight: FontWeight.normal,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Row(
                          children: [
                            _customImage(img: "image 50 (1).png"),
                            _customText(
                              text: "79",
                              color: const Color(0XFF9C9C9C),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: category.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              _customText(
                text: "Grocery & Kitchen",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 78,
                          width: 71,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0XFFD9EBEB),
                          ),
                          child: _customImage(
                            img: groceryKitchen[index]["img"].toString(),
                          ),
                        ),
                      ),
                      _customText(
                        text: groceryKitchen[index]["text"].toString(),
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ],
                  );
                },
                itemCount: groceryKitchen.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for custom text
  Widget _customText({
    required String text,
    required Color color,
    required FontWeight fontWeight,
    required double fontSize,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

  // Helper widget for custom image
  Widget _customImage({required String img}) {
    return Image.asset(
      'assets/images/$img',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }

  // Helper widget for custom text field
  Widget _customTextField({required TextEditingController controller}) {
    return Container(
      width: 350,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
