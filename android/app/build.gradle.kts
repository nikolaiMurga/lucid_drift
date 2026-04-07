plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nicolaimurga.lucid_drift"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 1. Включаем десугаризацию
        isCoreLibraryDesugaringEnabled = true

        // 2. Для максимальной совместимости с Flutter 3.0 используем Java 1.8
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        // 2. И здесь тоже 1.8
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.nicolaimurga.lucid_drift"
        minSdk = flutter.minSdkVersion // Убедись, что minSdk не ниже 21 для корректной работы десугаризации
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 3. Добавляем саму библиотеку десугаризации
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
