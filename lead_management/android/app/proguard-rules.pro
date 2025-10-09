# Flutter/Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Firebase (if you use Firebase)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Gson (if you use it)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Retrofit/OkHttp (if used)
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Suppress warnings
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
