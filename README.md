# mercury-cross-android

This is a script that should build functioning Mercury
cross-compilers for Android using the hlc.gc grade.

This process is currently __experimental__.  I have not 
yet ported the test suite, but I have run statically linked executables with 
`qemu-arm`. 

Requires:
- The Android NDK (tested with android-ndk-r20b)
- A recent-enough version of the Mercury compiler for
  the selected ROTD.

Usage:


Notes:
- The distribution is non-relocatable
- The distribution depends on your existing Mercury install
- You should _not_ add the cross-compiler `bin` directory to your PATH;
  call the program directly instead (eg., `/path/to/mmc --make hello`)

LICENSE: MIT

