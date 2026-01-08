plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
}

android {
    namespace = "com.hogan.kang.storetest"
    compileSdk {
        version = release(36)
    }

    defaultConfig {
        applicationId = "com.hogan.kang.storetest"
        minSdk = 24
        targetSdk = 36
        
        // --- Version Config ---
        
        // VersionName: Fixed as requested
        versionName = "1.0.0"

        // VersionCode: Time-based
        // Note: Android versionCode is a 32-bit integer (max 2,147,483,647).
        // YYYYMMDDHHMMSS is too large, so we use Unix Timestamp (seconds since 1970).
        // This ensures the code increases with time and fits in the integer limit.
        versionCode = (System.currentTimeMillis() / 1000).toInt()
        
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    // No signingConfig configured for Release.
    // This ensures that the build output is strictly UNSIGNED.
    // Signing will be handled in a separate step/department.

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    buildFeatures {
        compose = true
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.graphics)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.compose.material3)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.compose.ui.test.junit4)
    debugImplementation(libs.androidx.compose.ui.tooling)
    debugImplementation(libs.androidx.compose.ui.test.manifest)
}