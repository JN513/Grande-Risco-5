.globl _start

_start:
    c.li a1, 0x5       # Carrega o valor 5 em a1 usando a instrução c.li
    c.li a2, 0xA       # Carrega o valor 10 em a2 usando a instrução c.li
    c.li a3, 0xF       # Carrega o valor 15 em a3 usando a instrução c.li

    # Depois disso, podemos usar os valores de a1, a2 e a3 em cálculos
    li a4, 0x0         # Esta instrução será executada depois
