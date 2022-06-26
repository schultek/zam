package de.schultek.jufa

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.window.SplashScreenView
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import org.jetbrains.annotations.NotNull


class MainActivity: FlutterActivity() {
    private var shortcutsServiceConnector: ShortcutsServiceConnector? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        super.configureFlutterEngine(flutterEngine)

        shortcutsServiceConnector = ShortcutsServiceConnector(this, flutterEngine)
    }

    override fun cleanUpFlutterEngine(@NonNull @NotNull flutterEngine: FlutterEngine) {
        shortcutsServiceConnector?.dispose()
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        shortcutsServiceConnector?.onNewIntent(intent);
        super.onNewIntent(intent)
    }
}
