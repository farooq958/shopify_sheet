import Flutter
import UIKit
import ShopifyCheckoutSheetKit

public class ShopifySheetPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var checkoutViewController: UIViewController?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "shopify_sheet", binaryMessenger: registrar.messenger())
        let instance = ShopifySheetPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel = FlutterEventChannel(name: "shopify_sheet_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launchCheckout":
            guard let args = call.arguments as? [String: Any],
                  let checkoutUrl = args["checkoutUrl"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid or missing arguments", details: nil))
                return
            }
            presentCheckout(url: checkoutUrl, result: result)
        case "closeCheckout":
            closeCheckout(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    private func presentCheckout(url: String, result: @escaping FlutterResult) {
        guard let checkoutURL = URL(string: url) else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid Checkout URL", details: nil))
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                result(FlutterError(code: "INVALID_CONTEXT", message: "No valid root view controller", details: nil))
                return
            }

        self.checkoutViewController = ShopifyCheckoutSheetKit.present(
                checkout: checkoutURL,
                from: rootViewController,
                delegate: self
            )
            result("Checkout Launched")
        }
    }

    private func closeCheckout(result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            if let checkoutViewController = self.checkoutViewController {
                checkoutViewController.dismiss(animated: true) {
                    self.checkoutViewController = nil
                    result("Checkout Closed")
                }
            } else {
                result(FlutterError(code: "NO_ACTIVE_CHECKOUT", message: "No active checkout to close", details: nil))
            }
        }
    }
}

extension ShopifySheetPlugin: CheckoutDelegate {
    public func checkoutDidComplete(event: CheckoutCompletedEvent) {
        do {
            let eventData = try encodeCheckoutCompletedEvent(event: event)
            self.eventSink?(["event": "completed", "data": eventData])
        } catch {
            self.eventSink?(["event": "completed", "error": "Failed to serialize checkout data"])
        }
    }

    public func checkoutDidCancel() {
        self.eventSink?(["event": "canceled"])
    }

    public func checkoutDidFail(error: ShopifyCheckoutSheetKit.CheckoutError) {
        self.eventSink?(["event": "failed", "error": error.localizedDescription])
    }

    public func checkoutDidEmitWebPixelEvent(event: ShopifyCheckoutSheetKit.PixelEvent) {
        var eventData: [String: Any] = [:]

        switch event {
        case .customEvent(let customEvent):
            eventData = [
                "type": "custom",
                "id": customEvent.id ?? "",
                "name": customEvent.name ?? "",
                "timestamp": customEvent.timestamp ?? "",
                "customData": customEvent.customData ?? "",
            ]
        case .standardEvent(let standardEvent):
            eventData = [
                "type": "standard",
                "id": standardEvent.id ?? "",
                "name": standardEvent.name ?? "",
                "timestamp": standardEvent.timestamp ?? "",
                "data": standardEvent.data != nil ? encodeStandardEventData(standardEvent.data!) : [:],
            ]
        }

        self.eventSink?(["event": "pixel_event", "data": eventData])
    }
}

// Helper functions remain the same
private func encodeStandardEventData(_ data: ShopifyCheckoutSheetKit.StandardEventData) -> [String: Any] {
    do {
        let jsonData = try JSONEncoder().encode(data)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
        if let dictionary = jsonObject as? [String: Any] {
            return dictionary
        }
    } catch {
        print("Error serializing StandardEventData: \(error)")
    }
    return [:]
}

private func encodeCheckoutCompletedEvent(event: CheckoutCompletedEvent) throws -> [String: Any] {
    let jsonData = try JSONEncoder().encode(event)
    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])

    guard let dictionary = jsonObject as? [String: Any] else {
        throw NSError(domain: "SerializationError", code: -1, userInfo: nil)
    }

    return dictionary
}