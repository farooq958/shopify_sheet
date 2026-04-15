plugins {
    id("com.android.library")
}

val agpVersion: String = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION
if (agpVersion.split(".")[0].toInt() < 9) {
    apply(plugin = "kotlin-android")
}

android {
    namespace = "com.checkoutsheetshopify.shopify_sheet"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    dependencies {
        implementation("com.shopify:checkout-sheet-kit:3.5.4")
        implementation("androidx.appcompat:appcompat:1.7.1")
        implementation("androidx.activity:activity:1.13.0")
        implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.10.0")
        implementation("com.google.code.gson:gson:2.13.2")
        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.mockito:mockito-core:5.23.0")
    }

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()

            it.outputs.upToDateWhen { false }
            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
        }
    }
}
