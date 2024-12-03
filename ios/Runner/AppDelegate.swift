import UIKit
import Flutter
import Contacts

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.agenda/contacts",
                                       binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getContacts" {
        self.requestContactsAccess { granted in
          if granted {
            let contacts = self.getContacts()
            result(contacts)
          } else {
            result(FlutterError(code: "PERMISSION_DENIED", message: "Permission to access contacts denied", details: nil))
          }
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestContactsAccess(completion: @escaping (Bool) -> Void) {
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { granted, _ in
      completion(granted)
    }
  }

  private func getContacts() -> [[String: String]] {
    let store = CNContactStore()
    let keysToFetch = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    var contactsArray: [[String: String]] = []

    do {
      let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
      try store.enumerateContacts(with: fetchRequest) { contact, _ in
        let name = contact.givenName
        let phone = contact.phoneNumbers.first?.value.stringValue ?? "Sem Telefone"
        contactsArray.append(["name": name, "phone": phone])
      }
    } catch {
      print("Erro ao buscar contatos: \(error)")
    }
    return contactsArray
  }
}

