pluginManagement {
    val flutterSdkPath =
        run {
            if (System.getenv("EAS_BUILD") == "true") {
                val flutterRoot = System.getenv("FLUTTER_ROOT")
                if (flutterRoot != null) return@run flutterRoot
            }

            val properties = java.util.Properties()
            val propertiesFile = file("local.properties")
            if (propertiesFile.exists()) {
                propertiesFile.inputStream().use { properties.load(it) }
            }

            val flutterSdk = properties.getProperty("flutter.sdk")
            if (flutterSdk != null) return@run flutterSdk

            val flutterRoot = System.getenv("FLUTTER_ROOT")
            if (flutterRoot != null) return@run flutterRoot

            val flutterHome = System.getenv("FLUTTER_HOME")
            if (flutterHome != null) return@run flutterHome

            throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file or with FLUTTER_ROOT environment variable.")
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
