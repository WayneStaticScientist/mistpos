package aca.bicosatstudios.mistpos.mistpos
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.security.ProviderInstaller
import com.google.android.gms.common.GoogleApiAvailability
import android.content.Intent

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mistpos/ttls_security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            
            if (call.method == "installProvider") {
                installSecurityProvider(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun installSecurityProvider(result: MethodChannel.Result) {
        ProviderInstaller.installIfNeededAsync(this, object : ProviderInstaller.ProviderInstallListener {
            override fun onProviderInstalled() {
                result.success(true)
            }

            override fun onProviderInstallFailed(errorCode: Int, recoveryIntent: android.content.Intent?) {
                // ... Error handling logic remains here ...
                result.error("FATAL_ERROR", "Provider update failed: $errorCode", null)
            }
        })
    }
}
