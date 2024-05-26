import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Cairo/hotels.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';


List<Hotel> alexHotels = [
  Hotel(
      "Amoun Hotel",
      [
        'images/alexhotels/amoun1.jpg',
        'images/alexhotels/amoun2.jpg',
        'images/alexhotels/amoun3.jpg',
        'images/alexhotels/amoun4.jpg',
      ],
      "Hotels offer a temporary haven, providing comfort, convenience, and often a touch of luxury for travelers seeking respite from their journeys.",
      0, "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/", false),
  Hotel(
      "Green Plaza Inn",
      [
        'images/alexhotels/green1.jpg',
        'images/alexhotels/green2.jpg',
        'images/alexhotels/green3.jpg',
        'images/alexhotels/green4.jpg',
      ],
      "From opulent suites to cozy rooms, hotels offer a spectrum of accommodations to suit every taste and budget.",
      0, "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/", false),
  Hotel(
      'Hilton Alexandria Corniche',
      [
        'images/alexhotels/hilton1.jpg',
        'images/alexhotels/hilton2.jpg',
        'images/alexhotels/hilton3.jpg',
        'images/alexhotels/hilton4.jpg',
      ],
      "Hotels welcome weary travelers with open arms, offering a sanctuary where comfort meets convenience.",
      0, "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/", false),
  Hotel(
      'Royal Crown Hotel',
      [
        'images/alexhotels/royal1.jpg',
        'images/alexhotels/royal2.jpg',
        'images/alexhotels/royal3.jpg',
        'images/alexhotels/royal4.jpg',
      ],
      "Indulge in a world of comfort and luxury at our exquisite hotel, where every moment is crafted to exceed your expectations and leave you with cherished memories to last a lifetime",
     0, "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/", false),
  Hotel(
      'Semiramis Hotel',
      [
        'images/alexhotels/sim1.jpg',
        'images/alexhotels/sim2.jpg',
        'images/alexhotels/sim3.jpg',
        'images/alexhotels/sim4.jpg',
      ],
      "Experience the epitome of luxury and sophistication at Semirames Hotel, where timeless elegance meets modern comfort, creating an unforgettable oasis for discerning travelers.",
    0, "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/", false),
  // Add more hotels here
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(alexHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      alexHotels[index].isFavorite = !alexHotels[index].isFavorite;

      if (alexHotels[index].isFavorite) {
        favoriteHotels.add(alexHotels[index]);
      } else {
        favoriteHotels.remove(alexHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < alexHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(alexHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        alexHotels[i] = Hotel(
          alexHotels[i].name,
          alexHotels[i].imagePaths,
          alexHotels[i].description,
          price,
          cairoHotels[i].url,
          alexHotels[i].isFavorite,
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
          'Alexandria',
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
              MaterialPageRoute(builder: (context) => SecRoute()),
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
          for (int i = 0; i < alexHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: alexHotels[i]
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
                buildIndicator(activeIndices[i], alexHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        alexHotels[i].name,
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
                              content: Text(alexHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          alexHotels[i].isFavorite
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
                   _launchURL(cairoHotels[i].url); // Launch URL when tapped
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
                    alexHotels[i].description,
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
                      if (!isLoading && alexHotels[i].price != 0)
                        Text(
                          alexHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && alexHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && alexHotels[i].price != 0)
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
