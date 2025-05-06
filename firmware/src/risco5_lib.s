.globl delay_ms # Declara a função delay_ms global



# Função delay_ms: cria um atraso de a0 milissegundos
delay_ms:
    li t0, 0          # Inicializa t0 (contador de milissegundos) com 0
    li t1, 4167       # Define t1 como 4167 ciclos para aproximadamente 1ms

delay_loop:
    bge t0, a0, delay_end # Se t0 for maior ou igual a a0, termina
    addi t0, t0, 1    # Incrementa o contador de milissegundos
    li t2, 0          # Inicializa t2 (contador de ciclos) com 0
delay_1ms:
    addi t2, t2, 1    # Incrementa o contador de ciclos
    bge t2, t1, delay_loop # Se t2 for maior ou igual a t1, volta para delay_loop
    j delay_1ms       # Repete o loop de 1ms
delay_end:
    ret               # Retorna da função


