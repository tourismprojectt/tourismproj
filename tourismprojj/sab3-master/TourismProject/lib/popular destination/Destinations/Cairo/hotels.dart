import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hotel.dart';

List<Hotel> cairoHotels = [
  Hotel(
    "Ramses Hilton",
    [
      'images/ramsesimages/ramses hilton.jpg',
      'images/ramsesimages/rest.jpg',
      'images/ramsesimages/room.jpg',
      'images/ramsesimages/swimming-pool-day.avif',
    ],
    "Luxurious accommodation with stunning views and relaxing amenities.",
    0,
    "https://www.hilton.com/en/hotels/cairhtw-ramses-hilton/",
    false,
  ),
  Hotel(
    "Tolip Golden plaza",
    [
      'images/tolipimages/tolip.jpg',
      'images/tolipimages/toliprest.jpg',
      'images/tolipimages/toliproom.jpg',
      'images/tolipimages/swimmpool.jpg',
    ],
    "Experience comfort and convenience in the heart of the city.",
    0,
    "http://tolipgoldenplaza.com/",
    false,
  ),
  Hotel(
    'Fairmont Nile City',
    [
      'images/fairmonthotel/fairmont.jpg',
      'images/fairmonthotel/fairmontrestt.jpg',
      'images/fairmonthotel/fairmontroom.jpg',
      'images/fairmonthotel/fairmontpool.jpg',
    ],
    "Where luxury meets elegance, offering top-notch services.",
    0,
    "https://www.fairmont.com/nile-city-cairo/",
    false,
  ),
  Hotel(
    'Kempinski Nile Hotel',
    [
      'images/kempinskihotel/kempinski.jpg',
      'images/kempinskihotel/kemppool.jpg',
      'images/kempinskihotel/kemprest.jpg',
      'images/kempinskihotel/kemproom.jpg',
    ],
    "Unparalleled luxury and impeccable service for a memorable stay.",
    0,
    "https://www.kempinski.com/en/cairo/kempinski-nile-hotel",
    false,
  ),
  Hotel(
    'Steigenberger Nile Palace',
    [
      'images/steighenberghotel/steigenberger.jpg',
      'images/steighenberghotel/steighenloopy.jpg',
      'images/steighenberghotel/steighenroom.jpg',
      'images/steighenberghotel/steinpool.jpg',
    ],
    "Discover sophistication and charm in every detail of your stay.",
    0,
    "https://steigenberger.com/en/hotels/all-hotels/egypt/cairo/steigenberger-pyramids-cairo",
    false,
  ),
];

class ScreenOne extends StatefulWidget {
  ScreenOne({Key? key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<Hotel> favoriteHotels = [];
  List<int> activeIndices = List.filled(cairoHotels.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHotelPrices();
  }

  void toggleFavoriteStatus(int index) async {
    setState(() {
      cairoHotels[index].isFavorite = !cairoHotels[index].isFavorite;

      if (cairoHotels[index].isFavorite) {
        favoriteHotels.add(cairoHotels[index]);
      } else {
        favoriteHotels.remove(cairoHotels[index]);
      }
    });
  }

  Future<void> getHotelPrices() async {
    for (int i = 0; i < cairoHotels.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(cairoHotels[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        cairoHotels[i] = Hotel(
          cairoHotels[i].name,
          cairoHotels[i].imagePaths,
          cairoHotels[i].description,
          price,
          cairoHotels[i].url,
          cairoHotels[i].isFavorite,
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
          'Cairo',
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
              MaterialPageRoute(builder: (context) => FirstRoute()),
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
          for (int i = 0; i < cairoHotels.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: cairoHotels[i]
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
                buildIndicator(activeIndices[i], cairoHotels[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        cairoHotels[i].name,
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
                              content: Text(cairoHotels[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          cairoHotels[i].isFavorite
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
                    cairoHotels[i].description,
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
                      if (!isLoading && cairoHotels[i].price != 0)
                        Text(
                          cairoHotels[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && cairoHotels[i].price != 0)
                        SizedBox(width: 8),
                      if (!isLoading && cairoHotels[i].price != 0)
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
