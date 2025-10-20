package com.example.zihin_bahcesi

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // LaunchTheme'den NormalTheme'e geçiş
        setTheme(R.style.NormalTheme)
    }
}
