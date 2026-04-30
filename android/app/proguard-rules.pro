-keep class com.dexterous.** { *; }
-keepclassmembers class com.dexterous.** { *; }

# Gson TypeToken — flutter_local_notifications использует анонимный TypeToken
# для десериализации запланированных уведомлений из SharedPreferences.
# Без этих правил R8 обфусцирует TypeToken и ломает getSuperclassTypeParameter.
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod
