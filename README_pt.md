# Grande RISCO 5

<p align="center">
<img src="docs/imgs/risco5.jpeg" alt="Logo do processador" width="300px">
</p>

**Grande RISCO 5** é um processador [RISC-V](https://riscv.org/) RV32IMBC_Zicsr com pipeline de 5 estágios, desenvolvido em alguns dias de folga.

- **Don't speak Portuguese? [Click here](https://github.com/JN513/Grande-Risco-5/blob/main/README.md)**

## Processor CI

[![Build Status](https://processorci.ic.unicamp.br/jenkins/buildStatus/icon?job=Grande-Risco-5/)](https://processorci.ic.unicamp.br/jenkins/blue/organizations/jenkins/Grande-Risco-5/activity)

## Implementação

O processador foi implementado utilizando **SystemVerilog**.

## Suporte a Extensões RISC-V

O Grande RISCO 5 atualmente oferece suporte às seguintes extensões RISC-V:

| Extensão | Suporte |
|----------|---------|
| I        | Completa |
| M        | Completa |
| C        | Completa |
| B        | Em implementação |
| A        | Especulada |
| Zicsr    | Em implementação |

## Testes e Verificação

### Testes de Verificação

O diretório `Verification_tests` contém exemplos e testes escritos em Assembly, além de seus respectivos arquivos de memória. Também há um script para converter Assembly em arquivos de memória (.hex).

### Testbenchs

O diretório `Testbenchs` contém testbenchs desenvolvidos com [Icarus Verilog (Iverilog)](https://steveicarus.github.io/iverilog/). A maioria dos testes disponíveis é compatível com Iverilog, e alguns foram portados para o [Verilator](https://verilator.org/).

## Família RISCO 5

O **Grande RISCO 5** faz parte de uma família de processadores RISC-V desenvolvidos para diferentes propósitos:

- **[Baby Risco 5](https://github.com/JN513/Baby-Risco-5)** - RV32E, implementação otimizada para o TinyTapeout.
- **[Pequeno Risco 5](https://github.com/JN513/Pequeno-Risco-5/)** - RV32I, implementação de ciclo único (Arquivada).
- **[Risco 5](https://github.com/JN513/Risco-5)** - RV32I/E[M], implementação multiciclo (Paralisada).
- **[Grande Risco 5](https://github.com/JN513/Grande-Risco-5)** - RV32I, implementação com pipeline.
- **Risco 5 Bodybuilder** - RV64IMA, ainda em fase especulativa.
- **[RISCO 5S](https://github.com/JN513/Risco-5S)** - RV32IM, simulador escrito em C.

## Dúvidas e Sugestões

A documentação oficial está disponível em: [jn513.github.io/Grande-Risco-5](https://jn513.github.io/Grande-Risco-5). Caso tenha dúvidas ou sugestões, utilize a seção de [ISSUES](https://github.com/JN513/Grande-Risco-5/issues) no GitHub. Contribuições são bem-vindas e todos os [Pull Requests](https://github.com/JN513/Grande-Risco-5/pulls) serão analisados.

## Contribuição

Se deseja contribuir com o projeto, siga as instruções disponíveis no arquivo [CONTRIBUTING.md](https://github.com/Grande-Risco-5/Risco-5/blob/main/CONTRIBUTING.md).

## Licença

Este projeto é licenciado sob a **[CERN-OHL-P-2.0](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE)**, garantindo liberdade total de uso.

- O software está sob a **[Licença MIT](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE-MIT)**.
- A documentação segue a **[CC BY-SA 4.0](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE-CC)**.

---

**Autor da logo:** [Mateus Luck](https://www.instagram.com/mateusluck/)

