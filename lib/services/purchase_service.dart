import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Product ID for the pro version (one-time purchase).
/// Must match the product ID configured in Google Play Console / App Store Connect.
const String kProProductId = 'pro_version';

/// Singleton service that manages in-app purchases.
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Whether the store is available on this device.
  bool _storeAvailable = false;

  /// The pro product details fetched from the store.
  ProductDetails? _proProduct;

  /// Current premium status — cached from SharedPreferences.
  bool _isPro = false;

  /// Notifier that widgets can listen to for premium status changes.
  final ValueNotifier<bool> isPro = ValueNotifier<bool>(false);

  /// Optional callback for showing messages to the user.
  void Function(String message)? onMessage;

  // ─── Initialization ──────────────────────────────────────────────────────

  Future<void> initialize() async {
    // Load cached premium status first (instant, no network needed)
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('is_pro') ?? false;
    isPro.value = _isPro;

    // Check if the store is available
    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) return;

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: _onDone,
      onError: _onError,
    );

    // Query product details
    await _loadProducts();

    // Restore previous purchases (important for reinstalls & new devices)
    await _iap.restorePurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails({kProProductId});
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Product not found: ${response.notFoundIDs}');
    }
    if (response.productDetails.isNotEmpty) {
      _proProduct = response.productDetails.first;
    }
  }

  // ─── Purchase Handling ────────────────────────────────────────────────────

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.productID != kProProductId) return;

    switch (purchase.status) {
      case PurchaseStatus.pending:
        onMessage?.call('Procesando compra...');
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // Verify & grant premium
        await _grantPro();
        if (purchase.status == PurchaseStatus.purchased) {
          onMessage?.call('¡Gracias! Ya eres usuario Pro 🎉');
        } else {
          onMessage?.call('Compra restaurada exitosamente ✅');
        }
        break;

      case PurchaseStatus.error:
        onMessage?.call('Error en la compra. Intenta de nuevo.');
        break;

      case PurchaseStatus.canceled:
        // User cancelled — do nothing
        break;
    }

    // Complete pending purchases (required by the store)
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  Future<void> _grantPro() async {
    _isPro = true;
    isPro.value = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro', true);
  }

  void _onDone() {
    _subscription?.cancel();
  }

  void _onError(dynamic error) {
    debugPrint('Purchase stream error: $error');
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Whether the user has purchased Pro.
  bool get isProUser => _isPro;

  /// The product details (title, price, description) from the store.
  ProductDetails? get proProduct => _proProduct;

  /// Whether the store is available and the product is loaded.
  bool get canPurchase => _storeAvailable && _proProduct != null && !_isPro;

  /// Formatted price string from the store (e.g. "$49.00 MXN").
  String get priceString => _proProduct?.price ?? '\$49.00 MXN';

  /// Start the purchase flow.
  Future<void> buyPro() async {
    if (_proProduct == null) {
      onMessage?.call('Producto no disponible. Verifica tu conexión.');
      return;
    }
    if (_isPro) {
      onMessage?.call('Ya eres usuario Pro ⭐');
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: _proProduct!);

    // Non-consumable = one-time purchase, permanent unlock
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore purchases (for users who reinstalled or switched devices).
  Future<void> restorePurchases() async {
    if (!_storeAvailable) {
      onMessage?.call('Tienda no disponible.');
      return;
    }
    await _iap.restorePurchases();
  }

  /// Clean up resources.
  void dispose() {
    _subscription?.cancel();
    isPro.dispose();
  }
}
