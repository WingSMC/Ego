# Ego

```shell
# compile llvm IR to object file
llc -filetype=obj test.ll -o test.o
# link c code with object file
clang caller.c test.o -o prog
```