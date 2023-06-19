//
// entry.dart
// appflix
//
// Author: wess (me@wess.io)
// Created: 01/03/2022
//
// Copywrite (c) 2022 Wess.io
//

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:netflix_clone/api/client.dart';
import 'package:netflix_clone/data/entry.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final Map<String, Uint8List> _imageCache = {};

  static final String _databaseId = ID.custom("default");
  static final String _collectionId = ID.custom("movies");
  static final String _bucketId = ID.custom("posters");

  Entry? _selected;
  Entry? get selected => _selected;

  Entry _featured = Entry.empty();
  Entry get featured => _featured;

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;
  List<Entry> get originals => _entries.where((e) => e.isOriginal).toList();
  List<Entry> get animations =>
      _entries.where((e) => e.genres.contains('Animation')).toList();
  List<Entry> get newReleases => _entries
      .where((e) =>
          e.releaseDate != null &&
          e.releaseDate!.isAfter(DateTime.parse('2018-01-01')))
      .toList();

  List<Entry> get trending {
    var trending = _entries;

    trending.sort((a, b) => b.trendingIndex.compareTo(a.trendingIndex));

    return trending;
  }

  Future<void> list() async {
    var result = await ApiClient.database
        .listDocuments(databaseId: _databaseId, collectionId: _collectionId);
    _entries = result.documents.map((document) {
      Entry entry = Entry(
          id: document.data["\$id"] ?? "",
          name: document.data["name"] ?? "",
          ageRestriction: document.data["ageRestriction"] ?? "",
          durationMinutes:
              Duration(minutes: document.data["durationMinutes"] ?? 0),
          thumbnailImageId: document.data["thumbnailImageId"] ?? "",
          trendingIndex: document.data["trendingIndex"] ?? "",
          isOriginal: document.data["isOriginal"] ?? "",
          cast: document.data["cast"],
          genres: document.data["genres"],
          tags: document.data["tags"]);
      return entry;
    }).toList();
    Random random = new Random();
    int randomNumber = random.nextInt(_entries.length);
    _featured = _entries.isEmpty ? Entry.empty() : _entries[randomNumber];

    notifyListeners();
  }

  Future<Uint8List> imageFor(Entry entry) async {
    if (_imageCache.containsKey(entry.thumbnailImageId)) {
      return _imageCache[entry.thumbnailImageId]!;
    }

    final result = await ApiClient.storage.getFilePreview(
      bucketId: _bucketId,
      fileId: entry.thumbnailImageId,
      height: 500,
    );

    _imageCache[entry.thumbnailImageId] = result;

    return result;
  }
}
