#include "conversion.h"


int is_space(char c) {
    return c == ' ' || c == '\n' || c == '\t' ||
           c == '\v' || c == '\f' || c == '\r';
}

int is_digit(char c) {
    return c >= '0' && c <= '9';
}

int atoi(const char *str) {
    int result = 0;
    int sign = 1;
    int i = 0;

    // Ignora espaços em branco
    while (is_space(str[i])) {
        i++;
    }

    // Lida com sinal
    if (str[i] == '-') {
        sign = -1;
        i++;
    } else if (*str == '+') {
        i++;
    }

    // Converte caracteres numéricos
    while (is_digit(str[i])) {
        result = result * 10 + (str[i] - '0');
        i++;
    }

    return sign * result;
}


char *itoa(int value, char *str, int base) {
    int is_negative = 0;

    if (base < 2 || base > 36) {
        str[0] = '\0';
        return str;
    }

    // Trata negativos apenas na base 10
    if (value < 0 && base == 10) {
        is_negative = 1;
        value = -value;
    }

    // Conversão
    int i = 0;

    while(value) {
        int digit = value % base;
        
        value /= base;

        if (digit < 10)
            str[i] = '0' + digit;
        else
            str[i] = 'a' + (digit - 10);
        
        i++;
    }

    if (is_negative){
        str[i] = '-';
        i++;
    }

    str[i] = '\0'; // Finaliza a string

    // Inverte a string
    for (int j = 0; j < i/2; j++) {
        char temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }

    return str;
}
