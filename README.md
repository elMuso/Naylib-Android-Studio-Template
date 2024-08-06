# Naylib Android Project Template

This repository is a simple example as to how Naylib (Raylib + Nim) can be configured for cross-platform development between android and desktop

This project aims to solve some problems with the [official](https://github.com/planetis-m/raylib-game-template) implementation, while borrowing some code from it

## Why this?

This template:
* Provides a simple way of building your .nim code to a shared android library
* Provides a android project already configured to use said librari(es)
* Uses Android Studio as a way of opening, running and debugging your project
* Provides a simple example as to how the game can be run on desktop

As a response to the original [raylib-game-template](https://github.com/planetis-m/raylib-game-template) which has this issues

- Creates a standalone apk and doesn't use android studio. Android libraries such as crashlytics, admob and firebase require android studio integration. This project serves as a starting point 
- Duplicates (repackages) the resources for both android and desktop. 
- Manages android icon-images, and package names instead of android studio. More documentation and customization can be found for android studio (like monochrome icons or translation files for application name)

## Warning
The issues that are solved by making the android project visible also increase the difficultie for setup. Which is hopefully a one time setup for a project. If you don't know much about Java, Kotlin, Gradlew, and Android Studio you might be better using the original game-template

# How to use
* Desktop: You can execute `main.nim` in your desktop as always. Just run `nim c -r main.nim` and it should just work
* Android: You need to BUILD your project to a shared library (.so). To do this you NEED to edit build_android.nimble and modify this chunk of code to match your environment. Some comments are provided for clarification

```.nimble
const
  #Must match the [compileSdk, targetSdk] version provided inside ./AndroidProject/app/build.gradle
  AndroidApiVersion = 34 
  #The actual architectures to compile. All by default
  AndroidCPUs = [arm, arm64, i386, amd64] 
  #The openGl version. 3.0 is not supported by 100% of android devices. And might be buggy on some devices
  #Check https://developer.android.com/develop/ui/views/graphics/opengl/about-opengl
  #Make sure you match the AndroidManifest.xml [android:glEsVersion] in ./AndroidProject/app/src/main/AndroidManifest.xml
  #2.0 by default
  AndroidGlEsVersion = openglEs20
  #A path towards your Java instalation (not your java/bin, your actual java folder)
  # JavaHome = "F:/java"
  #A path towards your NDK instalation (you can use command-line tools or android studio to download it in the sdkmanager)
  #NOTE: As of august 2024 the NDK27 is officially not supported by raylib (see https://github.com/raysan5/raylib/issues/4166)
  #Sugggested: Use the latest 26 version available
  AndroidNdk = "F:/AndroidSDK/ndk/26.3.11579264"
  # #A path towards your SDK folder (where platform-tools, platforms, cmake, etc is)
  # AndroidHome = "F:/AndroidSDK"
  # #A path towards your build-tools (usually inside androidSdk)
  # AndroidBuildTools = "F:/AndroidSDK/build-tools/34.0.0"
  #A path towards your platform-tools (usually inside androidSdk)
  AndroidPlatformTools = "F:/AndroidSDK/platform-tools"
  #Your starting point source file
  ProjectSourceFile = "src/raylib_game.nim"
```

* After that is done you can build the libraries with a simple command `nimble buildAndroid`. Then open the AndroidProject folder in android studio, wait for it to sync, and run.
