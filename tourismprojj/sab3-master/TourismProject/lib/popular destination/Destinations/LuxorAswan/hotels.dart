import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';

List<Hotel> luxorAswanHotels = [
  Hotel(
      "Hilton Luxor Resort & Spa",
      [
        'images/luxorandaswanhotels/hilt1.jpg',
        'images/luxorandaswanhotels/hilt2.jpg',
        'images/luxorandaswanhotels/hilt3.jpg',
        'images/luxorandaswanhotels/hilt4.jpg',
      ],
      "Hilton Luxor: Unrivaled luxury amidst ancient wonders.",
     0, "https://www.hilton.com/en/hotels/luxhitw-hilton-luxor-resort-and-spa/hotel-info/", false),
  Hotel(
      "Jewel Howard Carter Hotel",
      [
        'images/luxorandaswanhotels/jewel1.jpg',
        'images/luxorandaswanhotels/jewel2.jpg',
        'images/luxorandaswanhotels/jewel3.jpg',
        'images/luxorandaswanhotels/jewel4.jpg',
      ],
      "Jewel Howard: Monrovia's epitome of elegance and luxury.",
      0, "https://www.tripadvisor.com/Hotel_Review-g294205-d12689152-Reviews-Jewel_Howard_Carter_Hotel-Luxor_Nile_River_Valley.html", false),
  Hotel(
      'New Memnon Hotel',
      [
        'images/luxorandaswanhotels/menmon1.jpg',
        'images/luxorandaswanhotels/menmon2.jpg',
        'images/luxorandaswanhotels/menmon3.jpg',
        'images/luxorandaswanhotels/menmon4.jpg',
      ],
      "Menmon Hotel: Your cozy urban retreat in the heart of the city.",
     0, "https://www.tripadvisor.com/Hotel_Review-g294205-d2501752-Reviews-New_Memnon_Hotel-Luxor_Nile_River_Valley.html", false),
  Hotel(
      'Sonesta St. George Hotel',
      [
        'images/luxorandaswanhotels/sonesta1.jpg',
        'images/luxorandaswanhotels/sonesta2.jpg',
        'images/luxorandaswanhotels/sonesta3.jpg',
        'images/luxorandaswanhotels/sonesta4.jpg',
      ],
      "Sonesta Hotel: Modern elegance and warm hospitality await at our cozy urban retreat.",
     0, "https://www.sonesta.com/sonesta-hotels-resorts/egy/luxor/sonesta-st-george-hotel-luxor", false),
  Hotel(
      'Steigenberger Nile Palace',
      [
        'images/luxorandaswanhotels/stein1.jpg',
        'images/luxorandaswanhotels/stein2.jpg',
        'images/luxorandaswanhotels/stein3.jpg',
        'images/luxorandaswanhotels/stein4.jpg',
      ],
      "Steigenburger Nile Hotel: Luxurious Nile-side charm awaits at our tranquil retreat.",
      0, "https://hrewards.com/en/steigenberger-nile-palace-luxor", false),

  Hotel(
      "Obelisk Nile Hotel",
      [
        'images/luxorandaswanhotels/ob1.jpg',
        'images/luxorandaswanhotels/ob2.jpg',
        'images/luxorandaswanhotels/ob3.jpg',
        'images/luxorandaswanhotels/ob4.jpg',
      ],
      "Obelisk Hotel: Where history and luxury converge, promising an unforgettable stay in the heart of the city.",
      0, "https://obeliskhotels.com/", false),
  Hotel(
      "Movenpick aswan",
      [
        'images/luxorandaswanhotels/moven11.jpg',
        'images/luxorandaswanhotels/moven2.jpg',
        'images/luxorandaswanhotels/moven3.jpg',
        'images/luxorandaswanhotels/moven4.jpg',
      ],
      "Mövenpick: Swiss hospitality, exotic charm, and unmatched comfort.",
      0, "https://movenpick.accor.com/ar/africa/egypt/aswan/resort-aswan.html", false),
  Hotel(
      'Sofitel Legend',
      [
        'images/luxorandaswanhotels/sof1.jpg',
        'images/luxorandaswanhotels/sof2.jpg',
        'images/luxorandaswanhotels/sof3.jpg',
        'images/luxorandaswanhotels/sof4.jpg',
      ],
      "Sofitel Hotel: A harmonious blend of sophistication and comfort awaits at our urban oasis.",
      0, "https://all.accor.com/hotel/1666/index.en.shtml", false),
  Hotel(
      'Benben by Dhara hotel',
      [
        'images/luxorandaswanhotels/ben1.jpg',
        'images/luxorandaswanhotels/ben2.jpg',
        'images/luxorandaswanhotels/ben3.jpg',
        'images/luxorandaswanhotels/ben4.jpg',
      ],
      "Benben by Dhara Hotel: Urban elegance and warm hospitality await your arrival.",
      0, "https://dharahotels.com/", false),
  Hotel(
      'Pyramisa aswan hotel',
      [
        'images/luxorandaswanhotels/py1.jpg',
        'images/luxorandaswanhotels/py2.jpg',
        'images/luxorandaswanhotels/py3.jpg',
        'images/luxorandaswanhotels/py4.jpg',
      ],
      "Pyramisa Hotel: Your cozy urban retreat awaits.",
      0, "https://www.pyramisahotels.com/isis-island-aswan-home", false),
  // Add more hotels here
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(luxorAswanHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      luxorAswanHotels[index].isFavorite = !luxorAswanHotels[index].isFavorite;

      if (luxorAswanHotels[index].isFavorite) {
        favoriteHotels.add(luxorAswanHotels[index]);
      } else {
        favoriteHotels.remove(luxorAswanHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < luxorAswanHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(luxorAswanHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        luxorAswanHotels[i] = Hotel(
          luxorAswanHotels[i].name,
          luxorAswanHotels[i].imagePaths,
          luxorAswanHotels[i].description,
          price,
          luxorAswanHotels[i].url,
          luxorAswanHotels[i].isFavorite,
        );
        if (price == 0) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Document does not exist');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Luxor And Aswan',
          style: TextStyle(
            fontFamily: 'MadimiOne',
            color: Color.fromARGB(255, 121, 155, 228),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 121, 155, 228),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThirdRoute()),
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              'Hotels',
              style: TextStyle(
                fontFamily: 'MadimiOne',
                color: Color.fromARGB(255, 121, 155, 230),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < luxorAswanHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: luxorAswanHotels[i]
                      .imagePaths
                      .map((imagePath) => Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 180,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndices[i] = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                buildIndicator(
                    activeIndices[i], luxorAswanHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        luxorAswanHotels[i].name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MadimiOne',
                          color: Color.fromARGB(255, 83, 137, 182),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 5, 59, 107),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          toggleFavoriteStatus(i);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(luxorAswanHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          luxorAswanHotels[i].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Color.fromARGB(255, 13, 16, 74),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to Trip!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Color.fromARGB(255, 13, 16, 74),
                        ),
                      ),
                       SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _launchURL(luxorAswanHotels[i].url); // Launch URL when tapped
                        },
                        child: Icon(
                          Icons.link,
                          color: Colors.blue, // Use blue color for link icon
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    luxorAswanHotels[i].description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 36, 108, 163),
                      fontFamily: 'MadimiOne',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (isLoading)
                        CircularProgressIndicator(), // Show loading icon
                      if (!isLoading && luxorAswanHotels[i].price != 0)
                        Text(
                          luxorAswanHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && luxorAswanHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && luxorAswanHotels[i].price != 0)
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildIndicator(int activeIndex, int length) {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: length,
        effect: WormEffect(
          dotWidth: 18,
          dotHeight: 18,
          activeDotColor: Colors.blue,
          dotColor: Color.fromARGB(255, 16, 65, 106),
        ),
      ),
    );
  }
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}

