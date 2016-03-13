# Parallel Data Transfer (PDT)

## Install Cygwin and apt-cyg
You may download cygwin from [official website](http://cygwin.com/setup-x86.exe). And install packages one by one in the GUI if you prefer.

However, a better way to install the dependencies packages is using [apt-cyg](../apt-cyg).
To use `apt-cyg`, we must install `wget`, `tar`, `gawk`, `xz` and `bzip2` manually.
Besides, to run the compiling script, we also need `git`, so install it too.


## Scripts for compiling
Run the following script in Cygwin, which will run the [`scripts/setup.sh`](scripts/setup.sh) to do the compiling work.
``` shell
git clone git@github.com:weinvent/pdt.git
cd pdt
sh scripts/setup.sh
```

# Compile with CLion
[JetBrains CLion](http://jetbrains.com/clion) is a great cross platform IDE for C/C++ IDE.
We could also use CLion to build and debug for WDT.

1. Install CLion
 - Set Cygwin, CMake, and GDB
  
2. Set cmake parameters in `File` -> `Settings` -> `Build, Execution, Deployment` -> `CMake` -> `CMake options`
 - ` -DBUILD_SHARED_LIBS=on -D CMAKE_INSTALL_PREFIX=C:\workspace\opt` where you want to install the package.

3. Open Project one by one
 - ***double-conversion*** `-DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=C:\workspace\opt` for cmake
 - ***gflags*** set environment variable `CXXFLAGS` to `-fPIC` and `-DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=C:\workspace\opt` for cmake
 - ***glog*** `-DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=C:\workspace\opt` for cmake
 - ***googletest*** `-DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=C:\workspace\opt` for cmake
 - ***wdt*** set environment variable `PATH` to `C:\workspace\opt\bin;C:\workspace\opt\lib;$PATH`, `-DBUILD_TESTING=1 -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=C:\workspace\opt` for cmake
 
4. Add `make install` in CMakeLists.txt
  ```
  add_custom_target(install_${PROJECT_NAME}
    make install
    DEPENDS ${PROJECT_NAME}
    COMMENT "Installing ${PROJECT_NAME}")
  ```
  Change `DEPENDS ${PROJECT_NAME}` if necessary.

5 . Copy all generated `*.dll.a` files in `C:\workspace\opt\lib` to `*.a`

# How to Use
***Receiver***:
``` shell
wdt.exe -directory /path/to/receiver/dir  -ipv4
```
***Sender***:
``` shell
wdt.exe -directory /path/to/sender/dir -connection_url "wdt://DESKTOP-OVBCDIB:55387?enc=2:a62c614a92d4fdcfe4a771d75f25774b&id=1589838237&num_ports=8&recpv=26"
```

# Test results with real data

***Environment***
Terminal 1: MacBook Pro with VM running Windowes Server 2012, 100M/1000M network Adapter
Terminal 2: Thinkpad S3 running Windows 10, with 100M/1000M network Adapter
Network Condition: No router, connected with cable directly.
Test Data: files of 64 Mbytes, 128 Mbytes, 256 MBytes, 512 Mbytes, etc. totally 4 GBytes.
***Tests and Results***
- Test 1: Windows 10 as Sender, Windows Server 2012 as Receiver, the throughtput is 59.6 Mbytes.
- Test 2: Windows 10 as Sender, MAC system as Receiver, the throughtput is 52.4 Mbytes.
- Test 3: MAC System as Sender, Windows 10 as Receiver, the throughtput is 76.6 Mbytes.
- Test 4: MAC System as Sender, Linux system as Receiver, the throughtput is 100.6 Mbytes.
- Test 5: Linux system as Sender, MAC system as Receiver, the throughtput is 66.45 Mbytes.
- Test 6: Linux system as Sender, Windows Server 2012 as Receiver, the throughtput is 62.8 Mbytes.
- Test 7: Windows Server 2012 as Sender, Linux system as Receiver, the throughtput is 48.0 Mbytes.

- Test 8: Thinkpad S3 and Surface Pro 3, 300 M wireless router, throughput 4.8 MBytes.


# Issues
 - [libglog_la-utilities Error on cygwin](https://github.com/google/glog/issues/44)
 - [expected initializer before 'Demangle'](https://github.com/google/glog/issues/52)
 - [Cygwin x86 and std::to_string](https://github.com/CleverRaven/Cataclysm-DDA/issues/13286)
 - `C:/cygwin64/home/USER/workspace/pdt.build/wdt/build.dir/_bin/wdt/protocol_test.exe: error while loading shared libraries: cygwdt_min.dll: cannot open shared object file: No such file or directory`
   * This can be solved by add `$INSTALL_PREFIX/lib` and `$INSTALL_PREFIX/bin` to `$PATH`

# Failed Test Cases
 - [WdtLockFailFast](https://github.com/facebook/wdt/blob/master/test/wdt_lock_failfast.sh) @huajianmao
 - [WdtOverwriteTest](https://github.com/facebook/wdt/blob/master/test/wdt_overwrite_test.py) @huajianmao **Passed once**
 - [WdtBadServerTest](https://github.com/facebook/wdt/blob/master/test/wdt_bad_server_test.py) @cornmoon-blue
 - [WdtLongRunningTest](https://github.com/facebook/wdt/blob/master/test/wdt_long_running_test.py) @gfkdwr
 - [TransferLogLockTest](https://github.com/facebook/wdt/blob/master/test/transfer_log_lock_test.sh) @huajianmao

# References
 - [Building and Installing HHVM on Cygwin](https://github.com/facebook/hhvm/wiki/Building-and-Installing-HHVM-on-Cygwin)
 - [BUILD.md](https://github.com/facebook/wdt/blob/master/build/BUILD.md)
 - [travis_linux.sh](https://github.com/facebook/wdt/blob/master/build/travis_linux.sh)
 - [JIAsManual](./JIAsManual)
 - [folly_compile](./folly_compile)
 - [mac_wt](./mac_wt)

