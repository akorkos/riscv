# top.vhd

This file connects the processor core to the UART peripheral, instruction ROM, and RAM. It also instantiates the address decoder implemented in decoder.vhd, which determines the destination of a memory write based on the specified address.

## core.vhd

The core connects the individual components that make up the processor. It also contains the process that updates the program counter on each rising clock edge.

### Program counter logic

#### pc_ctrl.vhd

This file implements the control logic for selecting the next program-counter value. The selected source is indicated by the sel signal.

#### mux_pc.vhd

This file uses the sel signal from pc_ctrl.vhd to select the next program-counter value. By default, the program counter is incremented by four bytes, corresponding to one 32-bit instruction.

For branches and direct jumps, the next address is calculated by adding an immediate value to the current program counter. For indirect jumps, the immediate value is added to the value stored in the selected source register.

#### branch_logic.vhd

This file Implements the conditions for different branch instructions. The result is output as either 1 if the branch is taken or 0 if not. 

### alu.vhd

In this file a simple RISC-V compatible alu is implemented. A case statement selects the operation to be performed on the two operands, A and B. The result is provided through the R output.

The ALU operation is decoded from the current instruction by alu_ctrl.vhd. The first operand is read from a register selected by the instruction. Depending on the instruction type, the second operand is either another register value or an immediate value. This selection is implemented in mux_rd2.vhd.

### mux_wb.vhd

This file implements the write-back multiplexer. It selects the value that is written to the destination register. The possible sources include the ALU result, the next program-counter value, an immediate value, and data loaded from memory.

The multiplexer is controlled by wb_ctrl.vhd. The destination register itself is selected by the rd field of the current instruction.

### register_file.vhd

This file implements the 32 registers defined by the RISC-V ISA. Register x0 is protected from writes and therefore remains zero.

The write-enable logic is implemented in reg_we.vhd.

### imm_select.vhd

This file implements the logic for generating immediate values. Because the immediate-value bits are encoded differently for different instruction formats, the required bits are selected, rearranged, and sign-extended according to the current instruction.

## instr_rom

This file contains the pre compiled binary instructions of the program.

## ram

In this file a 1 KiB adressable ram is  implemented. The string hello world, followed by a newline character, is stored as initial data beginning at address 432.

## uart

The uart implements only a tx interface to send data. It provides memory-mapped registers for configuring the clock divider and transmitting data.

### tx

This file uses the FIFO Generator IP to buffer bytes that are waiting to be transmitted. The FIFO interface has an 8-bit data width.

A state machine transmits the buffered data. It consists of five states:

1. IDLE: The transmitter waits until data is available in the FIFO.
2. START: The start bit is transmitted.
3. DATA: The eight data bits are transmitted.
4. P: The parity bit is transmitted.
5. STOP: The stop bit is transmitted before the state machine returns to IDLE.

# Questions

## 1
 b) 
ADDI
LUI
LW
LBU
SW
SB
BNE
BGE
JAL
JALR

The floating point and undefined instructions represent the ascii string "hello world\n"

## 2

 a) The main things that make up the state of the RISC-V CPU are the registers, the programm counter and the memory. 

 b) The different instructions can be differentiated by the opcode which are the first 7 bits. When having different instructions with the same opcode, the fucnt3(14 downto 12) and funct7(31 downto 25) are used to differentiate. 

 c) 

 d) 
 
 - An i-type immediate is a continuous 12 bit signed value.
 - An s-type immediate is split across 2 instruction fields(31 downto 25, 11 downto 7).
 - A u-type immediate represents a 32 bit integer. The bits 31 to 12 are also bit 31 to 12 in the instruction. Bit 11 downto 0 are 0.
