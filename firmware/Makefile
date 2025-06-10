# Definição do compilador
COMPILER = riscv32-unknown-elf-

# Ferramentas
CC = ccache $(COMPILER)gcc
AS = $(COMPILER)as
LD = $(COMPILER)ld
OBJCOPY = $(COMPILER)objcopy
OBJDUMP = $(COMPILER)objdump
HEXDUMP = hexdump

# Configuração de arquitetura
MARCH = rv32im_zicsr
MABI = ilp32
BUILD_FLAGS = -nostartfiles -nostdinc -nostdlib -mstrict-align -static -O2
INCLUDES = -Ilib

# Diretórios
BUILD_DIR = build
SRC_DIR = src

LD_FILE = utils/link64k.ld

# Definição dos arquivos-fonte
C_SOURCES = main.c $(SRC_DIR)/pwm.c $(SRC_DIR)/risco5.c $(SRC_DIR)/uart.c $(SRC_DIR)/conversion.c
ASM_SOURCES = $(SRC_DIR)/boot.s $(SRC_DIR)/risco5_lib.s $(SRC_DIR)/uart_primitives.s $(SRC_DIR)/gpio.s $(SRC_DIR)/interruption.s

# Geração dos arquivos-objeto correspondentes
C_OBJECTS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(C_SOURCES)))
ASM_OBJECTS = $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

# Códigos ANSI para cores
BLUE := \033[1;34m
GREEN := \033[1;32m
YELLOW := \033[1;33m
RED := \033[1;31m
NC := \033[0m # Reset de cor

# Alvo padrão
all: buildFolder $(BUILD_DIR)/program.hex

.PHONY: all clean buildFolder

echo:
	@printf "$(YELLOW)Arquivos C:$(NC) $(C_SOURCES)\n"
	@printf "$(YELLOW)Arquivos Assembly:$(NC) $(ASM_SOURCES)\n"
	@printf "$(YELLOW)Objetos C:$(NC) $(C_OBJECTS)\n"
	@printf "$(YELLOW)Objetos Assembly:$(NC) $(ASM_OBJECTS)\n"

# Etapas de compilação
$(BUILD_DIR)/program.hex: $(BUILD_DIR)/program.bin
	@printf "$(BLUE)[HEX]$(NC) Gerando dump hexadecimal\n"
	$(HEXDUMP) -v -e '1/4 "%08x\n"' $< > $@

$(BUILD_DIR)/program.bin: $(BUILD_DIR)/program.elf $(BUILD_DIR)/program.s
	@printf "$(BLUE)[BIN]$(NC) Convertendo ELF para binário\n"
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/program.s: $(BUILD_DIR)/program.elf
	@printf "$(BLUE)[ASM]$(NC) Gerando dump do ELF\n"
	$(OBJDUMP) -d $< > $@

$(BUILD_DIR)/program.elf: $(C_OBJECTS) $(ASM_OBJECTS)
	@printf "$(GREEN)[LD]$(NC) Ligando objetos em ELF\n"
	$(LD) -o $@ $(ASM_OBJECTS) $(C_OBJECTS) -T $(LD_FILE)

# Compilação de arquivos C
$(BUILD_DIR)/%.o: %.c
	@printf "$(GREEN)[CC]$(NC) Compilando $<\n"
	$(CC) -march=$(MARCH) -mabi=$(MABI) -Wall -Ilib -c $< -o $@ $(BUILD_FLAGS) $(INCLUDES)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@printf "$(GREEN)[CC]$(NC) Compilando $<\n"
	$(CC) -march=$(MARCH) -mabi=$(MABI) -Wall -c $< -o $@ $(BUILD_FLAGS) $(INCLUDES)

# Montagem de arquivos Assembly
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@printf "$(GREEN)[AS]$(NC) Montando $<\n"
	$(AS) -march=$(MARCH) -mabi=$(MABI) $< -o $@

# Criar diretório de build se necessário
buildFolder:
	@mkdir -p $(BUILD_DIR)

# Limpeza dos arquivos gerados
clean:
	@printf "$(RED)[CLEAN]$(NC) Removendo arquivos gerados\n"
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.bin $(BUILD_DIR)/*.hex $(BUILD_DIR)/*.s

# Habilita paralelização automática com -j$(nproc)
MAKEFLAGS += -j$(shell nproc)

