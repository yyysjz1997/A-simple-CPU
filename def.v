`define idle	1'b0
`define exec	1'b1

`define NOP		5'b0_0000
`define HALT	5'b0_0001
`define LOAD	5'b0_0010
`define STORE	5'b0_0011
`define SLL		5'b0_0100
`define SLA		5'b0_0101
`define SRL		5'b0_0110
`define SRA		5'b0_0111
`define ADD		5'b0_1000
`define ADDI	5'b0_1001
`define SUB		5'b0_1010
`define SUBI	5'b0_1011
`define CMP		5'b0_1100
`define AND		5'b0_1101
`define OR		5'b0_1110
`define XOR		5'b0_1111
`define LDIH	5'b1_0000
`define ADDC	5'b1_0001
`define SUBC	5'b1_0010
`define SUIH	5'b1_0011
`define JUMP	5'b1_1000
`define JMPR	5'b1_1001
`define BZ		5'b1_1010
`define BNZ		5'b1_1011
`define BN		5'b1_1100
`define BNN		5'b1_1101
`define BC		5'b1_1110
`define BNC		5'b1_1111

`define gr0		3'b000
`define gr1		3'b001
`define gr2		3'b010
`define gr3		3'b011
`define gr4		3'b100
`define gr5		3'b101
`define gr6		3'b110
`define gr7		3'b111

`define NOP_decoding     {`NOP, 11'b101_0011_1001}
`define HALT_decoding    {`HALT, 11'b101_0011_1001}
`define LOAD_decoding    {`LOAD, 11'b101_0011_1001}
`define STORE_decoding   {`STORE, 11'b101_0011_1001}
`define SLL_decoding     {`SLL, 11'b101_0011_1001}
`define SLA_decoding     {`SLA, 11'b101_0011_1001}
`define SRL_decoding     {`SRL, 11'b101_0011_1001}
`define SRA_decoding     {`SRA, 11'b101_0011_1001}
`define ADD_decoding     {`ADD, 11'b101_0011_1001}
`define ADDI_decoding    {`ADDI, 11'b101_0011_1001}
`define SUB_decoding     {`SUB, 11'b101_0011_1001}
`define SUBI_decoding    {`SUBI, 11'b101_0011_1001}
`define CMP_decoding     {`CMP, 11'b101_0011_1001}
`define AND_decoding     {`AND, 11'b101_0011_1001}
`define OR_decoding      {`OR, 11'b101_0011_1001}
`define XOR_decoding     {`XOR, 11'b101_0011_1001}
`define LDIH_decoding    {`LDIH, 11'b101_0011_1001}
`define ADDC_decoding    {`ADDC, 11'b101_0011_1001}
`define SUBC_decoding    {`SUBC, 11'b101_0011_1001}
`define SUIH_decoding    {`SUIH, 11'b101_0011_1001}
`define JUMP_decoding    {`JUMP, 11'b101_0011_1001}
`define JMPR_decoding    {`JMPR, 11'b101_0011_1001}