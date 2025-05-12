import 'package:flutter/material.dart';

class PhotoDetailsScreen extends StatelessWidget {
  final String photoId;

  const PhotoDetailsScreen({super.key, required this.photoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo $photoId')),
      body: Center(child: Text('Details for photo $photoId')),
    );
  }
}