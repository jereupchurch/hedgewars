# Introduction #

This guide is not targeted to hedgewars currently but meant to help you set up the environment to get emscripten working.

# Set Up emscripten #

You can follow the steps here to set up emscripten: https://github.com/kripken/emscripten/wiki/Tutorial

Be sure to set up the correct path in ~/.emscripten. The default paths are mostly not suitable for you.

Building llvm 3.0 from source has one big advantage since you can point the LLVM\_ROOT to where you build it, which won't affect your local version (if it is not 3.0).

# Potential problems #

  1. Make sure your node.js is the latest version, earlier versions won't work for some reasons;
  1. Make sure the version of your llvm and clang is exactly 3.0. Lower versions won't compile and higher versions may fail in some cases due to the removal of llvm-ld. For Ubuntu users, 11.10 doesn't have pre-built llvm 3.0 packages so you have to build from source files. I haven't tried llvm 3.1 (which should work in theory), but to make it less troublesome, llvm 3.0 is recommended.

# How to get llvm and clang 3.0 #

If you can checkout through svn, follow the official guide (checkout release\_30 branch):

http://llvm.org/docs/GettingStarted.htm

If you cannot checkout through svn for some network issues, you can find git mirrors in github here (which should work for everyone):

https://github.com/llvm-mirror/llvm (checkout release\_30 branch)

https://github.com/llvm-mirror/clang (checkout release\_30 branch)

https://github.com/llvm-mirror/compiler-rt (checkout release\_30 branch)

Follow the official guide to build from source code (http://llvm.org/docs/GettingStarted.html).

# Some tests #

There are a lot of tests in the tests folder. You can refer to (https://github.com/kripken/emscripten/wiki/Tutorial) for more details.

Here I just give some simple examples.

(Assume that you are in the emscripten root directory, where you can see the 'emcc' file)

1. **Hello World**

```
./emcc tests/hello_world.cpp
node a.out.js
```

You should be able to see "hello world!" in the terminal

If you want to have it run in browsers, you can type this (as in official tutorial):
```
./emcc tests/hello_world.cpp -o hello.html
```

2. **Get the glgears to work in browsers**
```
./emcc tests/hello_world_gles.c -o hello_world_gles.html
```

llvm 3.2+ won't compile this demo. The reason is that this demo uses malloc which has to been compiled first from dlmalloc. However emscripten uses llvm-ld as the linker, which has been removed in llvm 3.2+, and the result is that you will encounter some strange error messages saying that "no such file or directory". If you get this message, check your llvm and clang version.

3. **Get the file system to work**

```
./emcc --preload-file hello_world_file.txt tests/hello_world_file.c -o hello_world_file.html
```

Note that you must add "--preload-file hello\_world\_file.txt" in the command line. This line tells emcc that it should embed the file loading code into the js file. Before the application runs, all files will be loaded first. If you don't do this, it won't find this file.