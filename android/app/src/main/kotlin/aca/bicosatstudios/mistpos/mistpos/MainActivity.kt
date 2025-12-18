package aca.bicosatstudios.mistpos.mistpos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.security.ProviderInstaller
import com.google.android.gms.common.GoogleApiAvailability
import android.content.Intent
import android.net.Uri // Import for handling URI/URL
import android.os.Build
import javax.net.ssl.*
import java.security.SecureRandom
import android.os.Bundle
import com.google.android.gms.security.ProviderInstaller.ProviderInstallListener
import android.util.Log
class MainActivity: FlutterActivity() {
    // Channel 1: Existing TLS Security Channel
    private val TLS_CHANNEL = "com.mistpos/ttls_security"
    
    // Channel 2: NEW URL Launcher Channel (Define a new, unique name)
    private val URL_CHANNEL = "com.mistpos/url_launcher"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (android.os.Build.VERSION.SDK_INT < 24) {
            ProviderInstaller.installIfNeededAsync(this, object : ProviderInstallListener {
                override fun onProviderInstalled() {
                    Log.d("SecurityProvider", "Google Play Services security provider installed.")
                }
                override fun onProviderInstallFailed(errorCode: Int, intent: android.content.Intent?) {
                    Log.e("SecurityProvider", "Google Play Services security provider update failed: $errorCode")
                    // Handle failure gracefully: if intent is not null, prompt user to update Google Play Services
                    if (intent != null) {
                         startActivity(intent)
                    }
                }
            })
        }
        // **CRITICAL:** Call the TLS enforcement for Android 5.0/5.1 devices (API 21/22)
        // and sometimes necessary for 6.0 (API 23)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP && Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            enableTLS12()
        }
        
        // You can still keep the MethodChannel logic if you prefer to call it from Dart,
        // but often doing it in onCreate (like the example below) is simpler and more reliable.

    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // --- NEW URL LAUNCHER CHANNEL SETUP ---
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, URL_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "launchUrl") {
                launchUrl(call.argument<String>("url"), result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun enableTLS12() {
        try {
            // Force TLSv1.2 context
            val sc = SSLContext.getInstance("TLSv1.2")
            sc.init(null, null, SecureRandom())
            
            // Set the default SSL Socket Factory
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.socketFactory)
            
            // Additionally, update the default hostname verifier if needed (optional, but good for compatibility)
            // val defaultHostnameVerifier = HttpsURLConnection.getDefaultHostnameVerifier()
            // HttpsURLConnection.setDefaultHostnameVerifier(defaultHostnameVerifier)

            System.out.println("Forced TLS 1.2 context on Android < 7.0")
        } catch (e: Exception) {
            System.err.println("Error forcing TLS 1.2 context: ${e.message}")
        }
    }
    // --- NEW URL LAUNCHER METHOD (Supports SDK 22) ---
    private fun launchUrl(url: String?, result: MethodChannel.Result) {
        if (url == null) {
            result.error("INVALID_URL", "URL argument is missing or null.", null)
            return
        }
        
        // This is the standard Android code to launch a URL, compatible with SDK 22 (Lollipop 5.1)
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        
        try {
            startActivity(intent)
            // Report success back to Dart
            result.success(null) 
        } catch (e: Exception) {
            // Report error back to Dart if no application can handle the intent (e.g., no browser)
            result.error("LAUNCH_FAILED", "Could not launch URL: ${e.message}", null)
        }
    }
}