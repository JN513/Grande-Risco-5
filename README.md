# Grande RISCO 5

<p align="center">
<img src="docs/imgs/risco5.jpeg" alt="Processor Logo" width="300px">
</p>

**Grande RISCO 5** is a [RISC-V](https://riscv.org/) RV32IMBC_Zicsr processor with a 5-stage pipeline, developed in just a few days off.

- **Não fala Inglês? [Clique aqui](https://github.com/JN513/Grande-Risco-5/blob/main/README_pt.md)**

## Project Official Language

The official language adopted by the project is Brazilian Portuguese; therefore, most of the documentation and commits are in this language.

## Processor CI

[![Build Status](https://processorci.ic.unicamp.br/jenkins/buildStatus/icon?job=Grande-Risco-5/)](https://processorci.ic.unicamp.br/jenkins/blue/organizations/jenkins/Grande-Risco-5/activity)

## Implementation

The processor was implemented using **SystemVerilog**.

## RISC-V Extension Support

Grande RISCO 5 currently supports the following RISC-V extensions:

| Extension | Support |
|-----------|---------|
| I         | Complete |
| M         | Complete |
| C         | Complete |
| B         | In progress |
| A         | Speculative |
| Zicsr     | In progress |

## Testing and Verification

### Verification Tests

The `Verification_tests` directory contains examples and tests written in Assembly, along with their respective memory files. Additionally, there is a script available to convert Assembly into memory files (.hex).

### Testbenches

The `Testbenchs` directory contains testbenches developed using [Icarus Verilog (Iverilog)](https://steveicarus.github.io/iverilog/). Most tests are compatible with Iverilog, and some have been ported to [Verilator](https://verilator.org/).

## RISCO 5 Family

**Grande RISCO 5** is part of a family of RISC-V processors developed for different purposes:

- **[Baby Risco 5](https://github.com/JN513/Baby-Risco-5)** - RV32E, optimized for TinyTapeout.
- **[Pequeno Risco 5](https://github.com/JN513/Pequeno-Risco-5/)** - RV32I, single-cycle implementation (Archived).
- **[Risco 5](https://github.com/JN513/Risco-5)** - RV32I/E[M], multi-cycle implementation (Paused).
- **[Grande Risco 5](https://github.com/JN513/Grande-Risco-5)** - RV32I, pipeline implementation.
- **Risco 5 Bodybuilder** - RV64IMA, still speculative.
- **[RISCO 5S](https://github.com/JN513/Risco-5S)** - RV32IM, simulator written in C.

## Questions and Suggestions

The official documentation is available at: [jn513.github.io/Grande-Risco-5](https://jn513.github.io/Grande-Risco-5). If you have any questions or suggestions, feel free to use the [ISSUES](https://github.com/JN513/Grande-Risco-5/issues) section on GitHub. Contributions are welcome, and all [Pull Requests](https://github.com/JN513/Grande-Risco-5/pulls) will be reviewed.

## Contribution

If you wish to contribute to the project, follow the instructions in the [CONTRIBUTING.md](https://github.com/Grande-Risco-5/Risco-5/blob/main/CONTRIBUTING.md) file.

## License

This project is licensed under **[CERN-OHL-P-2.0](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE)**, ensuring full usage freedom.

- The software is under the **[MIT License](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE-MIT)**.
- The documentation follows **[CC BY-SA 4.0](https://github.com/JN513/Grande-Risco-5/blob/main/LICENSE-CC)**.

---

**Logo author:** [Mateus Luck](https://www.instagram.com/mateusluck/)

