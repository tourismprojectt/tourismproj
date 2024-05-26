import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';

List<Hotel> sinaiHotels = [
  Hotel(
      "Amar Sina Boutique Village",
      [
        'images/sinahotels/ama1.jpg',
        'images/sinahotels/ama2.jpg',
        'images/sinahotels/ama3.jpg',
        'images/sinahotels/ama4.jpg',
      ],
      "Amar Sina Boutique Village: A charming oasis in the heart of the Red Sea.",
     0, "https://amarsinavillage.com-sharmelsheikh.com/ar/", false),
  Hotel(
      "Sunrise Arabian Beach",
      [
        'images/sinahotels/sun1.jpg',
        'images/sinahotels/sun2.jpg',
        'images/sinahotels/sun3.jpg',
        'images/sinahotels/sun4.jpg',
      ],
      "Sunrise Arabian Beach Resort: Luxury meets the shore for an unforgettable coastal escape.",
      0, "https://www.sunrise-resorts.com/arabian-beach-resort", false),
  Hotel(
      'sinai grand resort',
      [
        'images/sinahotels/sina1.jpg',
        'images/sinahotels/sina2.jpg',
        'mages/sinahotels/sina3.jpg',
        'images/sinahotels/sina4.jpg',
      ],
      "Sinai Grand Resort: Luxurious tranquility awaits at our serene escape.",
      0, "https://www.tripadvisor.com/Hotel_Review-g297555-d583853-Reviews-or15-Sinai_Grand_Resort-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html", false),
  Hotel(
      'sinaway Lagoon Hotel & Spa',
      [
        'images/sinahotels/sinaa1.jpg',
        'images/sinahotels/sinaa2.jpg',
        'images/sinahotels/sinaa3.jpg',
        'images/sinahotels/sinaa4.jpg',
      ],
      "Sinaway Lagoon: Your serene Red Sea getaway awaits.",
     0, "https://sinaway-lagoon-hotel-and-spa-ras-sedr.albooked.com/", false),
  Hotel(
      'Charmillion Club Resort',
      [
        'images/sinahotels/cha1.jpg',
        'images/sinahotels/cha2.jpg',
        'images/sinahotels/cha3.jpg',
        'images/sinahotels/cha4.jpg',
      ],
      "Charmillion Club Resort: Your Red Sea retreat awaits.",
      0, "https://charmillionresorts.com/ar/%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9/%D9%85%D9%86%D8%AA%D8%AC%D8%B9-%D8%B4%D8%A7%D8%B1%D9%85%D9%8A%D9%84%D9%8A%D9%88%D9%86-%D9%83%D9%84%D9%88%D8%A8/", false),
  // Add more hotels here
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(sinaiHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      sinaiHotels[index].isFavorite = !sinaiHotels[index].isFavorite;

      if (sinaiHotels[index].isFavorite) {
        favoriteHotels.add(sinaiHotels[index]);
      } else {
        favoriteHotels.remove(sinaiHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < sinaiHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(sinaiHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        sinaiHotels[i] = Hotel(
          sinaiHotels[i].name,
          sinaiHotels[i].imagePaths,
          sinaiHotels[i].description,
          price,
          sinaiHotels[i].url,
          sinaiHotels[i].isFavorite,
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
          'Sinai',
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
              MaterialPageRoute(builder: (context) => SixthRoute()),
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
          for (int i = 0; i < sinaiHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: sinaiHotels[i]
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
                buildIndicator(activeIndices[i], sinaiHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        sinaiHotels[i].name,
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
                              content: Text(sinaiHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          sinaiHotels[i].isFavorite
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
                          _launchURL(sinaiHotels[i].url); // Launch URL when tapped
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
                    sinaiHotels[i].description,
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
                      if (!isLoading && sinaiHotels[i].price != 0)
                        Text(
                          sinaiHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && sinaiHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && sinaiHotels[i].price != 0)
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
