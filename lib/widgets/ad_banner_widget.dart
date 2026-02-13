import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:exani/services/admob_service.dart';
import 'package:exani/services/purchase_service.dart';

/// Reusable AdMob banner widget.
/// Handles loading, displaying, and disposing the banner ad.
/// Automatically hides when the user is a Pro subscriber.
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    // Only load ads if user is NOT pro
    if (!PurchaseService().isProUser) {
      _loadAd();
    }
  }

  void _loadAd() {
    _bannerAd = AdMobService.createBannerAd();
    _bannerAd!.load().then((_) {
      if (mounted) setState(() => _isReady = true);
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to premium changes to hide ads dynamically
    return ValueListenableBuilder<bool>(
      valueListenable: PurchaseService().isPro,
      builder: (context, isPro, _) {
        if (isPro) return const SizedBox.shrink();
        if (!_isReady || _bannerAd == null) return const SizedBox.shrink();
        return Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }
}
