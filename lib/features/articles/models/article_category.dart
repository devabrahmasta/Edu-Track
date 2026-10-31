import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ArticleCategory {
  const ArticleCategory({
    required this.name,
    required this.tag,
    required this.icon,
    this.description = '',
    this.accentColor = AppColors.navy,
  });

  final String name;
  final String tag;
  final IconData icon;
  final String description;
  final Color accentColor;

  static const defaults = <ArticleCategory>[
    ArticleCategory(
      name: 'Flutter',
      tag: 'flutter',
      icon: Icons.flutter_dash,
      description: 'Bikin aplikasi Android & iOS sekaligus',
      accentColor: AppColors.navy,
    ),
    ArticleCategory(
      name: 'Dart',
      tag: 'dart',
      icon: Icons.code_rounded,
      description: 'Dasar logika & bahasa pemrograman',
      accentColor: AppColors.green,
    ),
    ArticleCategory(
      name: 'Android',
      tag: 'android',
      icon: Icons.android_rounded,
      description: 'Pengembangan aplikasi mobile native',
      accentColor: AppColors.green,
    ),
    ArticleCategory(
      name: 'Python',
      tag: 'python',
      icon: Icons.terminal_rounded,
      description: 'Kecerdasan buatan & data science',
      accentColor: AppColors.gold,
    ),
    ArticleCategory(
      name: 'Web Dev',
      tag: 'webdev',
      icon: Icons.language_rounded,
      description: 'Bikin website interaktif modern',
      accentColor: AppColors.navy,
    ),
  ];
}