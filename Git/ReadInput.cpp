// #include's are directives to the compiler. They are essentially the equivalent
// of pasting in the contents of the listed file in this exact location.

// Files that are part of the C++ library use "<" and ">" to bookend the filename.
// Files that you create use double quotes to bookend the filename, for example #include "hello.h"

// The "h" extension is meant to indicate this is the interface of how these files will share data.
// The "cpp" extension is meant to indicate this is the source code behind the interface.

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

// EVERY c and c++ program must have a main.
int main(int argc, char** argv) {

    printf ("Reading a file into a character buffer.\n");

    // Verify that a file name is provided and that the file exists.
    // Use some new C++ stream features.
    if (argc <= 1) {
        printf ("Usage: readInput <filename>\n") ;
        return 1 ;
    }

    printf ("Opening file \"%s\".\n", argv[1]);

    // "*" indicates this is a pointer. See tutorial on pointers.
    FILE *in_fp ;
    in_fp = fopen(argv[1],"r") ;
    if ( in_fp==NULL ) {
        printf ("File \"%s\" not found.\n", argv[1]);
        return 2 ;
    }
    // Determine the size of the file, used to allocate the char buffer.
    // "&" means get the address of that variable so that you can pass-by-reference. See tutorial on pointers.
    struct stat filestatus;
    stat( argv[1], &filestatus );

    int filesize = filestatus.st_size + 1; // +1 for terminating null char

    // Allocate space for the character buffer.
    // Malloc is a means to dynamically allocate memory. It does this while the program is running.
    char *buffer = (char *) malloc( sizeof(char) * filesize ) ;

    int index = 0 ;
    char ch = getc(in_fp) ;

    while (ch != EOF) {
        buffer[index] = ch ;
        index ++ ;
        ch = getc(in_fp);
    }
    buffer[index] = '\0' ;

    return 0 ;
}
