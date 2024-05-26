import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../place.dart';


List<Place> hurghadaPlaces = [
  Place(
      "Dolphin world reservations",
      [
        'images/hurghadaplaces/dol1.jpg',
        'images/hurghadaplaces/dol2.jpg',
        'images/hurghadaplaces/dol3.jpg',
        'images/hurghadaplaces/dol4.jpg',
      ],
      "Dolphin World Reservations in Hurghada: where the Red Sea's magic meets the playful dance of dolphins.",
      0,
      "https://www.dolphinworldegypt.com/",
    false,
  ),
  Place(
      "Hurghada Grand Aquarium",
      [
        'images/hurghadaplaces/grand1.jpg',
        'images/hurghadaplaces/grand2.jpg',
        'images/hurghadaplaces/grand3.jpg',
        'images/hurghadaplaces/grand4.jpg',
      ],
      "The Hurghada Grand Aquarium: an underwater wonderland showcasing marine life off the coast of Egypt.",
      0,
      "https://hurghadaaquarium.com/",
    false,
  ),
  Place(
      'Mahmya Island',
      [
        'images/hurghadaplaces/mah1.jpg',
        'images/hurghadaplaces/mah2.jpg',
        'images/hurghadaplaces/mah3.jpg',
        'images/hurghadaplaces/mah4.jpg',
      ],
      "Mahmya Island: A tranquil paradise with sandy beaches and clear waters for relaxation and snorkeling.",
      0,
      "https://www.mahmya.com/",
    false,
  ),
  Place(
      'Makadi water world',
      [
        'images/hurghadaplaces/mak1.jpg',
        'images/hurghadaplaces/mak2.jpg',
        'images/hurghadaplaces/mak3.jpg',
        'images/hurghadaplaces/mak4.jpg',
      ],
      "Makadi Water World: A thrilling water park in Egypt, offering slides, pools, and fun for all ages.",
      0,
      "https://makadiwaterworld.com/",
    false,
  ),
  Place(
      'paradise island hurghada',
      [
        'images/hurghadaplaces/par1.jpg',
        'images/hurghadaplaces/par2.jpg',
        'images/hurghadaplaces/par3.jpg',
        'images/hurghadaplaces/par4.jpg',
      ],
      "Paradise Island Hurghada: A scenic island escape in Egypt, boasting beautiful beaches and crystal-clear waters.",
      0,
      "https://www.tripadvisor.com/Attraction_Review-g297549-d13576819-Reviews-Paradise_Island-Hurghada_Red_Sea_and_Sinai.html",
    false,
  ),
  // Add more hotels here
];

class ScreenThree extends StatefulWidget {
  ScreenThree({Key? key});

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  List<Place> favoritePlaces = [];
  List<int> activeIndices = List.filled(hurghadaPlaces.length, 0);
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getPlacesPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      hurghadaPlaces[index].isFavorite = !hurghadaPlaces[index].isFavorite;

      if (hurghadaPlaces[index].isFavorite) {
        favoritePlaces.add(hurghadaPlaces[index]);
      } else {
        favoritePlaces.remove(hurghadaPlaces[index]);
      }
    });
  }

  Future<void> getPlacesPrices() async {
    for (int i = 0; i < hurghadaPlaces.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Touristic places')
          .doc(hurghadaPlaces[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        hurghadaPlaces[i] = Place(
          hurghadaPlaces[i].name,
          hurghadaPlaces[i].imagePaths,
          hurghadaPlaces[i].description,
          price,
          hurghadaPlaces[i].url,
          hurghadaPlaces[i].isFavorite,
        );
        if (price == 1) {
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
              'Touristic',
              style: TextStyle(
                fontFamily: 'MadimiOne',
                color: Color.fromARGB(255, 121, 155, 230),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < hurghadaPlaces.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: hurghadaPlaces[i]
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
                buildIndicator(activeIndices[i], hurghadaPlaces[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        hurghadaPlaces[i].name,
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
                              content: Text(hurghadaPlaces[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          hurghadaPlaces[i].isFavorite
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
                          _launchURL(hurghadaPlaces[i].url); // Launch URL when tapped
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
                    hurghadaPlaces[i].description,
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
                      if (!isLoading && hurghadaPlaces[i].price != 1)
                        Text(
                          hurghadaPlaces[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && hurghadaPlaces[i].price != 1)
                        SizedBox(width: 8),
                      if (!isLoading && hurghadaPlaces[i].price != 1)
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isLoading && hurghadaPlaces[i].price == 1)
                        IconButton(
                          icon: Icon(Icons.cloud_download),
                          onPressed:
                              () {}, // Add the function to handle downloading here
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
