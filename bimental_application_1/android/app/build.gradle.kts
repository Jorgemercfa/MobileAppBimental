plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.1.0"  // Recomendado para Flutter 3.24
    // El plugin de Flutter SIEMPRE debe ir al final
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.bimental_application_1"
    compileSdk = flutter.compileSdkVersion

    // ⚠️ Recomendación: Poner esta versión compatible
    ndkVersion = "25.2.9519653"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.bimental_application_1"

        // ⚠️ Firebase recomienda mínimo 23, correcto
        minSdk = 23
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
