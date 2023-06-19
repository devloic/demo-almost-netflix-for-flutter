//
// watchlist.dart
// Netflix Clone
//
// Author: wess (wess@appwrite.io)
// Created: 01/19/2022
//
// Copywrite (c) 2022 Appwrite.io
//

import 'dart:typed_data';
import 'package:expand_tap_area/expand_tap_area.dart';

import 'package:flutter/material.dart';
import 'package:netflix_clone/providers/watchlist.dart';
import 'package:netflix_clone/screens/details.dart';
import 'package:netflix_clone/screens/home.dart';
import 'package:netflix_clone/screens/navigation.dart';
import 'package:netflix_clone/widgets/buttons/icon.dart';
import 'package:provider/provider.dart';
import 'package:netflix_clone/data/entry.dart';
import 'package:netflix_clone/providers/entry.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _row(Entry entry) {
    var hasTapped = false;
    Future<Uint8List> f = context.watch<EntryProvider>().imageFor(entry);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<Uint8List>(
          future: f,
          builder: (context, snapshot) =>
              snapshot.hasData && snapshot.data != null
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: Image.memory(snapshot.data!).image,
                        ),
                      ),
                    )
                  : Container(),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              ((entry.description ?? "").length < 51)
                  ? (entry.description ?? "")
                  : "${(entry.description ?? "").substring(0, 50)}...",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
          child: ExpandTapWidget(
            onTap: () {},
            tapPadding: const EdgeInsets.all(25.0),
            child: VerticalIconButton(
                icon: Icons.delete,
                title: '',
                tap: () async {
                  if (hasTapped == false) {
                    hasTapped = true;
                    await context.read<WatchListProvider>().remove(entry);
                  }
                }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var f = context.watch<WatchListProvider>().list();
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          currentIndex: 0,
          onTap: (index) async {
            if (index == 0) {
              Navigator.of(context).pop();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Watchlist',
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Watchlist'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Entry>>(
            future: f,
            builder: (context, snapshot) {
              return snapshot.hasData == false || snapshot.data == null
                  ? const Padding(
                      padding: EdgeInsets.all(60),
                      child: Center(child: CircularProgressIndicator()))
                  : ListView(
                      children: snapshot.data!
                          .map((entry) => GestureDetector(
                              child: _row(entry),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        DetailsScreen(entry: entry));
                              }))
                          .toList(),
                    );
            }));
  }
}
