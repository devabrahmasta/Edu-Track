import 'package:dotlottie_flutter/dotlottie_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/routes.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorMessage;
  bool _animationFailed = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    setState(() => _errorMessage = null);
    final authProvider = context.read<AuthProvider>();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      final isLoggedIn = await authProvider.restoreSession();
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacementNamed(isLoggedIn ? AppRoutes.home : AppRoutes.login);
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 184,
                height: 184,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: _animationFailed
                        ? const Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.navy,
                            size: 78,
                          )
                        : DotLottieView(
                            sourceType: 'asset',
                            source: 'book_with_bookmark.lottie',
                            autoplay: true,
                            loop: true,
                            fit: BoxFit.contain,
                            onLoadError: () {
                              if (mounted) {
                                setState(() => _animationFailed = true);
                              }
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _errorMessage == null
                    ? _animationFailed
                          ? 'Animasi pemuatan tidak dapat ditampilkan.'
                          : 'Mempersiapkan ruang belajar...'
                    : 'Sesi belum dapat diperiksa',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_errorMessage case final message?) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _checkSession,
                  child: const Text('Coba lagi'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.login),
                  child: const Text('Lanjut ke halaman masuk'),
                ),
              ] else ...[
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: AppColors.border,
                    color: AppColors.green,
                  ),
                ),
              ],
              const Spacer(),
              const Divider(color: AppColors.border),
              const SizedBox(height: 10),
              Text(
                'Versi 0.1.0  •  Kelompok 01 ITC UPNYK',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
