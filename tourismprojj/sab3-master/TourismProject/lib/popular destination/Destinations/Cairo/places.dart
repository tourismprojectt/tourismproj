import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import '../place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Place> cairoPlaces = [
  Place(
      "Cairo tower",
      [
        'images/cairoplaces/tower1.jpg',
        'images/cairoplaces/tower2.jpg',
        'images/cairoplaces/tower3.jpg',
        'images/cairoplaces/tower4.jpg',
      ],
      "The Cairo Tower offers panoramic views of the bustling cityscape of Cairo, Egypt.",
      1,
     "https://www.tripadvisor.com/Attraction_Review-g294201-d459794-Reviews-Cairo_Tower-Cairo_Cairo_Governorate.html",
    false,
  ),
  Place(
      "Khan elkhalily",
      [
        'images/cairoplaces/khan1.jpg',
        'images/cairoplaces/khan2.jpg',
        'images/cairoplaces/khan3.jpg',
        'images/cairoplaces/khan4.jpg',
      ],
      "Khan el-Khalili: Cairo's bustling historic bazaar.",
      1,
     "https://www.introducingegypt.com/khan-el-khalili",
    false,
  ),
  Place(
      'The Egyptian Museum',
      [
        'images/cairoplaces/mus1.jpg',
        'images/cairoplaces/mus2.jpg',
        'images/cairoplaces/mus3.jpg',
        'images/cairoplaces/mus4.jpg',
      ],
      "The Egyptian Museum: home to Tutankhamun's treasures and mummies.",
      1,
    "https://egyptianmuseumcairo.eg/",
    false,
  ),
  Place(
      'The Hanging Church',
      [
        'images/cairoplaces/the1.jpg',
        'images/cairoplaces/the2.jpg',
        'images/cairoplaces/the3.jpg',
        'images/cairoplaces/the4.jpg',
      ],
      "The Hanging Church in Cairo is an ancient Egyptian church known for its unique architecture.",
      1,
     "http://www.coptic-cairo.com/oldcairo/church/mollaqa/mollaqa.html",
    false,
  ),
  Place(
      'The Pyramids',
      [
        'images/cairoplaces/py1.jpg',
        'images/cairoplaces/py2.jpg',
        'images/cairoplaces/py3.jpg',
        'images/cairoplaces/py4.jpg',
      ],
      "The Pyramids: iconic ancient structures standing tall in Egypt's desert sands.",
      1,
      "	https://www.britannica.com/topic/Pyramids-of-Giza",
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
  List<int> activeIndices = List.filled(cairoPlaces.length, 0);
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getPlacesPrices();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      cairoPlaces[index].isFavorite = !cairoPlaces[index].isFavorite;

      if (cairoPlaces[index].isFavorite) {
        favoritePlaces.add(cairoPlaces[index]);
      } else {
        favoritePlaces.remove(cairoPlaces[index]);
      }
    });
  }

  Future<void> getPlacesPrices() async {
    for (int i = 0; i < cairoPlaces.length; i++) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Touristic places')
          .doc(cairoPlaces[i].name)
          .get();
      if (document.exists) {
        int price = document.get('price');
        cairoPlaces[i] = Place(
          cairoPlaces[i].name,
          cairoPlaces[i].imagePaths,
          cairoPlaces[i].description,
          price,
          cairoPlaces[i].url,
          cairoPlaces[i].isFavorite,
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
          for (int i = 0; i < cairoPlaces.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: cairoPlaces[i]
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
                buildIndicator(activeIndices[i], cairoPlaces[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        cairoPlaces[i].name,
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
                              content: Text(cairoPlaces[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          cairoPlaces[i].isFavorite
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
                          _launchURL(cairoPlaces[i].url); // Launch URL when tapped
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
                    cairoPlaces[i].description,
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
                      if (!isLoading && cairoPlaces[i].price != 1)
                        Text(
                          cairoPlaces[i].price.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!isLoading && cairoPlaces[i].price != 1)
                        SizedBox(width: 8),
                      if (!isLoading && cairoPlaces[i].price != 1)
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 5, 59, 107),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isLoading && cairoPlaces[i].price == 1)
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
