import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../restaurant.dart';

List<Rest> hurghadaRests = [
  Rest(
      "Corallo",
      [
        'images/hurghadares/ca3.jpg',
        'images/hurghadares/ca2.jpg',
        'images/hurghadares/ca4.jpg',
        'images/hurghadares/ca1.jpg',
      ],
      "Corala Restaurant: A charming seaside eatery in Egypt, serving fresh seafood with picturesque views.",
      "https://www.tripadvisor.com.eg/Restaurant_Review-g424910-d5970375-Reviews-Corallo_Sea_Food_Almaza_Bay-Mersa_Matruh_Matrouh_Governorate.html/",
    false,
  ),
  Rest(
      "La Cantina",
      [
        'images/hurghadares/laa1.jpg',
        'images/hurghadares/laa2.jpg',
        'images/hurghadares/laa4.jpg',
        'images/hurghadares/laa3.jpg',
      ],
      "La Cantina Restaurant and Bar: A vibrant dining venue in Egypt, offering delicious cuisine and refreshing drinks in a lively atmosphere.",
     "https://www.tripadvisor.com/Restaurant_Review-g297549-d25409730-Reviews-La_Cantina-Hurghada_Red_Sea_and_Sinai.html/",
    false,
  ),
  Rest(
      'MAKAI TUKAI',
      [
        'images/hurghadares/maka1.jpg',
        'images/hurghadares/maka2.jpg',
        'images/hurghadares/maka3.jpg',
        'images/hurghadares/maka4.jpg',
      ],
      "Makai Tukai: A cozy eatery in Egypt, serving flavorful dishes in a relaxed setting, perfect for a casual dining experience.",
     "https://www.tripadvisor.com.eg/Restaurant_Review-g297549-d7313956-Reviews-Makai_Tukai_Restaurant-Hurghada_Red_Sea_and_Sinai.html/",
    false,
  ),
  Rest(
      'Nino\'s Resturant',
      [
        'images/hurghadares/nino1.jpg',
        'images/hurghadares/nino2.jpg',
        'images/hurghadares/nino3.jpg',
        'images/hurghadares/nino4.jpg',
      ],
      "Nino's Restaurant: A favorite spot in Egypt for delicious food in a cozy atmosphere.",
      "https://www.tripadvisor.com/Restaurant_Review-g297549-d7173339-Reviews-Nino_s_Restaurant-Hurghada_Red_Sea_and_Sinai.html/",
    false,
  ),
  Rest(
      'Sofra Oriental',
      [
        'images/hurghadares/sof1.jpg',
        'images/hurghadares/sof2.jpg',
        'images/hurghadares/sof3.jpg',
        'images/hurghadares/sof4.jpg',
      ],
      "Sofra Oriental: Egypt's go-to for authentic Oriental cuisine in a cozy setting.",
     "https://www.tripadvisor.com/Restaurant_Review-g297549-d3752928-Reviews-or60-Sofra-Hurghada_Red_Sea_and_Sinai.html/",
    false,
  ),
  // Add more hotels here
];

class ScreenTwo extends StatefulWidget {
  ScreenTwo({Key? key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  List<Rest> favoriteRest = [];
  List<int> activeIndices = List.filled(hurghadaRests.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      hurghadaRests[index].isFavorite = !hurghadaRests[index].isFavorite;

      if (hurghadaRests[index].isFavorite) {
        favoriteRest.add(hurghadaRests[index]);
      } else {
        favoriteRest.remove(hurghadaRests[index]);
      }
    });
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
              'Restaurant',
              style: TextStyle(
                fontFamily: 'MadimiOne',
                color: Color.fromARGB(255, 121, 155, 230),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < hurghadaRests.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: hurghadaRests[i]
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
                    activeIndices[i], hurghadaRests[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        hurghadaRests[i].name,
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
                              content: Text(hurghadaRests[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          hurghadaRests[i].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Color.fromARGB(255, 13, 16, 74),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Color.fromARGB(255, 13, 16, 74),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _launchURL(hurghadaRests[i].url); // Launch URL when tapped
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
                    hurghadaRests[i].description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 36, 108, 163),
                      fontFamily: 'MadimiOne',
                    ),
                    textAlign: TextAlign.left,
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
