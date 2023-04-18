#include <stdio.h>
#include "sharedLibExports.h"

__attribute__((visibility("default")))
void myLocalFunction1(void)
{
    printf("function1\n");
}

void myLocalFunction2(void)
{
    printf("function2\n");
}

void myLocalFunction3(void)
{
    printf("function3\n");
}

void printMessage(void)
{
    printf("Running the function exported from the shared library\n");
}
