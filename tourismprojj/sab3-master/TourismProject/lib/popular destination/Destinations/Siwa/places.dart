import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../place.dart';

List<Place> siwaPlaces = [
  Place(
      "Al-mawta Mountain",
      [
        'images/siwa places/mawta2.jpg',
        'images/siwa places/mawta3.jpg',
        'images/siwa places/mawta4.jpg',
        'images/siwa places/mawwta1.jpg',
      ],
      "Al-Mawta Mountain: A rugged peak in Egypt's Sinai Peninsula, perfect for adventurous hikes and desert views.",
      0,
      "https://www.lonelyplanet.com/egypt/western-desert/siwa-oasis/attractions/gebel-al-mawta/a/poi-sig/495956/355278",
    false,
  ),

  Place(
      "Amun Temple",
      [
        'images/siwa places/am1.jpg',
        'images/siwa places/am2.jpg',
        'images/siwa places/am3.jpg',
        'images/siwa places/am4.jpg',
      ],
      "Amun Temple: An ancient Egyptian temple complex in Karnak, Luxor, dedicated to the god Amun, showcasing impressive columns and religious significance.",
      0,
    "https://www.khanacademy.org/humanities/ap-art-history/ancient-mediterranean-ap/ancient-egypt-ap/a/karnak",
    false,
  ),

  Place(
      'Cleopatra Springs',
      [
        'images/siwa places/cel1.jpg',
        'images/siwa places/cel2.jpg',
        'images/siwa places/cel3.jpg',
        'images/siwa places/cel4.jpg',
      ],
      "Cleopatra Springs: Natural hot springs near the Red Sea in Egypt, renowned for their therapeutic properties and scenic surroundings.",
      0,
     "https://www.tripadvisor.com/Attraction_Review-g303857-d600497-Reviews-Cleopatra_s_Pool_Spring_of_Juba-Siwa_Matrouh_Governorate.html",
    false,
  ),
  Place(
      'Gebel Dakrour',
      [
        'images/siwa places/gebl1.jpg',
        'images/siwa places/gebl2.jpg',
        'images/siwa places/gebl3.jpg',
        'images/siwa places/gebl4.jpg',
      ],
      "Gebel Dakrour: A scenic desert peak in Egypt, perfect for outdoor adventures like hiking and camping.",
      0,
     "https://www.etltravel.com/egypt/gebel-dakrour-siwa-oasis/",
    false,
  ),

  Place(
      'Siwa Lake',
      [
        'images/siwa places/lake1.jpg',
        'images/siwa places/lake2.jpg',
        'images/siwa places/lake3.jpg',
        'images/siwa places/lake4.jpg',
      ],
      "Siwa Lake: An idyllic desert oasis in Egypt, perfect for relaxation and exploration.",
      0,
    "https://www.tripadvisor.com/Attraction_Review-g303857-d600499-Reviews-Lake_Siwa-Siwa_Matrouh_Governorate.html",
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
  List<int> activeIndices = List.filled(siwaPlaces.length, 0);
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getPlacesPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      siwaPlaces[index].isFavorite = !siwaPlaces[index].isFavorite;

      if (siwaPlaces[index].isFavorite) {
        favoritePlaces.add(siwaPlaces[index]);
      } else {
        favoritePlaces.remove(siwaPlaces[index]);
      }
    });
  }

  Future<void> getPlacesPrices() async {
    for (int i = 0; i < siwaPlaces.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Touristic places')
          .doc(siwaPlaces[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        siwaPlaces[i] = Place(
          siwaPlaces[i].name,
          siwaPlaces[i].imagePaths,
          siwaPlaces[i].description,
          price,
          siwaPlaces[i].url,
          siwaPlaces[i].isFavorite,
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
          for (int i = 0; i < siwaPlaces.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: siwaPlaces[i]
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
                buildIndicator(activeIndices[i], siwaPlaces[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        siwaPlaces[i].name,
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
                              content: Text(siwaPlaces[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          siwaPlaces[i].isFavorite
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
                          _launchURL(siwaPlaces[i].url); // Launch URL when tapped
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
                    siwaPlaces[i].description,
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
                      if (!isLoading && siwaPlaces[i].price != 1)
                        Text(
                          siwaPlaces[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && siwaPlaces[i].price != 1)
                        SizedBox(width: 8),
                      if (!isLoading && siwaPlaces[i].price != 1)
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isLoading && siwaPlaces[i].price == 1)
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
