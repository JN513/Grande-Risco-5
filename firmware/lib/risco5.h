#ifndef __RISCO_5_H__
#define __RISCO_5_H__

#define CSR_MHZFREQ 0xFC1 // CSR for CPU frequency in MHz
#define NULL           0
//#define MEM_SIZE       0x00004000 // 16384
//#define MEM_SIZE       0x00008000 // 32768
#define MEM_SIZE       0x00010000 // 65536
#define STACK_INIT     MEM_SIZE - 4
#define FRAME_POINTER  STACK_INIT

#define CLK_FREQ       100000000 // 100 MHz
#define OS_TO_CYCLES   100000000 // 1S // one second in cycles
#define MS_TO_CYCLES   100000 // 1MS
#define US_TO_CYCLES   100 // 1US
#define NS_TO_CYCLES   0.1 // 1NS, not used in delay functions, but defined for completeness
#define CPU_FREQ_HZ    (100000000)  // 50MHz
#define CPU_FREQ_MHZ   (100)        // 50MHz

typedef unsigned long long uint64_t;
typedef unsigned int       uint32_t;
typedef unsigned short     uint16_t;
typedef unsigned char      uint8_t;

typedef long long int64_t;
typedef int       int32_t;
typedef short     int16_t;
typedef char      int8_t;

typedef unsigned int size_t;
typedef unsigned int ee_size_t;

void *memset (void *dest, int val, size_t len);

void *memcpy (void *out, const void *in, size_t length);

int strlen(const char *str);

char *strcpy(char *destination, const char *source);

int strcmp(const char *str1, const char *str2);

char *strcat(char *destination, const char *source);

char *strncpy(char *destination, const char *source, size_t n);

uint32_t get_cpu_freq();

uint32_t get_cpu_freq_mhz();

uint64_t get_cycle_value();

void delay_s (uint32_t s);
void delay_ms(uint32_t ms);
void delay_us(uint32_t us);

int ee_printf(const char *fmt, ...);

#endif // __RISCO_5_H__