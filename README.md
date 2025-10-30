# ios_app

A minimal **Flutter + Swift + C++** demo app

Flutter (Dart)
↓ MethodChannel(“com.example.ios_app/native_hello”)
Swift (AppDelegate)
↓ HelloWriterBridge (Objective-C++)
↓ HelloWriter (C++)
↓ File system (Documents/hello.txt)
↑ Returns updated file content
Flutter updates UI