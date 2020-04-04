# mercury-cross-android

This is a script that should build functioning Mercury
cross-compilers for Android using the hlc.gc grade.

This process is currently __experimental__.  I have not 
yet ported the test suite, but I have managed to run executables.

Requires:
- The Android NDK (tested with android-ndk-r20b)
- A recent-enough version of the Mercury compiler for
  the selected ROTD on your PATH.
- `tar` / `wget`

## Usage:

The script will
- Download the appropriate ROTD
- Compile the selected ABIs.

To run the script, the following variables need to be set correctly (default values are shown).

```sh
NDK=/opt/android-ndk-r20b \
HOST_TAG=linux-x86_64 \
ANDROID_SDK=21 \
MERCURYHOME=/usr/local/mercury-DEV \
PREFIX=/opt/android/cross/mercury \
ROTD=2020-03-29 \
ABIS="armv7a-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android" \
sh ./mercury-cross-android.sh
```

To use the compiler (do not add to PATH):

```sh
/path/to/mercury-cross/bin/mmc --cflag -fPIC --cflag -fPIE --make hello
```

To push an executable to Android and run:

```sh
adb push hello /data/local/tmp
adb shell
cd /data/local/tmp
chmod 0755 hello
./hello
```

### Note: Unused DT Entry

Until Android Marshmallow, the linker would output warnings about unused DT entries:

```
WARNING: linker: ./hello: unused DT entry: type ...
```

In many cases, these can be safely ignored.

If warnings are causing issues, you could use an ELF cleaner (such as the one 
[here](https://github.com/termux/termux-elf-cleaner)). In some cases, static linking
may also be acceptable. 

## Notes:
- The distribution is non-relocatable
- This requires a newer version of Mercury (otherwise, there will be an error parsing
  Clang version in the config files)
- The distribution depends on your existing Mercury install
- You should _not_ add the cross-compiler `bin` directory to your PATH;
  call the program directly instead (eg., `/path/to/cross/mmc --make hello`)


