import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../restaurant.dart';

List<Rest> sinaiRests= [
  Rest(
      "Athanor Pizzeria",
      [
        'images/sinairest/anth1.jpg',
        'images/sinairest/anth2.jpg',
        'images/sinairest/anth3.jpg',
        'images/sinairest/anth4.jpg',
      ],
      "Athanor Pizzeria: A cozy pizzeria in Egypt, serving up delicious pies with a variety of toppings in a relaxed atmosphere.",
     "https://www.elmenus.com/dahab/athanor-r92w",
    false,
  ),
  Rest(
      "Boharat Restaurant",
      [
        'images/sinairest/boh1.jpg',
        'images/sinairest/boh2.jpg',
        'images/sinairest/boh3.jpg',
        'images/sinairest/boh4.jpg',
      ],
      "Boharat Restaurant: A taste of excellence in Egypt, with flavorful dishes served in a cozy setting.",
     "https://www.tripadvisor.com/Restaurant_Review-g297555-d10665099-Reviews-Boharat_Restaurant-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html",
    false,
  ),
  Rest(
      'Camel Bar & Rooftop',
      [
        'images/sinairest/cam1.jpg',
        'images/sinairest/cam2.jpg',
        'images/sinairest/cam3.jpg',
        'images/sinairest/cam4.jpg',
      ],
      "Camel Bar & Rooftop: A lively spot in Egypt, offering refreshing drinks and a vibrant atmosphere with stunning rooftop views.",
     "https://www.cameldive.com/food-and-drinks-camel-bar-rooftop/",
    false,
  ),
  Rest(
      'King Chicken',
      [
        'images/sinairest/king1.jpg',
        'images/sinairest/king2.jpg',
        'images/sinairest/king3.jpg',
        'images/sinairest/king4.jpg',
      ],
      "King Chicken Restaurant: Egypt's hotspot for tasty chicken in a friendly atmosphere.",
      "https://www.tripadvisor.com/Restaurant_Review-g297547-d2033607-Reviews-King_Chicken-Dahab_South_Sinai_Red_Sea_and_Sinai.html",
    false,
  ),
  Rest(
      'Mango Restaurant',
      [
        'images/sinairest/mango1.jpg',
        'images/sinairest/mango2.jpg',
        'images/sinairest/mango3.jpg',
        'images/sinairest/mango4.jpg',
      ],
      "Mango Restaurant: A delightful dining spot in Egypt, offering delicious cuisine with a tropical twist in a relaxed setting.",
      "https://www.tripadvisor.com/Restaurant_Review-g297555-d20069368-Reviews-Mango_Chinese_Restaurant-Sharm_El_Sheikh_South_Sinai_Red_Sea_and_Sinai.html",
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
  List<int> activeIndices = List.filled(sinaiRests.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      sinaiRests[index].isFavorite = !sinaiRests[index].isFavorite;

      if (sinaiRests[index].isFavorite) {
        favoriteRest.add(sinaiRests[index]);
      } else {
        favoriteRest.remove(sinaiRests[index]);
      }
    });
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
          for (int i = 0; i < sinaiRests.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: sinaiRests[i]
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
                    activeIndices[i], sinaiRests[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        sinaiRests[i].name,
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
                              content: Text(sinaiRests[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          sinaiRests[i].isFavorite
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
                          _launchURL(sinaiRests[i].url); // Launch URL when tapped
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
                    sinaiRests[i].description,
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
