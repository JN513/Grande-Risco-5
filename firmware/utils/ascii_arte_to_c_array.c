#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_LEN 500

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

const char* ascii_symbols[][6] = {
    { "!", "  !  ", "  !  ", "  !  ", "     ", "  !  " },
    { "?", " ??? ", "?   ?", "  ?? ", "     ", "  ?  " },
    { ".", "     ", "     ", "     ", "     ", "  .  " },
    { "-", "     ", "     ", "-----", "     ", "     " },
    { ":", "     ", "  :  ", "     ", "  :  ", "     " }
};

void gerar_ascii_array(const char* input) {
    char linhas[5][MAX_LEN] = { "" };

    for (size_t i = 0; i < strlen(input); ++i) {
        char c = input[i];
        if (isalpha(c)) {
            int idx = toupper(c) - 'A';
            for (int j = 0; j < 5; ++j) {
                strcat(linhas[j], ascii_letters[idx][j]);
                strcat(linhas[j], " ");
            }
        } else if (isdigit(c)) {
            int idx = c - '0';
            for (int j = 0; j < 5; ++j) {
                strcat(linhas[j], ascii_numbers[idx][j]);
                strcat(linhas[j], " ");
            }
        } else if (c == ' ') {
            for (int j = 0; j < 5; ++j) {
                strcat(linhas[j], "     "); // espaço de 5 colunas
                strcat(linhas[j], " ");
            }
        } else {
            for (int s = 0; s < sizeof(ascii_symbols) / sizeof(ascii_symbols[0]); ++s) {
                if (c == ascii_symbols[s][0][0]) {
                    for (int j = 0; j < 5; ++j) {
                        strcat(linhas[j], ascii_symbols[s][j + 1]);
                        strcat(linhas[j], " ");
                    }
                    break;
                }
            }
        }
    }

    printf("char palavra[5][%lu] = {\n", strlen(linhas[0]) + 3); // +3 for \n and \0
    for (int i = 0; i < 5; ++i) {
        printf("    \"%s\\n\",\n", linhas[i]);
    }
    printf("};\n");
}

int main() {
    char entrada[MAX_LEN];
    printf("Digite uma string (A-Z, 0-9, !?:.-): ");
    fgets(entrada, sizeof(entrada), stdin);
    entrada[strcspn(entrada, "\n")] = 0;

    gerar_ascii_array(entrada);
    return 0;
}
