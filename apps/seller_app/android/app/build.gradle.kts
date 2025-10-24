plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val flutterVersionCode = (project.findProperty("flutter.versionCode") as String?) ?: "1"
val flutterVersionName = (project.findProperty("flutter.versionName") as String?) ?: "1.0"

android {
    namespace = "com.cravit.seller"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.cravit.seller"
        minSdk = flutter.minSdkVersion
        targetSdk = 34

        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName

        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.3.1"))
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
