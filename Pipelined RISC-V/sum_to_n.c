#include <stdint.h>


__attribute__((noinline))
uint32_t sum_to_n(uint32_t n) {
    uint32_t sum = 0;
    for (uint32_t i = 1; i <= n; i = i + 1) {
        sum = sum + i;
    }
    return sum;
}

int __attribute__((section(".text.start"))) main() {
    uint32_t n = 100;  
    uint32_t result_out;
     
    result_out = sum_to_n(n);
       
    end:
    goto end; 
}
