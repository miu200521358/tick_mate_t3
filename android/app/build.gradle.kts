plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.2"
}

android {
    namespace = "com.miu200521358.tick_mate"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.miu200521358.tick_mate"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "TickMate Dev")
        }
        create("stg") {
            dimension = "environment"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "TickMate Stg")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "TickMate")
        }
    }

    // 各Flavorに対応するgoogle-services.jsonの設定
    sourceSets {
        getByName("dev") {
            assets.srcDir("src/dev/assets")
            res.srcDir("src/dev/res")
            resources.srcDir("src/dev")
        }
        getByName("stg") {
            assets.srcDir("src/stg/assets")
            res.srcDir("src/stg/res")
            resources.srcDir("src/stg")
        }
        getByName("prod") {
            assets.srcDir("src/prod/assets")
            res.srcDir("src/prod/res")
            resources.srcDir("src/prod")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))
    implementation("com.google.firebase:firebase-analytics")
}
