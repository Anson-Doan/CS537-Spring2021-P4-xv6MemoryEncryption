//A Simple C program
#include "types.h"
#include "stat.h"
#include "user.h"
#include "mmu.h"

    
 //passing command line arguments
    
int main(int argc, char *argv[])
{
//   printf(1, "My first xv6 program learnt at GFG\n");


    char *ptr = sbrk(PGSIZE); // Allocate one page
    mencrypt(ptr, 1); // Encrypt the pages
    struct pt_entry pt_entry; 
    getpgtable(&pt_entry, 1); // Get the page table information for newly allocated page

  //exit();
}