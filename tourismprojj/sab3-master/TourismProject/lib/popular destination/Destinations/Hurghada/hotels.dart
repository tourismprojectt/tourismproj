import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';

List<Hotel> hurghadaHotels = [
  Hotel(
    "Baron Palace Sahl Hasheesh",
    [
      'images/hurghadahotels/hur1.jpg',
      'images/hurghadahotels/hur2.jpg',
      'images/hurghadahotels/hur3.jpg',
      'images/hurghadahotels/hur4.jpg',
    ],
    "Nestled amidst the sun-kissed shores of Hurghada, the Baron Palace Hotel exudes an enchanting charm, where every moment is a symphony of luxury, pampering guests with opulent indulgence against the backdrop of the Red Sea's azure embrace.",
    0,
    "https://baronhotels.com/baron-palace-sahl-hasheesh/",
    false,
  ),
  Hotel(
      "Giftun Beach Resort",
      [
        'images/hurghadahotels/gif1.jpg',
        'images/hurghadahotels/gif2.jpg',
        'images/hurghadahotels/gif3.jpg',
        'images/hurghadahotels/gif4.jpg',
      ],
      "Giftun Beach: Where sun, sand, and sea unite in a tranquil paradise, offering a perfect escape for those seeking serenity by the Red Sea.",
      0, 
      "https://www.giftunazurresort.com/ar/", 
      false,
      ),
  Hotel(
      'Panorama Bungalows',
      [
        'images/hurghadahotels/pano1.jpg',
        'images/hurghadahotels/pano2.jpg',
        'images/hurghadahotels/pano3.jpg',
        'images/hurghadahotels/pano4.jpg',
      ],
      "Panorama Hotel: Where every stay offers unforgettable views and comfort in every corner.",
      0, "http://www.panorama-resorts.com/en/41/panorama-bungalows-el-gouna", false),
  Hotel(
      'Rixos Premium Magawish',
      [
        'images/hurghadahotels/rixos1.jpg',
        'images/hurghadahotels/rixos2.jpg',
        'images/hurghadahotels/rixos3.jpg',
        'images/hurghadahotels/rixos4.jpg',
      ],
      "Rixos: Luxury and lifestyle harmonize, delivering an exceptional experience in opulence and service.",
      0, "https://www.rixos.com/en/hotel-resort/rixos-premium-magawish-suites-villas", false),
  Hotel(
      'Serry Beach Resort',
      [
        'images/hurghadahotels/serry1.jpg',
        'images/hurghadahotels/serry2.jpg',
        'images/hurghadahotels/serry3.jpg',
        'images/hurghadahotels/serry4.jpg',
      ],
      "Serry Beach Hotel: Where serenity meets the sea for an unforgettable escape.",
      0, "https://www.theserry.com/en", false),
  // Add more hotels here
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(hurghadaHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      hurghadaHotels[index].isFavorite = !hurghadaHotels[index].isFavorite;

      if (hurghadaHotels[index].isFavorite) {
        favoriteHotels.add(hurghadaHotels[index]);
      } else {
        favoriteHotels.remove(hurghadaHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < hurghadaHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(hurghadaHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        hurghadaHotels[i] = Hotel(
          hurghadaHotels[i].name,
          hurghadaHotels[i].imagePaths,
          hurghadaHotels[i].description,
          price,
          hurghadaHotels[i].url,
          hurghadaHotels[i].isFavorite,
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
          'Hurghada',
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
              MaterialPageRoute(builder: (context) => FifthRoute()),
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
          for (int i = 0; i < hurghadaHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: hurghadaHotels[i]
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
                    activeIndices[i], hurghadaHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        hurghadaHotels[i].name,
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
                              content: Text(hurghadaHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          hurghadaHotels[i].isFavorite
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
                          _launchURL(hurghadaHotels[i].url); // Launch URL when tapped
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
                    hurghadaHotels[i].description,
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
                      if (!isLoading && hurghadaHotels[i].price != 0)
                        Text(
                          hurghadaHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && hurghadaHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && hurghadaHotels[i].price != 0)
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
