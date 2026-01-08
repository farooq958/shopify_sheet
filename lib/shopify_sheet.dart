import 'dart:ui';

import 'package:shopify_sheet/shopify_sheet_platform_interface.dart';

/// Event data for Shopify Checkout
class ShopifySheetEvent {
  final ShopifySheetEventType type;
  final String? error;
  final Map<dynamic, dynamic>? data; // Add this field to include detailed data

  ShopifySheetEvent({
    required this.type,
    this.error,
    this.data,
  });

  /// Factory to parse event data from native
  factory ShopifySheetEvent.fromNative(Map<String, dynamic> data) {
    final eventType = data['event'];
    final error = data['error'] as String?;
    final eventData =
        data['data'] as Map<dynamic, dynamic>?; // Extract additional data

    switch (eventType) {
      case 'completed':
        return ShopifySheetEvent(
          type: ShopifySheetEventType.completed,
          error: error,
          data: eventData, // Pass additional data for completed event
        );
      case 'canceled':
        return ShopifySheetEvent(
          type: ShopifySheetEventType.canceled,
          error: error,
        );
      case 'failed':
        return ShopifySheetEvent(
          type: ShopifySheetEventType.failed,
          error: error,
        );
      case 'pixel_event':
        return ShopifySheetEvent(
            type: ShopifySheetEventType.pixelEvent, data: eventData);
      default:
        return ShopifySheetEvent(
          type: ShopifySheetEventType.unknown,
          error: error,
        );
    }
  }
}

/// Enum for Shopify Checkout event types
enum ShopifySheetEventType { completed, canceled, failed, unknown, pixelEvent }

class ShopifySheet {
  Future<String?> getPlatformVersion() {
    return ShopifySheetPlatform.instance.getPlatformVersion();
  }

  Future<void> launchCheckout(
      String checkoutUrl, {
        ShopifySheetConfiguration? configuration,
      }) {
    return ShopifySheetPlatform.instance.launchCheckout(
      checkoutUrl,
      configuration: configuration,
    );
  }

  /// Listen for checkout events
  Stream<ShopifySheetEvent> get checkoutEvents {
    return ShopifySheetPlatform.instance.checkoutEvents.map((event) {
      return ShopifySheetEvent.fromNative(event);
    });
  }

  Future<void> closeCheckout() {
    return ShopifySheetPlatform.instance.closeCheckout();
  }
}




/// Configuration class for Shopify Checkout Sheet
class ShopifySheetConfiguration {
  /// Title text for the checkout sheet
  final String? title;

  /// Title bar background color (hex string format: "#RRGGBB")
  /// On iOS: Sets the sheet background color
  /// On Android: Sets the header background color
  final String? titleBarBackgroundColor;

  /// Background color for the checkout sheet (hex string format: "#RRGGBB")
  final String? backgroundColor;

  /// Tint color for UI elements like progress indicator (hex string format: "#RRGGBB")
  final String? tintColor;

  /// Close button tint color (hex string format: "#RRGGBB") (iOS only)
  final String? closeButtonTintColor;

  /// Enable preloading of checkout
  final bool? preload;

  /// Color scheme preference (light, dark, automatic, or web)
  final String? colorScheme;

  ShopifySheetConfiguration({
    this.title,
    this.titleBarBackgroundColor,
    this.backgroundColor,
    this.tintColor,
    this.closeButtonTintColor,
    this.preload,
    this.colorScheme = 'automatic',
  });

  /// Convert Flutter Color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Create configuration with Flutter Colors
  factory ShopifySheetConfiguration.fromColors({
    String? title,
    Color? titleBarBackgroundColor,
    Color? backgroundColor,
    Color? tintColor,
    Color? closeButtonTintColor,
    bool? preload,
    String? colorScheme,
  }) {
    return ShopifySheetConfiguration(
      title: title,
      titleBarBackgroundColor: titleBarBackgroundColor != null ? colorToHex(titleBarBackgroundColor) : null,
      backgroundColor: backgroundColor != null ? colorToHex(backgroundColor) : null,
      tintColor: tintColor != null ? colorToHex(tintColor) : null,
      closeButtonTintColor: closeButtonTintColor != null ? colorToHex(closeButtonTintColor) : null,
      preload: preload,
      colorScheme: colorScheme ?? 'automatic',
    );
  }

  /// Convert to map for platform channel
  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (titleBarBackgroundColor != null) 'titleBarBackgroundColor': titleBarBackgroundColor,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (tintColor != null) 'tintColor': tintColor,
      if (closeButtonTintColor != null) 'closeButtonTintColor': closeButtonTintColor,
      if (preload != null) 'preload': preload,
      if (colorScheme != null) 'colorScheme': colorScheme,
    };
  }
}