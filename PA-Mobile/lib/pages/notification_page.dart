import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Halaman notifikasi menampilkan satu pesan promo diskon.
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Kartu pesan notifikasi diskon.
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: AppStyle.card,
                border: Border.all(color: context.appBorderSubtle),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.appSecondaryContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_rounded,
                      size: 22,
                      color: context.appSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Promo Weekend: Diskon 25%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: context.appTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              'Hari ini',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.appTextMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dapatkan diskon 25% untuk komponen dan servis komputer. '
                              'Berlaku selama persediaan masih ada. '
                              'Yuk, cek produk promo di Beranda!',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}