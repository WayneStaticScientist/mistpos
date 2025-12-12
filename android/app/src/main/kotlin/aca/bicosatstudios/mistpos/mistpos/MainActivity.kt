package aca.bicosatstudios.mistpos.mistpos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.security.ProviderInstaller
import com.google.android.gms.common.GoogleApiAvailability
import android.content.Intent
import android.net.Uri // Import for handling URI/URL

class MainActivity: FlutterActivity() {
    // Channel 1: Existing TLS Security Channel
    private val TLS_CHANNEL = "com.mistpos/ttls_security"
    
    // Channel 2: NEW URL Launcher Channel (Define a new, unique name)
    private val URL_CHANNEL = "com.mistpos/url_launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // --- EXISTING TLS SECURITY CHANNEL SETUP ---
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TLS_CHANNEL).setMethodCallHandler {
            call, result ->
            
            if (call.method == "installProvider") {
                installSecurityProvider(result)
            } else {
                result.notImplemented()
            }
        }

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

    // --- EXISTING TLS SECURITY METHOD ---
    private fun installSecurityProvider(result: MethodChannel.Result) {
        // ... (Your existing implementation for ProviderInstaller remains here) ...
        ProviderInstaller.installIfNeededAsync(this, object : ProviderInstaller.ProviderInstallListener {
            override fun onProviderInstalled() {
                result.success(true)
            }

            override fun onProviderInstallFailed(errorCode: Int, recoveryIntent: android.content.Intent?) {
                // You might need to use GoogleApiAvailability to show the user a dialog for recovery
                if (GoogleApiAvailability.getInstance().isUserResolvableError(errorCode)) {
                    // Start the recovery intent if available
                    if (recoveryIntent != null) {
                        // Use a request code if you want to handle the result later
                        startActivity(recoveryIntent) 
                        result.error("RECOVERABLE_ERROR", "Provider update failed, launching recovery screen.", null)
                    } else {
                        result.error("RECOVERABLE_ERROR", "Provider update failed, no recovery intent available.", null)
                    }
                } else {
                    result.error("FATAL_ERROR", "Provider update failed: $errorCode", null)
                }
            }
        })
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