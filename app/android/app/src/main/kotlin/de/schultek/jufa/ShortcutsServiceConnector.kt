package de.schultek.jufa

import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class ShortcutsServiceConnector : MethodCallHandler {

    private var activity: FlutterActivity

    private var channel: MethodChannel

    constructor(activity: FlutterActivity, flutterEngine: FlutterEngine) {
        this.activity = activity
        this.channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "de.schultek.jufa.shortcuts");
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "pinShortcut" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val sM: ShortcutManager = activity.getSystemService(ShortcutManager::class.java)

                    val id = call.argument<String>("id")
                    val name = call.argument<String>("name")!!
                    val iconData = call.argument<ByteArray>("iconData")!!

                    val intent = Intent(activity, MainActivity::class.java)
                    intent.data = Uri.parse("jufa://shortcut?id=${id}")
                    intent.action = "de.schultek.jufa.action.LAUNCH"

                    val options: BitmapFactory.Options = BitmapFactory.Options()
                    val bitmap = BitmapFactory.decodeByteArray(iconData, 0, iconData.size, options)

                    val shortcut: ShortcutInfo = ShortcutInfo.Builder(activity, id)
                            .setIntent(intent)
                            .setShortLabel(name)
                            .setLongLabel(name)
                            .setIcon(Icon.createWithBitmap(bitmap))
                            .build()

                    activity.runOnUiThread {
                        sM.requestPinShortcut(shortcut, null)
                    }
                } else {
                    result.error("-1", "Not supported on current android version", null)
                }
            }
            "isLaunchedFromShortcut" -> {
                return if (activity.intent?.action?.equals("de.schultek.jufa.action.LAUNCH") == true) {
                    result.success(activity.intent?.data?.toString() ?: "")
                } else {
                    result.success(null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    fun onNewIntent(intent: Intent) {
        if (intent.action.equals("de.schultek.jufa.action.LAUNCH")) {
            channel.invokeMethod("shortcutLaunched", intent.data?.toString())
        }
    }
}
