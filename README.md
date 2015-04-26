bflua
=====

## What's this?

This is Brainfuck interpreter and compiler.

## Usage

`cat <Brainfuck script> | lua bf.lua [options]`

### Options

- `-e` ... Run Brainfuck script in interpreter.
- `-c lua` ... Compile Brainfuck script to Lua script.
- `-c c` ... Compile Brainfuck script to C programming language.

## Performance

Run `./test.sh` to check performance.

Below is the result that I ran in my machine.
MacBook Air 11-inch, Mid 2011
1.6 GHz Intel Core i5
4 GB 1333 MHz DDR3

```
Lua 5.2.3  Copyright (C) 1994-2013 Lua.org, PUC-Rio
LuaJIT 2.0.3 -- Copyright (C) 2005-2014 Mike Pall. http://luajit.org/
Configured with: --prefix=/Library/Developer/CommandLineTools/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
Apple LLVM version 6.0 (clang-600.0.57) (based on LLVM 3.5svn)
Target: x86_64-apple-darwin13.4.0
Thread model: posix

interpreter(lua)
     5029.48 real      5018.73 user         3.96 sys
interpreter(luajit)
      116.50 real       116.20 user         0.12 sys
compiled(lua)

real	3m45.132s
user	3m43.263s
sys	0m0.470s
compiled(luajit)

real	0m17.295s
user	0m17.227s
sys	0m0.049s
compiled(C)

real	0m28.104s
user	0m28.031s
sys	0m0.028s
compiled(C opt)

real	0m2.078s
user	0m2.067s
sys	0m0.005s
```
