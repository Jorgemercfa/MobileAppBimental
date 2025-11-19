import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.1.0"
    // El plugin de Flutter SIEMPRE va al final
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------------------------------------------------------
// 🔐 Cargar key.properties para firmar la app en RELEASE
// ---------------------------------------------------------
val keystoreProperties = Properties()
val keystoreFile = rootProject.file("key.properties")

if (keystoreFile.exists()) {
    keystoreProperties.load(FileInputStream(keystoreFile))
}

android {
    namespace = "com.example.bimental_application_1"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = "27.0.12077973"

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

    // ---------------------------------------------------------
    // 🔐 Configuración de firma
    // ---------------------------------------------------------
    signingConfigs {
    create("release") {
        val storeFilePath = keystoreProperties["storeFile"] as String?
        if (storeFilePath != null) {
            storeFile = file(storeFilePath)
        }

        keyAlias = keystoreProperties["keyAlias"] as String?
        keyPassword = keystoreProperties["keyPassword"] as String?
        storePassword = keystoreProperties["storePassword"] as String?
    }
}


    buildTypes {
        release {
            // Firma REAL para Google Play
            signingConfig = signingConfigs.getByName("release")

            // Desactivar shrink para evitar errores
            isMinifyEnabled = false
            isShrinkResources = false
        }

        debug {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
