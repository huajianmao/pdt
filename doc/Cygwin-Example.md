# Cygwin Program Example

1. Write the program `helloworld.c`
  ``` C
  #include <stdio.h>
  int main(void) {
    printf("Hello World!");
  }
  ```

2. Compile `helloworld.c`
  ``` shell
  gcc -o hello helloworld.c
  ```
  It will generate a file named with `hello.exe` in the working directory.

3. Copy `cygwin1.dll` from `$CYGWIN_HOME/bin` and the generated `hello.exe` to some directory (`E:\\WDT`).

4. Run `hello.exe` in the Windows environment, for example, with command line (`cd E:\\WDT; hello.exe`). It will print out
  ```
  Hello World!
  ```

# NOTE
1. If `cygwin1.dll` is not put in the working directory, an error of `cygwin1.dll is not found` will occur! So put `cygwin1.dll `in the working directory please!
