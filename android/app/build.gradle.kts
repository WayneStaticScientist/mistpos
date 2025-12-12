import java.util.Properties
import java.io.FileInputStream
val localProperties = Properties()
localProperties.load(project.rootProject.file("local.properties").inputStream())

val signingProps = Properties()
val signingPropsFile = project.rootProject.file("key.properties")
if (signingPropsFile.exists()) {
    signingProps.load(FileInputStream(signingPropsFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") 
}
dependencies {
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.6.0")) // <-- Use 34.6.0 or the latest
  

  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")
  implementation("com.google.firebase:firebase-messaging")
  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "aca.bicosatstudios.mistpos.mistpos"
    compileSdk = 36
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
        applicationId = "aca.bicosatstudios.mistpos.mistpos"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdkVersion(localProperties.getProperty("flutter.minSdkVersion")?.toInt() ?: 21)
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
    
   signingConfigs {
        create("release") {
            // Accessing the properties using getProperty() is the safe Kotlin DSL way
            storeFile = file(signingProps.getProperty("storeFile"))
            storePassword = signingProps.getProperty("storePassword")
            keyAlias = signingProps.getProperty("keyAlias")
            keyPassword = signingProps.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            // Apply the newly created signing config
            signingConfig = signingConfigs.getByName("release")

            // Add your code shrinking/obfuscation rules here (recommended)
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

 
}

flutter {
    source = "../.."
}