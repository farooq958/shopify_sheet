# Shopify Sheet Flutter Plugin

The **Shopify Sheet Flutter Plugin** is a powerful tool to seamlessly integrate the Shopify Checkout Sheet SDK into your Flutter app. This plugin provides a clean and simple API to launch the Shopify Checkout Sheet and handle events like completion, cancellation, and errors.

## Features
- Launch the Shopify Checkout Sheet from your Flutter app.
- Handle events like checkout completion, cancellation, and failures with structured enums.
- Full compatibility with Flutter’s modern embedding (v2).

---

## Getting Started

### **1. Installation**
Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  shopify_sheet: ^0.0.7
```

Run the following command to get the package:

```bash
flutter pub get
```

---

### **2. Android Configuration**

#### **2.1 Update `MainActivity`**
To support the Shopify Checkout Sheet, your app’s `MainActivity` must extend `FlutterFragmentActivity` instead of `FlutterActivity`.

Update your `MainActivity`:

**Path**: `android/app/src/main/kotlin/<your-package-name>/MainActivity.kt`

```kotlin
package <your-package-name>

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    // No additional code needed
}
```

#### **2.2 Update `AndroidManifest.xml`**
Ensure that your `AndroidManifest.xml` file references the updated `MainActivity`.

**Path**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your-package-name>">

    <application
        android:label="your_app"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/NormalTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

#### **2.3 Update `build.gradle`**

**App-Level `build.gradle`**

Add the following dependencies to the `dependencies` block in your `app-level build.gradle` file:

**Path**: `android/app/build.gradle`

```gradle
dependencies {
    implementation "androidx.activity:activity:1.7.2" // For ComponentActivity compatibility
    implementation "androidx.fragment:fragment:1.5.7" // Fragment support (used internally by FlutterFragmentActivity)
    implementation "com.google.android.material:material:1.9.0" // Material components (if needed)
    implementation "androidx.lifecycle:lifecycle-runtime-ktx:2.6.1" // Lifecycle for event handling
}
```

#### **2.4 Minimum SDK Version**
Ensure that the `minSdkVersion` in your `build.gradle` file is set to at least `23`:

```gradle
android {
    defaultConfig {
        minSdkVersion 23
    }
}
```

---
### **3. iOS Configuration**
make sure the project dependency is greater than or equal to `13.0`
### **4. Usage**

#### **4.1 Launch Shopify Checkout**

Here’s how to launch the Shopify Checkout Sheet and listen for events:

```dart
import 'package:shopify_sheet/shopify_sheet.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopifyCheckoutDemo(),
    );
  }
}

class ShopifyCheckoutDemo extends StatefulWidget {
  @override
  State<ShopifyCheckoutDemo> createState() => _ShopifyCheckoutDemoState();
}

class _ShopifyCheckoutDemoState extends State<ShopifyCheckoutDemo> {
  final ShopifySheet _shopifySheet = ShopifySheet();

  @override
  void initState() {
    super.initState();

    // Listen to checkout events
    _shopifySheet.checkoutEvents.listen((event) {
      switch (event.type) {
        case ShopifySheetEventType.completed:
          print("Checkout Completed");
          break;
        case ShopifySheetEventType.canceled:
          _shopifySheet.closeCheckout(); // close checkout programmatically
          print("Checkout Canceled");
          break;
        case ShopifySheetEventType.failed:
          print("Checkout Failed: ${event.error}");
          break;
        case ShopifySheetEventType.pixelEvent:
          print("Pixel Event: ${event.data}");
          break;
        case ShopifySheetEventType.unknown:
        default:
          print("Unknown Event");
      }
    });
  }

  void _launchCheckout() {
    _shopifySheet.launchCheckout(
      "https://your-shopify-store.myshopify.com/cart/c/valid-key"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopify Checkout Plugin")),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchCheckout,
          child: const Text("Launch Checkout"),
        ),
      ),
    );
  }
}
```

---

## **License**
This project is licensed under the MIT License. See the LICENSE file for details.



