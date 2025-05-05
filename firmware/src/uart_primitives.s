# Declarações globais das funções
.set UART_BASE_ADDR, 0x90000000

.globl uart_rx_empty
.globl uart_tx_empty
.globl uart_rx_full
.globl uart_tx_full
.globl uart_read
.globl uart_write
.globl enable_uart_rx
.globl disable_uart_rx
.globl set_uart_bit_period
.globl set_uart_parity_type

# Função para verificar se o buffer de recepção da UART está vazio
uart_rx_empty:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de status de recepção vazia da UART em t1
    lw a0, 4(t1)        # Carrega o valor do registrador t1 para a0 (retorno se o buffer de recepção está vazio)

    ret                 # Retorna da função

# Função para verificar se o buffer de transmissão da UART está vazio
uart_tx_empty:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de status de transmissão vazia da UART em t1
    lw a0, 12(t1)        # Carrega o valor do registrador t1 para a0 (retorno se o buffer de transmissão está vazio)

    ret                 # Retorna da função

# Função para verificar se o buffer de recepção da UART está cheio
uart_rx_full:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de status de recepção cheia da UART em t1
    lw a0, 8(t1)        # Carrega o valor do registrador t1 para a0 (retorno se o buffer de recepção está cheio)

    ret                 # Retorna da função

# Função para verificar se o buffer de transmissão da UART está cheio
uart_tx_full:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de status de transmissão cheia da UART em t1
    lw a0, 16(t1)        # Carrega o valor do registrador t1 para a0 (retorno se o buffer de transmissão está cheio)

    ret                 # Retorna da função

# Função para ler um caractere da UART
uart_read:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de leitura da UART em t1
    lw a0, 0(t1)        # Carrega o valor do registrador t1 para a0 (retorno do caractere lido da UART)

    ret                 # Retorna da função

# Função para escrever um caractere na UART
uart_write:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de escrita da UART em t1
    sw a0, 0(t1)        # Armazena o valor de a0 (caractere a ser escrito) no endereço t1 (escrita na UART)

    ret                 # Retorna da função

enable_uart_rx:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de controle da UART em t1
    li a0, 1            # Carrega o valor 1 em a0 (habilita a recepção na UART)
    sw a0, 4(t1)       # Armazena o valor de a0 no endereço t1 (habilita a recepção na UART)

    ret                 # Retorna da função

disable_uart_rx:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de controle da UART em t1
    li a0, 0            # Carrega o valor 0 em a0 (desabilita a recepção na UART)
    sw a0, 4(t1)       # Armazena o valor de a0 no endereço t1 (desabilita a recepção na UART)

    ret                 # Retorna da função

set_uart_bit_period:
    li t1, UART_BASE_ADDR   # Carrega o endereço do registrador de controle da UART em t1
    sw a0, 8(t1)        # Armazena o valor de a0 no endereço t1 (configura a taxa de bits da UART)

    ret                 # Retorna da função

set_uart_parity_type:
    li t1, UART_BASE_ADDR
    sw a0, 12(t1)

    ret