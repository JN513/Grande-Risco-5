#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_LEN 100

// Letras A-Z
const char* ascii_letters[26][5] = {
    { "  A  ", " A A ", "AAAAA", "A   A", "A   A" }, // A
    { "BBBB ", "B   B", "BBBB ", "B   B", "BBBB " }, // B
    { " CCC ", "C   C", "C    ", "C   C", " CCC " }, // C
    { "DDD  ", "D  D ", "D   D", "D  D ", "DDD  " }, // D
    { "EEEEE", "E    ", "EEE  ", "E    ", "EEEEE" }, // E
    { "FFFFF", "F    ", "FFFF ", "F    ", "F    " }, // F
    { " GGG ", "G    ", "G  GG", "G   G", " GGG " }, // G
    { "H   H", "H   H", "HHHHH", "H   H", "H   H" }, // H
    { " III ", "  I  ", "  I  ", "  I  ", " III " }, // I
    { "  JJJ", "   J ", "   J ", "J  J ", " JJ  " }, // J
    { "K  K ", "K K  ", "KK   ", "K K  ", "K  K " }, // K
    { "L    ", "L    ", "L    ", "L    ", "LLLLL" }, // L
    { "M   M", "MM MM", "M M M", "M   M", "M   M" }, // M
    { "N   N", "NN  N", "N N N", "N  NN", "N   N" }, // N
    { " OOO ", "O   O", "O   O", "O   O", " OOO " }, // O
    { "PPPP ", "P   P", "PPPP ", "P    ", "P    " }, // P
    { " QQQ ", "Q   Q", "Q Q Q", "Q  Q ", " QQ Q" }, // Q
    { "RRRR ", "R   R", "RRRR ", "R R  ", "R  RR" }, // R
    { " SSS ", "S    ", " SSS ", "    S", " SSS " }, // S
    { "TTTTT", "  T  ", "  T  ", "  T  ", "  T  " }, // T
    { "U   U", "U   U", "U   U", "U   U", " UUU " }, // U
    { "V   V", "V   V", "V   V", " V V ", "  V  " }, // V
    { "W   W", "W   W", "W W W", "WW WW", "W   W" }, // W
    { "X   X", " X X ", "  X  ", " X X ", "X   X" }, // X
    { "Y   Y", " Y Y ", "  Y  ", "  Y  ", "  Y  " }, // Y
    { "ZZZZZ", "   Z ", "  Z  ", " Z   ", "ZZZZZ" }  // Z
};

// Números 0–9
const char* ascii_numbers[10][5] = {
    { " 000 ", "0   0", "0   0", "0   0", " 000 " }, // 0
    { "  1  ", " 11  ", "  1  ", "  1  ", " 111 " }, // 1
    { " 222 ", "2   2", "   2 ", "  2  ", "22222" }, // 2
    { " 333 ", "    3", " 333 ", "    3", " 333 " }, // 3
    { "4  4 ", "4  4 ", "44444", "   4 ", "   4 " }, // 4
    { "55555", "5    ", "5555 ", "    5", "5555 " }, // 5
    { " 666 ", "6    ", "6666 ", "6   6", " 666 " }, // 6
    { "77777", "    7", "   7 ", "  7  ", " 7   " }, // 7
    { " 888 ", "8   8", " 888 ", "8   8", " 888 " }, // 8
    { " 999 ", "9   9", " 9999", "    9", " 999 " }  // 9
};

// Símbolos pontuais
const char* ascii_symbols[][6] = {
    { "!", "  !  ", "  !  ", "  !  ", "     ", "  !  " },
    { "?", " ??? ", "?   ?", "  ?? ", "     ", "  ?  " },
    { ".", "     ", "     ", "     ", "     ", "  .  " },
    { "-", "     ", "     ", "-----", "     ", "     " },
    { ":", "     ", "  :  ", "     ", "  :  ", "     " }
};

void print_ascii_art(const char* input) {
    char line[5][MAX_LEN] = { "" };

    for (size_t i = 0; i < strlen(input); ++i) {
        char c = input[i];

        if (isalpha(c)) {
            int idx = toupper(c) - 'A';
            for (int j = 0; j < 5; ++j) {
                strcat(line[j], ascii_letters[idx][j]);
                strcat(line[j], "  ");
            }
        } else if (isdigit(c)) {
            int idx = c - '0';
            for (int j = 0; j < 5; ++j) {
                strcat(line[j], ascii_numbers[idx][j]);
                strcat(line[j], "  ");
            }
        } else if (c == ' ') {
            for (int j = 0; j < 5; ++j) {
                strcat(line[j], "     "); // espaço de 5 colunas
                strcat(line[j], "  ");
            }
        } else {
            for (int s = 0; s < sizeof(ascii_symbols) / sizeof(ascii_symbols[0]); ++s) {
                if (c == ascii_symbols[s][0][0]) {
                    for (int j = 0; j < 5; ++j) {
                        strcat(line[j], ascii_symbols[s][j + 1]);
                        strcat(line[j], "  ");
                    }
                    break;
                }
            }
        }
    }

    // Imprime as linhas finais com \n
    for (int j = 0; j < 5; ++j)
        printf("%s\n", line[j]);
}

int main() {
    char input[MAX_LEN];
    printf("Digite uma string (letras, números e !?:.-): ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = 0; // Remove newline
    print_ascii_art(input);
    return 0;
}
