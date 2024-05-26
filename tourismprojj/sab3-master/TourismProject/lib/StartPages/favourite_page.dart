import 'package:flutter/material.dart';
import '../popular%20destination/Destinations/hotel.dart';
import 'package:new_project/popular%20destination/Destinations/HotelTolist.dart';
import '../popular%20destination/Destinations/place.dart';
import 'package:new_project/popular%20destination/Destinations/PlaceTolist.dart';
import '../popular%20destination/Destinations/restaurant.dart';
import 'package:new_project/popular%20destination/Destinations/restTolist.dart';

class FavoriteHotel extends StatelessWidget {
  final List<dynamic> favoriteHotels;

  FavoriteHotel(this.favoriteHotels);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Hotels'),
      ),
      body: ListView.builder(
        itemCount: favoriteHotels.length,
        itemBuilder: (context, index) {
          if (favoriteHotels[index] is Hotel) {
            return HotelListItem(
              favoriteHotels[index] as Hotel,
              index,
              (favoriteHotels[index] as Hotel).imagePaths,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class FavoritePlace extends StatelessWidget {
  final List<dynamic> favoriteplaces;

  FavoritePlace(this.favoriteplaces);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Places'),
      ),
      body: ListView.builder(
        itemCount: favoriteplaces.length,
        itemBuilder: (context, index) {
          if (favoriteplaces[index] is Place) {
            return PlaceListItem(
              favoriteplaces[index] as Place,
              index,
              (favoriteplaces[index] as Place).imagePaths,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class favoriteRest extends StatelessWidget {
  final List<dynamic> favoriterests;

  favoriteRest(this.favoriterests);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: ListView.builder(
        itemCount: favoriterests.length,
        itemBuilder: (context, index) {
          if (favoriterests[index] is Rest) {
            return RestListItem(
              favoriterests[index] as Rest,
              index,
              (favoriterests[index] as Rest).imagePaths,
            );
          }
          return Container();
        },
      ),
    );
  }
}
