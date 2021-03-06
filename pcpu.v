`timescale 1ns / 1ps
`include "def.v"

module pcpu(
    input clock,
    input enable,
    input reset,
    input start,
    //output [15:0] i_datain,
    output [15:0] d_datain,
    output [7:0] pc,
    output [7:0] d_addr,
    output d_we,
    output [15:0] d_dataout,
    output [15:0] reg_Ao,
    output [15:0] reg_Bo,
    output [15:0] reg_Co,
    output [15:0] reg_C1o,
    output [15:0] gro,
    output [15:0] smdr1_out
    );

    reg [15:0]pc_decoding;

    reg [15:0] i_data0;
    reg cf_buf;
    reg [15:0] ALUo;
    reg state, next_state;
    reg [7:0] pc1=1'b0;
    reg zf, nf, cf;
    reg dw;
    reg [15:0] id_ir, ex_ir, mem_ir, wb_ir;
    reg [15:0] reg_A, reg_B, reg_C, reg_C1, smdr, smdr1;
    reg [15:0] gr;
    wire branch_flag;

    //************* CPU Control *************//
    always @(posedge clock)
        begin
            if (reset)
                state <= `idle;
            else
                state <= next_state;
        end

    //************* CPU Control *************//
    always @(*)
        begin
            case (state)
                `idle :
                    if ((enable == 1'b1)
                            && (start == 1'b1))
                        next_state <= `exec;
                    else
                        next_state <= `idle;
                `exec :
                    if ((enable == 1'b0)
                            || (wb_ir[15:11] == `HALT))
                        next_state <= `idle;
                    else
                        next_state <= `exec;
            endcase
        end



    //************* IF *************//
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    id_ir <= {`NOP, 11'b000_0000_0000};
                    pc1 <= 8'b0000_0000;
                end

            else if (state ==`exec)
                begin
                    id_ir <= pc_decoding;
                    pc1 <= pc1 + 1'b1;
                    if(branch_flag)
                        pc1 <= reg_C[7:0];
                    else
                        pc1 <= pc + 1'b1;
                end
        end
    //**************decoding***************//
    always @(*)
        begin
            case (pc1)
                8'b0000_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0000_0001:
                    pc_decoding <= `NOP_decoding;
                8'b0000_0010:
                    pc_decoding <= `SLL_decoding;
                8'b0000_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0000_0100:
                    pc_decoding <= `NOP_decoding;
                8'b0000_0101:
                    pc_decoding <= `SLA_decoding;
                8'b0000_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0000_0111:
                    pc_decoding <= `NOP_decoding;
                8'b0000_1000:
                    pc_decoding <= `STORE_decoding;
                8'b0000_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0000_1010:
                    pc_decoding <= `NOP_decoding;
                8'b0000_1011:
                    pc_decoding <= `ADD_decoding;
                8'b0000_1100:
                    pc_decoding <= `NOP_decoding;
                8'b0000_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0000_1110:
                    pc_decoding <= `SUB_decoding;
                8'b0000_1111:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b0001_0010:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0100:
                    pc_decoding <= `OR_decoding;
                8'b0001_0101:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0001_0111:
                    pc_decoding <= `XOR_decoding;
                8'b0001_1000:
                    pc_decoding <= `NOP_decoding;
                8'b0001_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0001_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b0001_1011:
                    pc_decoding <= `NOP_decoding;
                8'b0001_1100:
                    pc_decoding <= `CMP_decoding;
                8'b0001_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0001_1111:
                    pc_decoding <= `SUB_decoding;
                8'b0010_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0010_0001:
                    pc_decoding <= `NOP_decoding;
                8'b0010_0010:
                    pc_decoding <= `SLL_decoding;
                8'b0010_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0010_0100:
                    pc_decoding <= `NOP_decoding;
                8'b0010_0101:
                    pc_decoding <= `SLA_decoding;
                8'b0010_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0010_0111:
                    pc_decoding <= `NOP_decoding;
                8'b0010_1000:
                    pc_decoding <= `STORE_decoding;
                8'b0010_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0010_1010:
                    pc_decoding <= `NOP_decoding;
                8'b0010_1011:
                    pc_decoding <= `ADD_decoding;
                8'b0010_1100:
                    pc_decoding <= `NOP_decoding;
                8'b0010_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0010_1110:
                    pc_decoding <= `SUB_decoding;
                8'b0010_1111:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b0011_0010:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0100:
                    pc_decoding <= `OR_decoding;
                8'b0011_0101:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0011_0111:
                    pc_decoding <= `XOR_decoding;
                8'b0011_1000:
                    pc_decoding <= `NOP_decoding;
                8'b0011_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0011_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b0011_1011:
                    pc_decoding <= `NOP_decoding;
                8'b0011_1100:
                    pc_decoding <= `SUBI_decoding;
                8'b0011_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0011_1111:
                    pc_decoding <= `JMPR_decoding;
                8'b0100_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0100_0001:
                    pc_decoding <= `NOP_decoding;
                8'b0100_0010:
                    pc_decoding <= `SLL_decoding;
                8'b0100_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0100_0100:
                    pc_decoding <= `NOP_decoding;
                8'b0100_0101:
                    pc_decoding <= `SLA_decoding;
                8'b0100_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0100_0111:
                    pc_decoding <= `NOP_decoding;
                8'b0100_1000:
                    pc_decoding <= `STORE_decoding;
                8'b0100_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0100_1010:
                    pc_decoding <= `NOP_decoding;
                8'b0100_1011:
                    pc_decoding <= `ADD_decoding;
                8'b0100_1100:
                    pc_decoding <= `NOP_decoding;
                8'b0100_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0100_1110:
                    pc_decoding <= `SUB_decoding;
                8'b0100_1111:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b0101_0010:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0100:
                    pc_decoding <= `OR_decoding;
                8'b0101_0101:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0101_0111:
                    pc_decoding <= `XOR_decoding;
                8'b0101_1000:
                    pc_decoding <= `NOP_decoding;
                8'b0101_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0101_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b0101_1011:
                    pc_decoding <= `NOP_decoding;
                8'b0101_1100:
                    pc_decoding <= `CMP_decoding;
                8'b0101_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0101_1111:
                    pc_decoding <= `SUB_decoding;
                8'b0110_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0110_0001:
                    pc_decoding <= `NOP_decoding;
                8'b0110_0010:
                    pc_decoding <= `SLL_decoding;
                8'b0110_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0110_0100:
                    pc_decoding <= `NOP_decoding;
                8'b0110_0101:
                    pc_decoding <= `SLA_decoding;
                8'b0110_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0110_0111:
                    pc_decoding <= `NOP_decoding;
                8'b0110_1000:
                    pc_decoding <= `STORE_decoding;
                8'b0110_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0110_1010:
                    pc_decoding <= `NOP_decoding;
                8'b0110_1011:
                    pc_decoding <= `ADD_decoding;
                8'b0110_1100:
                    pc_decoding <= `NOP_decoding;
                8'b0110_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0110_1110:
                    pc_decoding <= `SUB_decoding;
                8'b0110_1111:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0000:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b0111_0010:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0011:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0100:
                    pc_decoding <= `OR_decoding;
                8'b0111_0101:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0110:
                    pc_decoding <= `NOP_decoding;
                8'b0111_0111:
                    pc_decoding <= `XOR_decoding;
                8'b0111_1000:
                    pc_decoding <= `NOP_decoding;
                8'b0111_1001:
                    pc_decoding <= `NOP_decoding;
                8'b0111_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b0111_1011:
                    pc_decoding <= `NOP_decoding;
                8'b0111_1100:
                    pc_decoding <= `SUBI_decoding;
                8'b0111_1101:
                    pc_decoding <= `NOP_decoding;
                8'b0111_1111:
                    pc_decoding <= `JMPR_decoding;
                8'b1000_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1000_0001:
                    pc_decoding <= `NOP_decoding;
                8'b1000_0010:
                    pc_decoding <= `SLL_decoding;
                8'b1000_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1000_0100:
                    pc_decoding <= `NOP_decoding;
                8'b1000_0101:
                    pc_decoding <= `SLA_decoding;
                8'b1000_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1000_0111:
                    pc_decoding <= `NOP_decoding;
                8'b1000_1000:
                    pc_decoding <= `STORE_decoding;
                8'b1000_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1000_1010:
                    pc_decoding <= `NOP_decoding;
                8'b1000_1011:
                    pc_decoding <= `ADD_decoding;
                8'b1000_1100:
                    pc_decoding <= `NOP_decoding;
                8'b1000_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1000_1110:
                    pc_decoding <= `SUB_decoding;
                8'b1000_1111:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b1001_0010:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0100:
                    pc_decoding <= `OR_decoding;
                8'b1001_0101:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1001_0111:
                    pc_decoding <= `XOR_decoding;
                8'b1001_1000:
                    pc_decoding <= `NOP_decoding;
                8'b1001_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1001_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b1001_1011:
                    pc_decoding <= `NOP_decoding;
                8'b1001_1100:
                    pc_decoding <= `CMP_decoding;
                8'b1001_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1001_1111:
                    pc_decoding <= `SUB_decoding;
                8'b1010_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1010_0001:
                    pc_decoding <= `NOP_decoding;
                8'b1010_0010:
                    pc_decoding <= `SLL_decoding;
                8'b1010_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1010_0100:
                    pc_decoding <= `NOP_decoding;
                8'b1010_0101:
                    pc_decoding <= `SLA_decoding;
                8'b1010_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1010_0111:
                    pc_decoding <= `NOP_decoding;
                8'b1010_1000:
                    pc_decoding <= `STORE_decoding;
                8'b1010_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1010_1010:
                    pc_decoding <= `NOP_decoding;
                8'b1010_1011:
                    pc_decoding <= `ADD_decoding;
                8'b1010_1100:
                    pc_decoding <= `NOP_decoding;
                8'b1010_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1010_1110:
                    pc_decoding <= `SUB_decoding;
                8'b1010_1111:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b1011_0010:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0100:
                    pc_decoding <= `OR_decoding;
                8'b1011_0101:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1011_0111:
                    pc_decoding <= `XOR_decoding;
                8'b1011_1000:
                    pc_decoding <= `NOP_decoding;
                8'b1011_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1011_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b1011_1011:
                    pc_decoding <= `NOP_decoding;
                8'b1011_1100:
                    pc_decoding <= `SUBI_decoding;
                8'b1011_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1011_1111:
                    pc_decoding <= `JUMP_decoding;
                8'b1100_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1100_0001:
                    pc_decoding <= `NOP_decoding;
                8'b1100_0010:
                    pc_decoding <= `SLL_decoding;
                8'b1100_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1100_0100:
                    pc_decoding <= `NOP_decoding;
                8'b1100_0101:
                    pc_decoding <= `SLA_decoding;
                8'b1100_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1100_0111:
                    pc_decoding <= `NOP_decoding;
                8'b1100_1000:
                    pc_decoding <= `STORE_decoding;
                8'b1100_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1100_1010:
                    pc_decoding <= `NOP_decoding;
                8'b1100_1011:
                    pc_decoding <= `ADD_decoding;
                8'b1100_1100:
                    pc_decoding <= `NOP_decoding;
                8'b1100_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1100_1110:
                    pc_decoding <= `SUB_decoding;
                8'b1100_1111:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b1101_0010:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0100:
                    pc_decoding <= `OR_decoding;
                8'b1101_0101:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1101_0111:
                    pc_decoding <= `XOR_decoding;
                8'b1101_1000:
                    pc_decoding <= `NOP_decoding;
                8'b1101_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1101_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b1101_1011:
                    pc_decoding <= `NOP_decoding;
                8'b1101_1100:
                    pc_decoding <= `CMP_decoding;
                8'b1101_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1101_1111:
                    pc_decoding <= `SUB_decoding;
                8'b1110_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1110_0001:
                    pc_decoding <= `NOP_decoding;
                8'b1110_0010:
                    pc_decoding <= `SLL_decoding;
                8'b1110_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1110_0100:
                    pc_decoding <= `NOP_decoding;
                8'b1110_0101:
                    pc_decoding <= `SLA_decoding;
                8'b1110_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1110_0111:
                    pc_decoding <= `NOP_decoding;
                8'b1110_1000:
                    pc_decoding <= `STORE_decoding;
                8'b1110_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1110_1010:
                    pc_decoding <= `NOP_decoding;
                8'b1110_1011:
                    pc_decoding <= `ADD_decoding;
                8'b1110_1100:
                    pc_decoding <= `NOP_decoding;
                8'b1110_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1110_1110:
                    pc_decoding <= `SUB_decoding;
                8'b1110_1111:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0000:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0001:
                    pc_decoding <= `LOAD_decoding;
                8'b1111_0010:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0011:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0100:
                    pc_decoding <= `OR_decoding;
                8'b1111_0101:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0110:
                    pc_decoding <= `NOP_decoding;
                8'b1111_0111:
                    pc_decoding <= `XOR_decoding;
                8'b1111_1000:
                    pc_decoding <= `NOP_decoding;
                8'b1111_1001:
                    pc_decoding <= `NOP_decoding;
                8'b1111_1010:
                    pc_decoding <= `ADDI_decoding;
                8'b1111_1011:
                    pc_decoding <= `NOP_decoding;
                8'b1111_1100:
                    pc_decoding <= `SUBI_decoding;
                8'b1111_1101:
                    pc_decoding <= `NOP_decoding;
                8'b1111_1111:
                    pc_decoding <= `JUMP_decoding;
                    
            endcase
        end
	    //assign	i_datain=i_data0;

    //************* ID *************//
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    ex_ir <= {`NOP, 11'b000_0000_0000};
                    reg_A <= 16'b0000_0000_0000_0000;
                    reg_B <= 16'b0000_0000_0000_0000;
                    smdr <= 16'b0000_0000_0000_0000;
                end

            else if (state == `exec)
                begin
                    ex_ir <= id_ir;

                    if (id_ir[15:11] == `STORE)
                        //smdr <= [id_ir[10:8]];
                        smdr <= id_ir[10:8];
                    else
                        smdr <= smdr;

                    if (id_ir[15:11] == `JUMP)
                        reg_A <= 16'b0000_0000_0000_0000;
                    else if (I_R1_TYPE(id_ir[15:11]))
                        //reg_A <= gr[id_ir[10:8]];
                        reg_A <= id_ir[10:8];
                    else if (I_R2_TYPE(id_ir[15:11]))
                        //reg_A <= gr[id_ir[6:4]];
                        reg_A <= id_ir[6:4];
                    else
                        reg_A <= reg_A;

                    if (I_V3_TYPE(id_ir[15:11]))
                        reg_B <= {12'b0000_0000_0000, id_ir[3:0]};
                    else if (I_ZEROV2V3_TYPE(id_ir[15:11]))
                        reg_B <= {8'b0000_0000, id_ir[7:0]};
                    else if (I_V2V3ZERO_TYPE(id_ir[15:11]))
                        reg_B <= {id_ir[7:0], 8'b0000_0000};
                    else if (I_R3_TYPE(id_ir[15:11]))
                        //reg_B <= gr[id_ir[2:0]];
                        reg_B <= id_ir[2:0];
                    else
                        reg_B <= reg_B;
                end
        end

    //************* EX *************//
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    mem_ir <= {`NOP, 11'b000_0000_0000};
                    reg_C <= 16'b0000_0000_0000_0000;
                    smdr1 <= 16'b0000_0000_0000_0000;
                    dw <= 1'b0;
                    zf <= 1'b0;
                    nf <= 1'b0;
                    cf <= 1'b0;
                end

            else if (state == `exec)
                begin
                    reg_C <= ALUo;
                    mem_ir <= ex_ir;
                    dw<=1'b1;
                    if ((ex_ir[15:11] == `LDIH)
                            || (ex_ir[15:11] == `SUIH)
                            || (ex_ir[15:11] == `ADD)
                            || (ex_ir[15:11] == `ADDI)
                            || (ex_ir[15:11] == `ADDC)
                            || (ex_ir[15:11] == `SUB)
                            || (ex_ir[15:11] == `SUBI)
                            || (ex_ir[15:11] == `SUBC)
                            || (ex_ir[15:11] == `CMP)
                            || (ex_ir[15:11] == `AND)
                            || (ex_ir[15:11] == `OR)
                            || (ex_ir[15:11] == `XOR)
                            || (ex_ir[15:11] == `SLL)
                            || (ex_ir[15:11] == `SRL)
                            || (ex_ir[15:11] == `SLA)
                            || (ex_ir[15:11] == `SRA))
                        begin
                            cf <= cf_buf;
                            if (ALUo == 16'b0000_0000_0000_0000)
                                zf <= 1'b1;
                            else
                                zf <= 1'b0;
                            if (ALUo[15] == 1'b1)
                                nf <= 1'b1;
                            else
                                nf <= 1'b0;
                        end
                    else
                        begin
                            zf <= zf;
                            nf <= nf;
                            cf <= cf;
                        end

                    if (ex_ir[15:11] == `STORE)
                        begin
                            //dw <= 1'b1;
                            smdr1 <= smdr;
                            //dataout <= smdr1;
                        end
                    else
                        begin
                            //dw <= 1'b0;
                            smdr1 <= smdr1;
                            //dataout <= smdr1;
                        end
                end
        end
    always @(*)
        begin
            if (ex_ir[15:11] == `AND)
                begin
                    cf_buf <= 1'b0;
                    ALUo <= reg_A & reg_B;
                end
            else if (ex_ir[15:11] == `OR)
                begin
                    cf_buf <= 1'b0;
                    ALUo <= reg_A | reg_B;
                end
            else if (ex_ir[15:11] == `XOR)
                begin
                    cf_buf <= 1'b0;
                    ALUo <= reg_A ^ reg_B;
                end
            else if (ex_ir[15:11] == `SLL)
                {cf_buf, ALUo[15:0]} <= {cf, reg_A[15:0]} << reg_B[3:0];
            else if (ex_ir[15:11] == `SRL)
                {ALUo[15:0], cf_buf} <= {reg_A[15:0], cf} >> reg_B[3:0];
            else if (ex_ir[15:11] == `SLA)
                {cf_buf, ALUo[15:0]} <= {cf, reg_A[15:0]} <<< reg_B[3:0];
            else if (ex_ir[15:11] == `SRA)
                {ALUo[15:0], cf_buf} <= {reg_A[15:0], cf} >>> reg_B[3:0];
            else if ((ex_ir[15:11] == `SUB)
                    || (ex_ir[15:11] == `SUBI)
                    || (ex_ir[15:11] == `CMP)
                    || (ex_ir[15:11] == `SUIH))
                {cf_buf, ALUo} <= reg_A - reg_B;
            else if (ex_ir[15:11] == `SUBC)
                {cf_buf, ALUo} <= reg_A - reg_B - cf;
            else if (ex_ir[15:11] == `ADDC)
                {cf_buf, ALUo} <= reg_A + reg_B + cf;
            else
                {cf_buf, ALUo} <= reg_A + reg_B;
        end

    //************* MEM *************//
    assign reg_Ao=reg_A;
    assign reg_Bo=reg_B;
    assign reg_Co=reg_C;
    assign reg_C1o=reg_C1;
    assign gro=gr;
    assign pc=pc1;
    assign d_addr = reg_C[7:0];
    assign d_we = dw;
    assign smdr1_out = smdr1;
    assign d_dataout = smdr1;
    assign d_datain = smdr1 + 8'b0000_0101;
    assign branch_flag = ((mem_ir[15:11] == `JUMP)
                        || (mem_ir[15:11] == `JMPR)
                        || ((mem_ir[15:11] == `BZ) && (zf == 1'b1))
                        || ((mem_ir[15:11] == `BNZ) && (zf == 1'b0))
                        || ((mem_ir[15:11] == `BN) && (nf == 1'b1))
                        || ((mem_ir[15:11] == `BNN) && (nf == 1'b0))
                        || ((mem_ir[15:11] == `BC) && (cf == 1'b1))
                        || ((mem_ir[15:11] == `BNC) && (cf == 1'b0)));
    always @(posedge clock or posedge reset)
		begin	        
            if (reset)
                begin
                    wb_ir <= {`NOP, 11'b000_0000_0000};
                    reg_C1 <= 16'b0000_0000_0000_0000;
                end

            else if (state == `exec)
                begin
                    wb_ir <= mem_ir;

                    if (mem_ir[15:11] == `LOAD)
                        reg_C1 <= d_datain;
                    else
                        reg_C1 <= reg_C;
                end
        end

    //************* WB *************//
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    gr[15:0] <= 16'b0000_0000_0000_0000;
                end

            else if (state == `exec)
                begin
                    if (I_REG_TYPE(wb_ir[15:11]))
                        gr <= reg_C1;
                        wb_ir[10:8] <= reg_C1;
                end
        end

        //***** Judge an instruction whether alter the value of a register *****//
        function I_REG_TYPE;
            input [4:0] op1;
            begin
                I_REG_TYPE = ((op1 == `LOAD)
                        || (op1 == `LDIH)
                        || (op1 == `ADD)
                        || (op1 == `ADDI)
                        || (op1 == `ADDC)
                        || (op1 == `SUIH)
                        || (op1 == `SUB)
                        || (op1 == `SUBI)
                        || (op1 == `SUBC)
                        || (op1 == `AND)
                        || (op1 == `OR)
                        || (op1 == `XOR)
                        || (op1 == `SLL)
                        || (op1 == `SRL)
                        || (op1 == `SLA)
                        || (op1 == `SRA));
            end
        endfunction

        //************* R1 as reg_A *************//
        function I_R1_TYPE;
            input [4:0] op1;
            begin
                I_R1_TYPE = ((op1 == `LDIH)
                        || (op1 == `SUIH)
                        || (op1 == `ADDI)
                        || (op1 == `SUBI)
                        || (op1 == `JMPR)
                        || (op1 == `BZ)
                        || (op1 == `BNZ)
                        || (op1 == `BN)
                        || (op1 == `BNN)
                        || (op1 == `BC)
                        || (op1 == `BNC));
            end
        endfunction

        //************* R2 as reg_A *************//
        function I_R2_TYPE;
            input [4:0] op1;
            begin
                I_R2_TYPE = ((op1 == `LOAD)
                        || (op1 == `STORE)
                        || (op1 == `ADD)
                        || (op1 == `ADDC)
                        || (op1 == `SUB)
                        || (op1 == `SUBC)
                        || (op1 == `CMP)
                        || (op1 == `AND)
                        || (op1 == `OR)
                        || (op1 == `XOR)
                        || (op1 == `SLL)
                        || (op1 == `SRL)
                        || (op1 == `SLA)
                        || (op1 == `SRA));
            end
        endfunction

        //************* R3 as reg_B *************//
        function I_R3_TYPE;
            input [4:0] op1;
            begin
                I_R3_TYPE = ((op1 == `ADD)
                        || (op1 == `ADDC)
                        || (op1 == `SUB)
                        || (op1 == `SUBC)
                        || (op1 == `CMP)
                        || (op1 == `AND)
                        || (op1 == `OR)
                        || (op1 == `XOR));
            end
        endfunction

        //************* val3 as reg_B *************//
        function I_V3_TYPE;
            input [4:0] op1;
            begin
                I_V3_TYPE = ((op1 == `LOAD)
                        || (op1 == `STORE)
                        || (op1 == `SLL)
                        || (op1 == `SRL)
                        || (op1 == `SLA)
                        || (op1 == `SRA));
            end
        endfunction

        //************* {0000_0000,val2,val3} as reg_B *************//
        function I_ZEROV2V3_TYPE;
            input [4:0] op1;
            begin
                I_ZEROV2V3_TYPE = ((op1 == `ADDI)
                        || (op1 == `SUBI)
                        || (op1 == `JUMP)
                        || (op1 == `JMPR)
                        || (op1 == `BZ)
                        || (op1 == `BNZ)
                        || (op1 == `BN)
                        || (op1 == `BNN)
                        || (op1 == `BC)
                        || (op1 == `BNC));
            end
        endfunction

        //************* {val2,val3,0000_0000} as reg_B *************//
        function I_V2V3ZERO_TYPE;
            input [4:0] op1;
            begin
                I_V2V3ZERO_TYPE = ((op1 == `LDIH)
                        || (op1 == `SUIH));
            end
        endfunction

endmodule