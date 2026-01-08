package com.checkoutsheetshopify.shopify_sheet

import android.app.Activity
import android.graphics.Color
import androidx.annotation.NonNull
import com.shopify.checkoutsheetkit.ShopifyCheckoutSheetKit
import com.shopify.checkoutsheetkit.DefaultCheckoutEventProcessor
import com.shopify.checkoutsheetkit.lifecycleevents.CheckoutCompletedEvent
import com.shopify.checkoutsheetkit.CheckoutException
import com.shopify.checkoutsheetkit.ColorScheme
import com.shopify.checkoutsheetkit.Configuration
import com.shopify.checkoutsheetkit.Colors
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.util.Log
import com.shopify.checkoutsheetkit.CheckoutSheetKitDialog
import com.shopify.checkoutsheetkit.LogLevel
import com.shopify.checkoutsheetkit.Preloading

/** ShopifySheetPlugin */
class ShopifySheetPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null
    private var checkoutSheet: CheckoutSheetKitDialog? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "shopify_sheet")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "shopify_sheet_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "launchCheckout" -> {
                val checkoutUrl = call.argument<String>("checkoutUrl")
                val configMap = call.argument<Map<String, Any>>("config")

                if (checkoutUrl != null) {
                    launchCheckout(checkoutUrl, configMap, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "Checkout URL is null", null)
                }
            }

            "closeCheckout" -> {
                closeCheckout(result)
            }

            else -> result.notImplemented()
        }
    }

    private fun launchCheckout(
        checkoutUrl: String,
        configMap: Map<String, Any>?,
        result: MethodChannel.Result
    ) {
        val currentActivity = activity
        if (currentActivity is androidx.activity.ComponentActivity) {
            try {
                // Apply configuration if provided
                if (configMap != null) {
                    applyConfiguration(configMap)
                }

                checkoutSheet = ShopifyCheckoutSheetKit.present(
                    checkoutUrl,
                    currentActivity,
                    object : DefaultCheckoutEventProcessor(currentActivity) {
                        override fun onCheckoutCanceled() {
                            eventSink?.success(
                                mapOf(
                                    "event" to "canceled",
                                    "error" to null
                                )
                            )
                        }

                        override fun onCheckoutCompleted(checkoutCompletedEvent: CheckoutCompletedEvent) {
                            eventSink?.success(
                                mapOf(
                                    "event" to "completed",
                                    "error" to null
                                )
                            )
                        }

                        override fun onCheckoutFailed(error: CheckoutException) {
                            eventSink?.success(
                                mapOf(
                                    "event" to "failed",
                                    "error" to error.message
                                )
                            )
                        }
                    })
                result.success("Checkout Launched")
            } catch (e: Exception) {
                Log.e("ShopifySheetPlugin", "Error launching checkout", e)
                result.error("CHECKOUT_ERROR", "Error launching checkout", e.message)
            }
        } else {
            result.error(
                "INVALID_CONTEXT",
                "Activity is not a ComponentActivity. Actual: ${currentActivity?.javaClass?.name}",
                null
            )
        }
    }

    private fun applyConfiguration(configMap: Map<String, Any>) {
        try {
            ShopifyCheckoutSheetKit.configure { config ->
                // Color scheme configuration
                configMap["colorScheme"]?.let { scheme ->
                    config.colorScheme = when (scheme as String) {
                        "light" -> ColorScheme.Light()
                        "dark" -> ColorScheme.Dark()
                        "web" -> ColorScheme.Web()
                        else -> ColorScheme.Automatic()
                    }
                }

                // Title configuration (Android reads from strings.xml)
                // Note: On Android, title must be set via res/values/strings.xml
                // with key "checkout_web_view_title"

                // Colors configuration
                val titleBarBg = configMap["titleBarBackgroundColor"] as? String
                val bgColor = configMap["backgroundColor"] as? String
                val tintColor = configMap["tintColor"] as? String
                val titleBarText = configMap["title"] as? String?

                // Only set colors if we're using Web or Automatic with overrides





                // Preloading configuration
                configMap["preload"]?.let { preload ->

                    config.preloading =  Preloading(enabled = preload as Boolean)

                }

                // Optional: Uncomment for debug logging
                // config.logLevel = LogLevel.DEBUG
            }
        } catch (e: Exception) {
            Log.e("ShopifySheetPlugin", "Error applying configuration", e)
        }
    }

    private fun parseColor(colorString: String): Int {
        return try {
            Color.parseColor(colorString)
        } catch (e: Exception) {
            Log.e("ShopifySheetPlugin", "Invalid color format: $colorString", e)
            Color.BLACK // Default fallback
        }
    }

    private fun closeCheckout(result: MethodChannel.Result) {
        checkoutSheet?.dismiss()
        checkoutSheet = null
        result.success("Checkout Closed")
    }

    // Handle activity lifecycle
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}