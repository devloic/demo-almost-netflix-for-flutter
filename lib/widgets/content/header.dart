//
// header.dart
// appflix
//
// Author: wess (me@wess.io)
// Created: 01/03/2022
//
// Copywrite (c) 2022 Wess.io
//

import 'dart:typed_data';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:netflix_clone/data/entry.dart';
import 'package:netflix_clone/providers/entry.dart';
import 'package:netflix_clone/providers/watchlist.dart';
import 'package:netflix_clone/screens/details.dart';
import 'package:netflix_clone/widgets/buttons/icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentHeader extends StatelessWidget {
  final Entry featured;
  const ContentHeader({Key? key, required this.featured}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasTapped = false;

    bool isOnList = context.watch<WatchListProvider>().isOnList(featured);
    Future f = context.watch<EntryProvider>().imageFor(featured);
    return FutureBuilder(
        future: f,
        builder: (context, snapshot) {
          if (snapshot.hasData == false || snapshot.data == null) {
            return const SizedBox(
              height: 500,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Stack(alignment: Alignment.center, children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory((snapshot.data! as Uint8List)).image,
                ),
              ),
            ),
            Container(
              height: 500,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              child: SizedBox(
                  width: 250,
                  child: Text(
                    featured.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  ExpandTapWidget(
                    onTap: () {},
                    tapPadding: const EdgeInsets.all(35.0),
                    child: VerticalIconButton(
                      icon: isOnList ? Icons.check : Icons.add,
                      title: 'Watchlist',
                      tap: () {
                        if (hasTapped == false) {
                          hasTapped = true;
                          if (isOnList) {
                            context.read<WatchListProvider>().remove(featured);
                          } else {
                            context.read<WatchListProvider>().add(featured);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 40),
                  MaterialButton(
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.play_arrow, color: Colors.black),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Play'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () {}),
                  const SizedBox(width: 40),
                  VerticalIconButton(
                    icon: Icons.info,
                    title: 'Info',
                    tap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => DetailsScreen(entry: featured));
                    },
                  ),
                  const Spacer(),
                ],
              ),
            )
          ]);
        });
  }
}
