import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val rootEnv = Properties().apply {
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) {
        envFile.inputStream().use { load(it) }
    }
}

fun readConfigKey(name: String, fallback: String): String {
    return (project.findProperty(name) as String?)
        ?: System.getenv(name)
        ?: rootEnv.getProperty(name)
        ?: fallback
}

android {
    namespace = "com.crimemaps.crime_maps"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.crimemaps.crime_maps"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true

        // Read API keys from Gradle properties, env vars, or gitignored root .env (zero hardcoded secrets)
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] =
            readConfigKey("GOOGLE_MAPS_API_KEY", "REPLACE_WITH_GOOGLE_MAPS_API_KEY")
        manifestPlaceholders["ADMOB_ANDROID_APP_ID"] =
            readConfigKey("ADMOB_ANDROID_APP_ID", "ca-app-pub-3940256099942544~3347511713")
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
