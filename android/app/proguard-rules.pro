# --- VdoCipher SDK required rules ---
-keep class com.vdocipher.** { *; }
-dontwarn com.vdocipher.**

# --- ExoPlayer (Media3) classes ---
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# --- Firebase / Google dependencies ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- General Flutter / Android rules ---
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**
