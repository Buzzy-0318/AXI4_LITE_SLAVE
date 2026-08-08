# AXI4-Lite Slave RTL Design & SystemVerilog Verification

A SystemVerilog-based **AXI4-Lite Slave RTL design and verification project** developed using ModelSim Intel FPGA Edition. The project implements a memory-mapped AXI4-Lite slave with FSM-based control, register read/write operations, `WSTRB` byte enables, invalid-address handling, and a class-based SystemVerilog verification environment.

## Project Overview

This project focuses on understanding and implementing the **AXI4-Lite protocol** at RTL level and verifying the design using a structured SystemVerilog testbench.

### AXI4-Lite Features

* Write Address Channel (`AW`)
* Write Data Channel (`W`)
* Write Response Channel (`B`)
* Read Address Channel (`AR`)
* Read Data Channel (`R`)
* VALID/READY handshake mechanism
* Memory-mapped register access
* FSM-based control
* `WSTRB` byte-enable support
* Invalid-address handling
* Read and write response generation

## RTL Design

The AXI4-Lite slave contains four internal 32-bit registers:

```text
REG0 → 0x00000000
REG1 → 0x00000004
REG2 → 0x00000008
REG3 → 0x0000000C
```

The RTL uses an FSM-based control mechanism to manage AXI4-Lite read and write transactions.

### AXI4-Lite Write Channels

```text
AWADDR
AWVALID
AWREADY
```

```text
WDATA
WSTRB
WVALID
WREADY
```

```text
BRESP
BVALID
BREADY
```

### AXI4-Lite Read Channels

```text
ARADDR
ARVALID
ARREADY
```

```text
RDATA
RRESP
RVALID
RREADY
```

## Verification Environment

The verification environment is implemented using SystemVerilog classes.

```text
                         TEST
                           │
                           ▼
                          ENV
                           │
                           ▼
                         AGENT
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
      GENERATOR          DRIVER          MONITOR
                                             │
                                  ┌──────────┴──────────┐
                                  │                     │
                                  ▼                     ▼
                             SCOREBOARD              COVERAGE
```

### Transaction

The transaction class represents AXI4-Lite operations and contains the information required to model read/write transactions, including address, data, `WSTRB`, transaction type, and response.

### Generator

Generates AXI4-Lite transactions and sends them to the Driver using a mailbox.

```text
Generator
    │
    │ gen2drv
    ▼
 Driver
```

### Driver

Receives transactions from the Generator and drives them onto the AXI4-Lite interface.

### Monitor

Observes AXI4-Lite activity and converts the observed bus operations into transactions.

The Monitor sends transactions to both the Scoreboard and Coverage using separate mailboxes:

```text
                    MONITOR
                   /       \
                  /         \
             mon2scb       mon2cov
                │             │
                ▼             ▼
           SCOREBOARD      COVERAGE
```

### Scoreboard

Checks the observed DUT behavior against the expected transaction behavior.

### Coverage

Functional coverage tracks important AXI4-Lite scenarios including:

* Read/write transaction types
* Valid register addresses
* Invalid addresses
* `WSTRB` combinations
* Response types
* Transaction/address combinations

### Agent

The Agent creates and controls:

* Generator
* Driver
* Monitor
* Scoreboard
* Coverage

It also manages the required mailboxes.

### Environment

The Environment creates the Agent and controls the overall verification environment.

```text
TEST
 │
 ▼
ENVIRONMENT
 │
 ▼
AGENT
 ├── Generator
 ├── Driver
 ├── Monitor
 ├── Scoreboard
 └── Coverage
```

### Test

The Test creates the Environment and starts the verification process.

### Testbench Top

The top-level testbench:

* Imports `axi4_pkg`
* Instantiates `axi4_lite_if`
* Instantiates the AXI4-Lite slave DUT
* Generates clock
* Generates reset
* Creates the Test
* Starts the simulation

## Project Structure

```text
AXI_LITE_SLAVE/
│
├── rtl/
│   └── axi4_lite_slave.sv
│
├── interface/
│   └── axi4_interface.sv
│
├── tb/
│   ├── axi4_transaction.sv
│   ├── axi4_generator.sv
│   ├── axi4_driver.sv
│   ├── axi4_monitor.sv
│   ├── axi4_scoreboard.sv
│   ├── axi4_agent.sv
│   ├── axi4_env.sv
│   ├── axi4_test.sv
│   ├── axi4_pkg.sv
│   └── axi4_testbench_top.sv
│
└── README.md
```

## Compilation

Compile the project in dependency order:

```tcl
vlog -work work -sv -stats=none axi4_interface.sv
vlog -work work -sv -stats=none axi4_lite_slave.sv
vlog -work work -sv -stats=none axi4_pkg.sv
vlog -work work -sv -stats=none axi4_testbench_top.sv
```

## Simulation

Load the testbench:

```tcl
vsim work.tb_top
```

Run the simulation:

```tcl
run -all
```

## Tools Used

* SystemVerilog
* ModelSim Intel FPGA Edition 10.5b
* RTL simulation
* SystemVerilog classes
* Mailboxes
* Functional coverage
* AXI4-Lite protocol

## Learning Objectives

This project was developed to understand:

* AXI4-Lite protocol channels
* VALID/READY handshaking
* Memory-mapped communication
* FSM-based RTL design
* Register read/write operations
* `WSTRB` byte-enable logic
* Invalid-address handling
* SystemVerilog transaction-based verification
* Generator/Driver/Monitor architecture
* Mailbox-based communication
* Scoreboard-based checking
* Functional coverage
* Verification environment hierarchy

## Verification Flow

```text
                     AXI4-LITE TESTBENCH

                           TEST
                            │
                            ▼
                           ENV
                            │
                            ▼
                          AGENT
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
         GENERATOR        DRIVER         MONITOR
             │              │              │
             │              ▼        ┌─────┴─────┐
             │             DUT        │           │
             │                       ▼           ▼
             └──────────────►    SCOREBOARD   COVERAGE
```

## Current Status

**Project Status: RTL + Class-Based Verification Environment Developed**

The project includes:

* AXI4-Lite Slave RTL
* FSM-based protocol control
* Memory-mapped registers
* `WSTRB` byte enables
* Invalid-address handling
* AXI4-Lite Interface
* Transaction
* Generator
* Driver
* Monitor
* Scoreboard
* Functional Coverage
* Agent
* Environment
* Test
* Testbench Top

The remaining stage is complete integration, debugging, and execution of comprehensive read/write verification scenarios.

## Repository Description

**AXI4-Lite Slave RTL Design and SystemVerilog Verification Environment — Memory-mapped AXI4-Lite slave with FSM control, register read/write operations, WSTRB byte enables, invalid-address handling, and class-based verification.**
