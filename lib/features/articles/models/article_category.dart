import 'package:flutter/material.dart';

class ArticleCategory {
  const ArticleCategory({
    required this.name,
    required this.tag,
    required this.icon,
  });

  final String name;
  final String tag;
  final IconData icon;

  static const defaults = <ArticleCategory>[
    ArticleCategory(name: 'Flutter', tag: 'flutter', icon: Icons.flutter_dash),
    ArticleCategory(name: 'Dart', tag: 'dart', icon: Icons.code),
    ArticleCategory(name: 'Android', tag: 'android', icon: Icons.android),
    ArticleCategory(name: 'Python', tag: 'python', icon: Icons.terminal),
    ArticleCategory(name: 'Web Development', tag: 'webdev', icon: Icons.language),
  ];
}