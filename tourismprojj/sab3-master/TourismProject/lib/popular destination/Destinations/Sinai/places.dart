import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../place.dart';

List<Place> sinaiPlaces = [
  Place(
      "Sahaba Mosque",
      [
        'images/sinaplaces/mos1.jpg',
        'images/sinaplaces/mos2.jpg',
        'images/sinaplaces/mos3.jpg',
        'images/sinaplaces/mos4.jpg',
      ],
      "The Sahaba Mosque: A historic mosque in Sharm El Sheikh, Egypt, honoring the companions of the Prophet Muhammad.",
      0,
      "https://www.tripadvisor.com/Attraction_Review-g297555-d16850020-Reviews-Al_Sahaba_Mosque-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html",
    false,
  ),

  Place(
      "Mount Catherine",
      [
        'images/sinaplaces/mount1.jpg',
        'images/sinaplaces/mount2.jpg',
        'images/sinaplaces/mount3.jpg',
        'images/sinaplaces/mount4.jpg',
      ],
      "Mount Catherine: Egypt's tallest peak, offering stunning views and challenging hikes in the Sinai Peninsula.",
      0,
     "https://www.britannica.com/place/Mount-Katrina",
    false,
  ),

  Place(
      'Soho Square Dancing',
      [
        'images/sinaplaces/soho1.jpg',
        'images/sinaplaces/soho2.jpg',
        'images/sinaplaces/soho3.jpg',
        'images/sinaplaces/soho4.jpg',
      ],
      "Soho Square Dancing Fountain: Sharm El Sheikh's captivating water show with music and lights.",
      0,
     "https://www.tripadvisor.com/Attraction_Review-g297555-d4010193-Reviews-Soho_Square_Dancing_Fountain-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html",
    false,
  ),
  Place(
      'The Heavenly Cathedral',
      [
        'images/sinaplaces/hea1.jpg',
        'images/sinaplaces/hea2.jpg',
        'images/sinaplaces/hea3.jpg',
        'images/sinaplaces/hea4.jpg',
      ],
      "The Heavenly Cathedral: A serene sanctuary in Sharm El Sheikh, Egypt, inviting contemplation and prayer.",
      0,
      "https://www.tripadvisor.com/Attraction_Review-g297555-d2706237-Reviews-The_Heavenly_Cathedral-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html",
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
  List<int> activeIndices = List.filled(sinaiPlaces.length, 0);
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getPlacesPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      sinaiPlaces[index].isFavorite = !sinaiPlaces[index].isFavorite;

      if (sinaiPlaces[index].isFavorite) {
        favoritePlaces.add(sinaiPlaces[index]);
      } else {
        favoritePlaces.remove(sinaiPlaces[index]);
      }
    });
  }

  Future<void> getPlacesPrices() async {
    for (int i = 0; i < sinaiPlaces.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Touristic places')
          .doc(sinaiPlaces[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        sinaiPlaces[i] = Place(
          sinaiPlaces[i].name,
          sinaiPlaces[i].imagePaths,
          sinaiPlaces[i].description,
          price,
          sinaiPlaces[i].url,
          sinaiPlaces[i].isFavorite,
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
          for (int i = 0; i < sinaiPlaces.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: sinaiPlaces[i]
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
                buildIndicator(activeIndices[i], sinaiPlaces[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        sinaiPlaces[i].name,
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
                              content: Text(sinaiPlaces[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          sinaiPlaces[i].isFavorite
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
                          _launchURL(sinaiPlaces[i].url); // Launch URL when tapped
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
                    sinaiPlaces[i].description,
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
                      if (!isLoading && sinaiPlaces[i].price != 1)
                        Text(
                          sinaiPlaces[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && sinaiPlaces[i].price != 1)
                        SizedBox(width: 8),
                      if (!isLoading && sinaiPlaces[i].price != 1)
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isLoading && sinaiPlaces[i].price == 1)
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
