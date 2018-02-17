# Opens Android SDK Manager
android_sdk(){
  $ANDROID_HOME/tools/android.bat &
}

android_dev(){
  echo "Starting Android emulator..."
  emulator -avd Nexus5-6.0 &
  sleep 30
  echo "Running application on emulator with live reload..."
  tns run android
}
