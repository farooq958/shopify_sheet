import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shopify_sheet/shopify_sheet.dart';
import 'package:shopify_sheet/shopify_sheet_method_channel.dart';
import 'package:shopify_sheet/shopify_sheet_platform_interface.dart';

class MockShopifySheetPlatform
    with MockPlatformInterfaceMixin
    implements ShopifySheetPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> launchCheckout(String checkoutUrl) {
    // TODO: implement launchCheckout
    throw UnimplementedError();
  }

  @override
  // TODO: implement checkoutEvents
  Stream<Map<String, dynamic>> get checkoutEvents => throw UnimplementedError();

  @override
  Future<void> closeCheckout() => throw UnimplementedError();
}

void main() {
  final ShopifySheetPlatform initialPlatform = ShopifySheetPlatform.instance;

  test('$MethodChannelShopifySheet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShopifySheet>());
  });

  test('getPlatformVersion', () async {
    ShopifySheet shopifySheetPlugin = ShopifySheet();
    MockShopifySheetPlatform fakePlatform = MockShopifySheetPlatform();
    ShopifySheetPlatform.instance = fakePlatform;

    expect(await shopifySheetPlugin.getPlatformVersion(), '42');
  });
}
