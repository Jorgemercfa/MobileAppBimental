plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.1.0"  // Correcto y compatbile
    // El plugin de Flutter SIEMPRE va al final
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.bimental_application_1"
    compileSdk = flutter.compileSdkVersion

    // Versión estable recomendada
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
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Evita errores de shrinkResources/minify
            isMinifyEnabled = false
            isShrinkResources = false

            // Por ahora firma con debug (GitHub Actions lo permite)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
