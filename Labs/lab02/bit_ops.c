#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    long comparison = 1;
    comparison = comparison << n;
    long ret = comparison & x;
    return ret >> n;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    /*创建掩码111..101..111，用于将该位清零*/
    unsigned mask = ~(1u << n);
    *x = *x & mask;
    /*将v左移，进行对齐 */
    unsigned bit = v << n;
    *x = *x | bit;
}

// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    unsigned value = get_bit(*x, n);
    value = 1 - value;
    set_bit(x, n, value);
}

