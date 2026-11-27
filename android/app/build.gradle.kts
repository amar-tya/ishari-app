import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    // use {} closes the stream; the Gradle daemon would otherwise keep the file locked.
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

// Local testing only: lets a release build be signed with the debug key when
// key.properties is absent. Pass -PallowDebugSigning, or set the env var
// ORG_GRADLE_PROJECT_allowDebugSigning=true for `flutter build`. Never set it in CI.
val allowDebugSigning = providers.gradleProperty("allowDebugSigning")
    .map { it.isEmpty() || it == "true" }
    .getOrElse(false)

// Read AdMob App ID from env/current.env for manifest placeholder injection
val envFile = rootProject.file("../env/current.env")
val envProps = Properties()
if (envFile.exists()) {
    envProps.load(envFile.inputStream())
}

android {
    namespace = "com.ishari.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.ishari.app"
        // flutter_secure_storage requires minSdk 18+
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Inject AdMob App ID from env/current.env (fallback to test ID)
        manifestPlaceholders["admobAppId"] = envProps.getProperty(
            "ADMOB_APP_ID",
            "ca-app-pub-3940256099942544~3347511713",
        )
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = when {
                keystorePropertiesFile.exists() -> signingConfigs.getByName("release")
                allowDebugSigning -> signingConfigs.getByName("debug")
                // No fallback: verifyReleaseSigning below stops the build.
                else -> null
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

// Checked when a release build runs, not at configuration time, so debug and
// profile builds and IDE sync work without key.properties.
val releaseSigningReady = keystorePropertiesFile.exists() || allowDebugSigning
val verifyReleaseSigning = tasks.register("verifyReleaseSigning") {
    val ready = releaseSigningReady
    doLast {
        if (!ready) {
            throw GradleException(
                "Release signing is not configured: android/key.properties is missing.\n" +
                    "Add android/key.properties with your upload keystore, or, for local " +
                    "testing only, sign with the debug key: pass -PallowDebugSigning to " +
                    "Gradle or set ORG_GRADLE_PROJECT_allowDebugSigning=true. " +
                    "A debug-signed build must never be distributed.",
            )
        }
    }
}
tasks.matching { it.name == "preReleaseBuild" }.configureEach {
    dependsOn(verifyReleaseSigning)
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
