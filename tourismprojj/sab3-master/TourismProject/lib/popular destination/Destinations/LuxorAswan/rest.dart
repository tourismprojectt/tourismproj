import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../restaurant.dart';

List<Rest> luxorAswanRests= [
  Rest(
      "Sofra",
      [
        'images/luxorandaswanres/sofra1.jpg',
        'images/luxorandaswanres/sofra2.jpg',
        'images/luxorandaswanres/sofra3.jpg',
        'images/luxorandaswanres/sofra4.jpg',
      ],
      "Sofra Restaurant: A popular dining destination in Egypt, renowned for its authentic and mouthwatering Egyptian cuisine served in a cozy and welcoming atmosphere.",
       "https://www.sofra.com.eg/",
    false,
  ),
  Rest(
      "The Lantern Room",
      [
        'images/luxorandaswanres/la1.jpg',
        'images/luxorandaswanres/la2.jpg',
        'images/luxorandaswanres/la3.jpg',
        'images/luxorandaswanres/la4.jpg',
      ],
      "The Lantern Room Restaurant: A cozy dining spot in Egypt, offering delicious food and a warm ambiance, perfect for a memorable meal with loved ones.",
     "https://www.tripadvisor.com/Restaurant_Review-g294205-d754056-Reviews-The_Lantern_Room_Restaurant-Luxor_Nile_River_Valley.html/",
    false,
  ),
  Rest(
      'Tout Ankh Amoun Restaurant',
      [
        'images/luxorandaswanres/tot1.jpg',
        'images/luxorandaswanres/tot2.jpg',
        'images/luxorandaswanres/tot3.jpg',
        'images/luxorandaswanres/tot4.jpg',
      ],
      "Tout Ankh Amoun Restaurant: A charming eatery in Egypt, named after the legendary Pharaoh, offering delectable cuisine and a unique dining experience inspired by ancient Egyptian culture.",
       "https://www.tripadvisor.co.uk/Restaurant_Review-g19118142-d23309219-Reviews-Tut_Ankh_Amun-Al_Badrashin_Giza_Governorate.html/",
    false,
  ),
  Rest(
      'Almasry Restaurant',
      [
        'images/luxorandaswanres/al2.jpg',
        'images/luxorandaswanres/al3.jpg',
        'images/luxorandaswanres/al4.jpg',
        'images/luxorandaswanres/al1.jpg',
      ],
      "Almasry Restaurant: A beloved eatery in Egypt, serving authentic Egyptian cuisine with a friendly vibe.",
      "https://www.tripadvisor.com/Restaurant_Review-g294204-d1488292-Reviews-Al_Masry-Aswan_Aswan_Governorate_Nile_River_Valley.html/",
    false,
  ),
  Rest(
      'ElDokka Restaurant',
      [
        'images/luxorandaswanres/dok2.jpg',
        'images/luxorandaswanres/dok3.jpg',
        'images/luxorandaswanres/dok4.jpg',
        'images/luxorandaswanres/dok1.jpg',
      ],
      "ElDokka Restaurant: A charming spot in Egypt for a cozy meal with tasty dishes.",
      "https://www.tripadvisor.com/Restaurant_Review-g294204-d1309045-Reviews-El_Dokka-Aswan_Aswan_Governorate_Nile_River_Valley.html/",
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
  List<int> activeIndices = List.filled(luxorAswanRests.length, 0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void toggleFavoriteStatus(int index) {
    setState(() {
      luxorAswanRests[index].isFavorite = !luxorAswanRests[index].isFavorite;

      if (luxorAswanRests[index].isFavorite) {
        favoriteRest.add(luxorAswanRests[index]);
      } else {
        favoriteRest.remove(luxorAswanRests[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Luxor And Aswan',
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
              MaterialPageRoute(builder: (context) => ThirdRoute()),
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
          for (int i = 0; i < luxorAswanRests.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: luxorAswanRests[i]
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
                    activeIndices[i], luxorAswanRests[i].imagePaths.length),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        luxorAswanRests[i].name,
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
                              content: Text(luxorAswanRests[i].isFavorite
                                  ? 'Added to Favorites!'
                                  : 'Removed from Favorites!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Icon(
                          luxorAswanRests[i].isFavorite
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
                          _launchURL(luxorAswanRests[i].url); // Launch URL when tapped
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
                    luxorAswanRests[i].description,
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
