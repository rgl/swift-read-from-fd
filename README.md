Bash or Zsh lets us create temporary memory file descriptors and pass them as path to another application. Something like:

```bash
ls -laF <(cat main.swift)
```

Which outputs something like:

```
prw-rw----  0 admin  staff  163 Jun 12 11:36 /dev/fd/11|
```

But, when [trying to read that file from swift application](main.swift) like:

```bash
swift main.swift <(cat main.swift)
```

It fails with:

```
Reading file:///dev/fd/11...
Swift/ErrorType.swift:200: Fatal error: Error raised at top level: Error Domain=NSCocoaErrorDomain Code=257 "The file “11” couldn’t be opened because you don’t have permission to view it." UserInfo={NSFilePath=/dev/fd/11, NSUnderlyingError=0x60000397e040 {Error Domain=NSPOSIXErrorDomain Code=13 "Permission denied"}}
Stack dump:
0.	Program arguments: /Applications/Xcode-14.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -interpret main.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -stack-check -sdk /Applications/Xcode-14.3.0.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk -color-diagnostics -new-driver-path /Applications/Xcode-14.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-driver -empty-abi-descriptor -resource-dir /Applications/Xcode-14.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -module-name main -disable-clang-spi -target-sdk-version 13.3 -target-sdk-name macosx13.3 -- /dev/fd/11
1.	Apple Swift version 5.8 (swiftlang-5.8.0.124.2 clang-1403.0.22.11.100)
2.	Compiling with the current language version
3.	While running user code "main.swift"
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x000000010593b300 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x000000010593a2e4 llvm::sys::RunSignalHandlers() + 112
2  swift-frontend           0x000000010593b910 SignalHandler(int) + 344
3  libsystem_platform.dylib 0x0000000194ccea84 _sigtramp + 56
4  libswiftCore.dylib       0x00000001a39c7d0c $ss17_assertionFailure__4file4line5flagss5NeverOs12StaticStringV_SSAHSus6UInt32VtF + 268
5  libswiftCore.dylib       0x00000001a3a5f610 $ss5ErrorPsSYRzs17FixedWidthInteger8RawValueSYRpzrlE5_codeSivg + 0
6  libswiftCore.dylib       0x000000010c7a8278 $ss5ErrorPsSYRzs17FixedWidthInteger8RawValueSYRpzrlE5_codeSivg + 18446744071173344360
7  swift-frontend           0x000000010090fbe8 llvm::orc::runAsMain(int (*)(int, char**), llvm::ArrayRef<std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > >, llvm::Optional<llvm::StringRef>) + 1336
8  swift-frontend           0x0000000100872924 swift::RunImmediately(swift::CompilerInstance&, std::__1::vector<std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >, std::__1::allocator<std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > > > const&, swift::IRGenOptions const&, swift::SILOptions const&, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> >&&) + 10816
9  swift-frontend           0x000000010082ecac processCommandLineAndRunImmediately(swift::CompilerInstance&, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> >&&, llvm::PointerUnion<swift::ModuleDecl*, swift::SourceFile*>, swift::FrontendObserver*, int&) + 492
10 swift-frontend           0x000000010082971c performCompileStepsPostSILGen(swift::CompilerInstance&, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> >, llvm::PointerUnion<swift::ModuleDecl*, swift::SourceFile*>, swift::PrimarySpecificPaths const&, int&, swift::FrontendObserver*) + 1552
11 swift-frontend           0x000000010082cab8 performCompile(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 3288
12 swift-frontend           0x000000010082a944 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 4308
13 swift-frontend           0x00000001007ef68c swift::mainEntry(int, char const**) + 4116
14 dyld                     0x0000000194947f28 start + 2236
zsh: trace trap  swift main.swift <(cat main.swift)
```

Why?
