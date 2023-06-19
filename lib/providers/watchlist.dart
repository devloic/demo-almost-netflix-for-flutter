//
// watchlist.dart
// Netflix Clone
//
// Author: wess (wess@appwrite.io)
// Created: 01/19/2022
//
// Copywrite (c) 2022 Appwrite.io
//

import 'dart:async';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/models.dart';
import 'package:netflix_clone/api/client.dart';
import 'package:netflix_clone/data/entry.dart';
import 'package:flutter/material.dart';

class WatchListProvider extends ChangeNotifier {
  static final String _databaseId = appwrite.ID.custom("default");
  final String _collectionId = appwrite.ID.custom("watchlists");
  static final String _bucketId = appwrite.ID.custom("posters");

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  Future<Account> get user {
    return ApiClient.account.get();
  }

  Future<List<Entry>> list() async {
    _entries;

    return _entries;
  }

  Future<void> add(Entry entry) async {
    final user = await this.user;
    _entries.add(entry);
    notifyListeners();
    ApiClient.database.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: appwrite.ID.unique(),
        data: {
          "userId": user.$id,
          "movie": entry.id,
        });
  }

  Future<void> remove(Entry entry) async {
    final user = await this.user;
    _entries.removeWhere((element) => element.id == entry.id);
    notifyListeners();

    final result = await ApiClient.database.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          appwrite.Query.equal("userId", user.$id),
          appwrite.Query.equal("movie", entry.id)
        ]);

    final id = result.documents.first.$id;

    await ApiClient.database.deleteDocument(
        databaseId: _databaseId, collectionId: _collectionId, documentId: id);
  }

  Future<Uint8List> imageFor(Entry entry) async {
    return await ApiClient.storage.getFilePreview(
      bucketId: _bucketId,
      fileId: entry.thumbnailImageId,
      width: 80,
      height: 80,
    );
  }

  bool isOnList(Entry entry) => _entries.any((e) => e.id == entry.id);
}
