OUTPUT_ARCH("riscv")
ENTRY(_start)

/* Define a memória do sistema com 2/3 para código/dados e 1/3 para pilha */
MEMORY
{
  CODE_DATA (rwx) : ORIGIN = 0x00000000, LENGTH = 0x2A00    /* 10.240 bytes para código e dados */
  STACK (rw) : ORIGIN = 0x2A00, LENGTH = 0x1400             /* 5.120 bytes para a pilha */
  PERIPHERALS (rw) : ORIGIN = 0x80000000, LENGTH = 0x10000   /* Mapeamento de periféricos a partir de 0x80000000 */
}

/* As seções do código e dados */
SECTIONS
{
  /* Seção de texto (código) */
  .text :
  {
    *(.text)        /* Inclui todas as seções de código */
  } > CODE_DATA

  /* Seção de dados */
  .data :
  {
    *(.data)        /* Inclui todas as seções de dados */
  } > CODE_DATA

  /* Seção de bss (memória não inicializada) */
  .bss :
  {
    *(.bss)         /* Inclui todas as variáveis não inicializadas */
  } > CODE_DATA

  /* Seção de periféricos (mapeada a partir de 0x80000000) */
  .peripherals :
  {
    *(.peripherals) /* Inclui as seções de periféricos */
  } > PERIPHERALS

  /* Seção da pilha (stack) */
  .stack (NOLOAD) :
  {
    . = ORIGIN(STACK) + LENGTH(STACK); /* A pilha começa no topo da região STACK */
  } > STACK
}

