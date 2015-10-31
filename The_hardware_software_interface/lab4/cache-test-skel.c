/*
Coursera HW/SW Interface
Lab 4 - Mystery Caches

Mystery Cache Geometries (for you to keep notes):
mystery0:
    block size = 64 bytes
    cache size = 4096 bytes
    associativity = 32
mystery1:
    block size = 8 bytes
    cache size = 8192 bytes
    associativity = 8
mystery2:
    block size = 32 bytes
    cache size = 32768 bytes
    associativity = 2
mystery3:
    block size = 16 bytes
    cache size = 4096 bytes
    associativity = 1
*/

#include <stdlib.h>
#include <stdio.h>

#include "mystery-cache.h"

/*
 * NOTE: When using access_cache() you do not need to provide a "real"
 * memory addresses. You can use any convenient integer value as a
 * memory address, you should not be able to cause a segmentation
 * fault by providing a memory address out of your programs address
 * space as the argument to access_cache.
 */

/*
   Returns the size (in B) of each block in the cache.
*/
int get_block_size(void) {
  /* YOUR CODE GOES HERE */
  access_cache(0);
  if(access_cache(127))
    return 128;
  flush_cache();
  access_cache(0);
  if(access_cache(63))
    return 64;
  flush_cache();
  access_cache(0);
  if(access_cache(31))
    return 32;
  flush_cache();
  access_cache(0);
  if(access_cache(15))
    return 16;
  flush_cache();
  access_cache(0);
  if(access_cache(7))
    return 8;
  flush_cache();
  access_cache(0);
  if(access_cache(3))
    return 4;

  return -1;
  
  // alternative method
  // access_cache(0);
  // int i = 1;
  // while(access_cache(i) == TRUE)
  // 	i++;
  // return i;
}

/*
   Returns the size (in B) of the cache.
*/
int get_cache_size(int size) {
  /* YOUR CODE GOES HERE */
  int count = 1;
  while(1) {
    flush_cache();
    int i = 0;
    for(; i <= count; i++)
	access_cache(size * i);
    if(access_cache(0))
	count++;
    else
	break;
  }

  return size * count;

  // original code below doesn't work since the 0 was accessed many times
  // so it's no longer the least recently used element in the cache
  // flush_cache();
  // access_cache(0);
  // int count = 0;
  // while(access_cache(0)) {
  //   count++;
  //   access_cache(size * count);
  // }
  // return size * count;
}

/*
   Returns the associativity of the cache.
*/
int get_cache_assoc(int size) {
  /* YOUR CODE GOES HERE */
  // for a n-way set, to kick out the first element
  // you have to access the same set n times repeatedly
  int count = 1; // number of associativity
  while(1) {
    flush_cache();
    access_cache(0); // the first address to access
    int i = 1; // tentative associativity
    for(; i <= count; i++) { // always access the same set (set 0)
      access_cache(i * size);
    }
    if(access_cache(0)) // has more ways
	count++;
    else // the least recently used element has been kicked out
	break;
  }

  return count;
}

//// DO NOT CHANGE ANYTHING BELOW THIS POINT
int main(void) {
  int size;
  int assoc;
  int block_size;

  /* The cache needs to be initialized, but the parameters will be
     ignored by the mystery caches, as they are hard coded.  You can
     test your geometry paramter discovery routines by calling
     cache_init() w/ your own size and block size values. */
  cache_init(0,0);

  block_size=get_block_size();
  size=get_cache_size(block_size);
  assoc=get_cache_assoc(size);

  printf("Cache block size: %d bytes\n", block_size);
  printf("Cache size: %d bytes\n", size);
  printf("Cache associativity: %d\n", assoc);

  return EXIT_SUCCESS;
}
