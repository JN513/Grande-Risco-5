#ifndef __RISCO_5_H__
#define __RISCO_5_H__

#define NULL           0
#define MEM_SIZE       0x00008004
#define STACK_INIT     MEM_SIZE - 4
#define FRAME_POINTER  STACK_INIT

#define NOP_TIME       1 // 5 cycles
#define CLK_FREQ       50000000 // 50 MHz
#define MS_TO_CYCLES   50000 // 1MS
#define NUM_NOPS_TO_MS 50000 // 1MS
#define CPU_FREQ_HZ    (50000000)  // 50MHz
#define CPU_FREQ_MHZ   (50)        // 50MHz

typedef unsigned long long uint64_t;
typedef unsigned int       uint32_t;
typedef unsigned short     uint16_t;
typedef unsigned char      uint8_t;

typedef long long int64_t;
typedef int       int32_t;
typedef short     int16_t;
typedef char      int8_t;

typedef unsigned int size_t;

#define read_csr(reg) ({ unsigned long __tmp; \
    asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
    __tmp; })
  
#define write_csr(reg, val) ({ \
if (__builtin_constant_p(val) && (unsigned long)(val) < 32) \
    asm volatile ("csrw " #reg ", %0" :: "i"(val)); \
else \
    asm volatile ("csrw " #reg ", %0" :: "r"(val)); })


void *memset (void *dest, int val, size_t len);

void *memcpy (void *out, const void *in, size_t length);

int strlen(const char *str);

char *strcpy(char *destination, const char *source);

int strcmp(const char *str1, const char *str2);

char *strcat(char *destination, const char *source);

char *strncpy(char *destination, const char *source, size_t n);

void delay_ms(int time);

uint32_t get_cycle_value();

void busy_wait(uint32_t ms);

#endif // __RISCO_5_H__