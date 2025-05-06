#include <stdio.h>

int main() {
    char palavra[5][93] = {
        " GGG  RRRR    A   N   N DDD   EEEEE       RRRR   III   SSS   CCC   OOO        55555   !   \n",
        "G     R   R  A A  NN  N D  D  E           R   R   I   S     C   C O   O       5       !   \n",
        "G  GG RRRR  AAAAA N N N D   D EEE         RRRR    I    SSS  C     O   O       5555    !   \n",
        "G   G R R   A   A N  NN D  D  E           R R     I       S C   C O   O           5       \n",
        " GGG  R  RR A   A N   N DDD   EEEEE       R  RR  III   SSS   CCC   OOO        5555    !   \n",
    };
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < 93; j++){
            putc(palavra[i][j], stdout);
        }
    }

    return 0;
}
