import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shopify_sheet/shopify_sheet_method_channel.dart';

abstract class ShopifySheetPlatform extends PlatformInterface {
  ShopifySheetPlatform() : super(token: _token);

  static final Object _token = Object();
  static ShopifySheetPlatform _instance = MethodChannelShopifySheet();

  static ShopifySheetPlatform get instance => _instance;

  static set instance(ShopifySheetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> launchCheckout(String checkoutUrl) {
    throw UnimplementedError('launchCheckout() has not been implemented.');
  }

  /// Stream of checkout events
  Stream<Map<String, dynamic>> get checkoutEvents {
    throw UnimplementedError('checkoutEvents has not been implemented.');
  }

  Future<void> closeCheckout() {
    throw UnimplementedError('checkoutEvents has not been implemented.');
  }
}
