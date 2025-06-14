#include "risco5.h"

void *memset(void *dest, int val, size_t len) {
    unsigned char *ptr = (unsigned char *)dest;
    
    for (int i = 0; i < len; i++) {
        ptr[i] = (unsigned char)val;
    }

    return dest;
}

void *memcpy(void *out, const void *in, size_t length) {
    unsigned char *dst = (unsigned char *)out;
    const unsigned char *src = (const unsigned char *)in;

    // Copiamos os bytes um a um
    for (int i = 0; i < length; i++) {
        dst[i] = src[i];
    }

    return out;
}

int strlen(const char *str)
{
    char *inicial = (char *)str;

    while (*inicial != 0)
        inicial++;

    return (int)(inicial - str);
}

/*int strlen(const char *str){ // TODO: Checar compilador de riscv
    int i = 0;

    while(str[i] != '\0') i++;

    return i;
}*/

char *strcpy(char *destination, const char *source) {
    char *dest_ptr = destination;

    while (*source) {
        *dest_ptr++ = *source++;
    }
    *dest_ptr = '\0';

    return destination;
}

int strcmp(const char *str1, const char *str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }

    return (unsigned char)*str1 - (unsigned char)*str2;
}

char *strcat(char *destination, const char *source) {
    char *dest_ptr = destination;

    // Vai até o final da string destination
    while (*dest_ptr) {
        dest_ptr++;
    }

    // Copia a string source após o fim da destination
    while (*source) {
        *dest_ptr++ = *source++;
    }

    *dest_ptr = '\0'; // Terminador nulo

    return destination;
}

char *strncpy(char *destination, const char *source, size_t n) {
    size_t i = 0;

    // Copia até n caracteres ou até encontrar '\0'
    while (i < n && source[i] != '\0') {
        destination[i] = source[i];
        i++;
    }

    // Preenche o restante com '\0' se necessário
    while (i < n) {
        destination[i++] = '\0';
    }

    return destination;
}

uint32_t get_cpu_freq_mhz(){
    uint32_t freq = get_cpu_freq();
    return freq / 1000000; // Converte de Hz para MHz
}

void delay_s(uint32_t s){
    uint64_t tmp;
    uint64_t count;

    count = s * OS_TO_CYCLES;
    tmp = get_cycle_value();

    while (get_cycle_value() < (tmp + count));
}

void delay_ms(uint32_t ms){
    uint64_t tmp;
    uint64_t count;

    count = ms * MS_TO_CYCLES;
    tmp = get_cycle_value();

    while (get_cycle_value() < (tmp + count));
}

void delay_us(uint32_t us){
    uint64_t tmp;
    uint64_t count;

    count = us * US_TO_CYCLES;
    tmp = get_cycle_value();

    while (get_cycle_value() < (tmp + count));
}