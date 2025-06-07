# micro-BASIC 
Micro BASIC is a simple interpreter for the micro BASIC programming language,for x86 PC`s written in NASM.

## Compilation
Windows: run BUILD.BAT
Linux: bash BUILD.sh

![screenshot](https://github.com/PRoX2011/micro-BASIC/raw/main/screenshot.png)
## Usage
- REM - Comment
- LET - Assign a value to a variable
- GOTO - Jump to a specified line number
- GOSUB - Call a subroutine
- END - Terminate a program
- PRINT - Print a value to the screen
- LIST - Display the program code
- RUN - Run a program
- INPUT - Get input from the user
- IF - Condition (If...)
- THEN - continuation for IF (If... Then...)
- RESET - Restart the program
- RETURN - Return from a subroutine
All commands must be followed by a line number or appropriate syntax.

Hello, world on the micro BASIC:
```BASIC
10 PRINT "Hello, world!"
20 END
RUN
```

## Limitations
- The project is designed for 16-bit systems and operates in real mode.
- Only integer numbers are supported.
- In variable names you can only use letters from A to Z
- Program size is limited by available memory.
