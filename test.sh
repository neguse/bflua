#!/usr/bin/env sh

lua -v
luajit -v
gcc -v

wget http://esoteric.sange.fi/brainfuck/utils/mandelbrot/mandelbrot.b

echo "interpreter(lua)"
cat mandelbrot.b | time lua bf.lua -e > /dev/null

echo "interpreter(luajit)"
cat mandelbrot.b | time luajit bf.lua -e > /dev/null

cat mandelbrot.b | lua bf.lua -c lua > mandelbrot.lua

echo "compiled(lua)"
time lua mandelbrot.lua > /dev/null

echo "compiled(luajit)"
time luajit mandelbrot.lua > /dev/null

cat mandelbrot.b | lua bf.lua -c c > mandelbrot.c

echo "compiled(C)"
gcc mandelbrot.c -o mandelbrot
time ./mandelbrot > /dev/null

echo "compiled(C opt)"
gcc mandelbrot.c -o mandelbrot_opt -O2
time ./mandelbrot_opt > /dev/null

