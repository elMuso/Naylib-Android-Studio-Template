# raylib build script for Android project (APK building)
# Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
# Converted to nimscript by Antonis Geralis (@planetis-m) in 2023
# See the file "LICENSE", included in this distribution,
# for details about the copyright.

import std/[os]

# Don't delete the following code
type
  CpuPlatform = enum
    arm, arm64, i386, amd64
  GlEsVersion = enum
    openglEs20 = "GraphicsApiOpenGlEs2"
    openglEs30 = "GraphicsApiOpenGlEs3"

# Edit the following code
# Configure your compilation using this constant variables
# BEWARE: If your IDE autoformats this file it might stop working. So don't do it

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
  ProjectSourceFile = "main.nim"

# Don't delete the following code
# Code below is the actual compilation code. Don't touch unless you kwon what you are doing

proc toArchName(x: CpuPlatform): string =
  case x
  of arm: "armeabi-v7a"
  of arm64: "arm64-v8a"
  of i386: "x86"
  of amd64: "x86_64"


# Android project configuration variables
const
  #Name used for caching. Irrelevant what you set it to
  ProjectName = "raylib_game"
  #DO NOT CHANGE THIS. Unless you want to edit ./AndroidProject/app/src/main/java/com/raylibtemplate/NativeLoader.java to the same name
  ProjectLibraryName = "main" 
  #The folder where .so files will be built. Do not change this because you will need to update your jniLibs.srcDirs in build.gradle
  ProjectBuildPath = "jniLibs"

# mode = ScriptMode.Verbose

task buildAndroid, "Compile project code into a shared library for Android":
  # Compile project code into a shared library: lib/{AndroidArchName}/lib{ProjectLibraryName}.so
  # let androidResourcePath = AndroidHome / ("platforms/android-" & $AndroidApiVersion) / "android.jar"
  for cpu in AndroidCPUs:
    exec("nim c -d:release --os:android --cpu:" & $cpu & " -d:AndroidApiVersion=" & $AndroidApiVersion &
        " -d:AndroidNdk=" & AndroidNdk & " -d:" & $AndroidGlEsVersion &
        " -o:" & ProjectBuildPath / cpu.toArchName / ("lib" & ProjectLibraryName & ".so") &
        " --nimcache:" & nimcacheDir().parentDir / (ProjectName & "_" & $cpu) & " " & ProjectSourceFile)

task info, "Retrieve device compatibility information":
  # Check supported ABI for the device (armeabi-v7a, arm64-v8a, x86, x86_64)
  echo "Checking supported ABI for the device..."
  exec(AndroidPlatformTools / "adb shell getprop ro.product.cpu.abi")
  # Check supported API level for the device (31, 32, 33, ...)
  echo "Checking supported API level for the device..."
  exec(AndroidPlatformTools / "adb shell getprop ro.build.version.sdk")
