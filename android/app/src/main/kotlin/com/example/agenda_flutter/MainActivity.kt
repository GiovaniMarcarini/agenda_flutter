package com.example.agenda_flutter

import android.Manifest
import android.content.pm.PackageManager
import android.provider.ContactsContract
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.agenda/contacts"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getContacts") {
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_CONTACTS), 1)
                    result.error("PERMISSION_DENIED", "Permission to access contacts denied", null)
                } else {
                    val contacts = getContacts()
                    result.success(contacts)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getContacts(): List<Map<String, String>> {
        val contacts = mutableListOf<Map<String, String>>()
        val contentResolver = contentResolver
        val cursor = contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            null,
            null,
            null,
            null
        )
        cursor?.use {
            while (it.moveToNext()) {
                val name = it.getString(it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)) ?: "Sem Nome"
                val phone = it.getString(it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)) ?: "Sem Telefone"
                contacts.add(mapOf("name" to name, "phone" to phone))
            }
        }
        return contacts
    }
}

