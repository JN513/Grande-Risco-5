.globl _start

_start:
    li a2, 0  # Carrega 0 no registrador a2
    c.beqz a2, target  # Se a2 for zero, salta para 'target'
    li a1, 42  # Essa instrução será ignorada se o salto ocorrer

target:
    li a3, 99  # Executado se o salto for realizado
