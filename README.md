Portable package for facebook/idb
=================================

[![Build Status](https://app.bitrise.io/app/716dfe49fc91b5ca/status.svg?token=5X0n7oS5A1V-gu9I2Thh_w&branch=master)](https://app.bitrise.io/app/716dfe49fc91b5ca)

This is a portable package builder for [facebook/idb](https://github.com/facebook/idb).

You can use prebuilt portable packages at the [releases](https://github.com/Kuniwak/idb-portable/releases).


Contents
--------

```console
$ tree -L 3 ./dist
./dist
├── Frameworks
│   ├── FBControlCore.framework
│   ├── FBDeviceControl.framework
│   ├── FBSimulatorControl.framework
│   └── XCTestBootstrap.framework
├── bin
│   └── idb_companion
├── lib
│   ├── libcares.2.dylib
│   ├── libcrypto.1.0.0.dylib
│   ├── libgrpc++.dylib
│   ├── libgrpc.dylib
│   ├── libprotobuf.18.dylib
│   └── libssl.1.0.0.dylib
└── shared
    ├── c-ares
    │   └── LICENSE
    ├── grpc
    │   └── LICENSE
    ├── idb_companion
    │   └── LICENSE
    ├── openssl
    │   └── LICENSE
    └── protobuf
        └── LICENSE

29 directories, 16 files
```


Usage
-----

```console
$ git clone git@github.com:Kuniwak/idb-portable
$ cd idb-portable

$ make
$ # if keychain dialog about "codesign" is present, allow it.
$ # because several binaries should be codesigned to
$ # suppress dialogs about network permissions.

$ make test
```

`codesign` in `make` use an identity matching the environment variable `CODESIGNING_IDENTITY`. If not specified, idb-portable search available identities and use one of these.


Verified Environments
---------------------

```console
$ sw_vers
ProductName:    Mac OS X
ProductVersion: 10.14.5
BuildVersion:   18F132

$ xcodebuild -version
Xcode 10.2.1
Build version 10E1001

$ brew --version
Homebrew 2.1.7-43-g203980a
Homebrew/homebrew-core (git revision e7942; last commit 2019-07-19)
Homebrew/homebrew-cask (git revision c78d75; last commit 2019-07-19)
```


License
-------

[MIT](/LICENSE)
