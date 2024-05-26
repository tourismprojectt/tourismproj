import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';

List<Hotel> siwaHotels = [
  Hotel(
      "Albabenshal-guest House",
      [
        'images/siwahotels/alb1.jpg',
        'images/siwahotels/alb2.jpg',
        'images/siwahotels/alb3.jpg',
        'images/siwahotels/alb4.jpg',
      ],
      "Albabenshal Guest House: Your cozy retreat in siwa",
    0, "https://www.tripadvisor.com/Hotel_Review-g303857-d1013378-Reviews-Albabenshal-Siwa_Matrouh_Governorate.html", false),
  Hotel(
      "Forest camp Siwa",
      [
        'images/siwahotels/for1.jpg',
        'images/siwahotels/for2.jpg',
        'images/siwahotels/for3.jpg',
        'images/siwahotels/for4.jpg',
      ],
      "Forest Camp Siwa: Your serene oasis amidst nature's embrace.",
      0, "https://www.tripadvisor.com/Hotel_Review-g303857-d27162328-Reviews-Forest_Camp_Siwa-Siwa_Matrouh_Governorate.html", false),
  Hotel(
      'Shali Ladge',
      [
        'images/siwahotels/shali1.jpg',
        'images/siwahotels/shali2.jpg',
        'images/siwahotels/shali3.jpg',
        'images/siwahotels/shali4.jpg',
      ],
      "Shali Lodge: Your serene oasis in Siwa",
    0, "https://www.siwashaliresort.com/index.html", false),
  Hotel(
      'Siwa Paradise',
      [
        'images/siwahotels/para1.jpg',
        'images/siwahotels/para2.jpg',
        'images/siwahotels/para3.jpg',
        'images/siwahotels/para4.jpg',
      ],
      "Siwa Paradise: Where desert serenity meets comfort, promising an unforgettable oasis retreat.",
      0, "https://siwa-paradise-siwa-oasis.albooked.com/", false),
  Hotel(
      'Siwa Camp Osman Oasis',
      [
        'images/siwahotels/camp1.jpg',
        'images/siwahotels/camp2.jpg',
        'images/siwahotels/camp3.jpg',
        'images/siwahotels/camp4.jpg',
      ],
      "Siwa Camp Osman Oasis: Your tranquil retreat amidst the beauty of Siwa's natural splendor.",
     0, "https://www.booking.com/hotel/eg/siwa-camp-osman-oasis.html", false),
  // Add more hotels here
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(siwaHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      siwaHotels[index].isFavorite = !siwaHotels[index].isFavorite;

      if (siwaHotels[index].isFavorite) {
        favoriteHotels.add(siwaHotels[index]);
      } else {
        favoriteHotels.remove(siwaHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < siwaHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(siwaHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        siwaHotels[i] = Hotel(
          siwaHotels[i].name,
          siwaHotels[i].imagePaths,
          siwaHotels[i].description,
          price,
          siwaHotels[i].url,
          siwaHotels[i].isFavorite,
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
          'Siwa',
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
              MaterialPageRoute(builder: (context) => FourthRoute()),
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
          for (int i = 0; i < siwaHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: siwaHotels[i]
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
                    activeIndices[i], siwaHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        siwaHotels[i].name,
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
                              content: Text(siwaHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          siwaHotels[i].isFavorite
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
                          _launchURL(siwaHotels[i].url); // Launch URL when tapped
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
                    siwaHotels[i].description,
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
                      if (!isLoading && siwaHotels[i].price != 0)
                        Text(
                          siwaHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && siwaHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && siwaHotels[i].price != 0)
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
}
void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
  

