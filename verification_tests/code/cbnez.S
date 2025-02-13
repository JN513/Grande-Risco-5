.globl _start

_start:
    li a2, 1       # Carrega 1 no registrador a2
    c.bnez a2, target  # Se a2 for diferente de zero, salta para 'target'
    li a1, 42      # Essa instrução será ignorada se o salto ocorrer

target:
    li a3, 99      # Executado se o salto for realizado
