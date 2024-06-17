`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 21:48:30
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_top(
        input wire clk,
        input wire rst,

        output wire inst_sram_ce,
        output wire[3:0] inst_sram_we,
        output wire[31:0] inst_sram_addr,
        output wire[31:0] inst_sram_wdata,
        input wire[31:0] inst_sram_rdata,

        output wire data_sram_ce,
        output wire[3:0] data_sram_we,
        output wire[31:0] data_sram_addr,
        output wire[31:0] data_sram_wdata,
        input wire[31:0] data_sram_rdata
    );
    
    assign inst_sram_we = 4'b0000;
    assign inst_sram_wdata = `ZeroWord;
    
    wire[31:0] pc;
    wire[5:0] stall;
    wire branch_tag;
    wire[31:0] branch_address;
    pc_reg pc_reg(
        .clk(clk), .rst(rst), .stall(stall), .pc(pc), .ce(inst_sram_ce),
        .branch_tag(branch_tag), .branch_address(branch_address)
    );
    assign inst_sram_addr = {12'h000, pc[19:0]};
    
    wire[31:0] id_pc_i;
    wire[31:0] id_inst_i;
    if_id if_id(
        .clk(clk), .rst(rst), .stall(stall), .if_pc(pc), .if_inst(inst_sram_rdata),
        .id_pc(id_pc_i), .id_inst(id_inst_i)
    );
    
    wire reg1_re;
    wire reg2_re;
    wire[4:0] reg1_addr;
    wire[4:0] reg2_addr;
    wire[31:0] reg1_data;
    wire[31:0] reg2_data;
    wire[2:0] id_inst_type;
    wire[2:0] id_inst_op;
    wire[3:0] id_alu_op;
    wire[31:0] id_reg1;
    wire[31:0] id_reg2;
    wire[31:0] id_reg3;
    wire id_reg_we;
    wire[4:0] id_reg_waddr;
    wire stall_req_id;

    id id(
        .rst(rst), .pc_i(id_pc_i), .inst_i(id_inst_i), 
        .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
        .reg1_re_o(reg1_re), .reg2_re_o(reg2_re),
        .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
        .inst_type_o(id_inst_type), .inst_op_o(id_inst_op), .alu_op_o(id_alu_op),
        .reg1_o(id_reg1), .reg2_o(id_reg2), .reg3_o(id_reg3),
        .reg_we_o(id_reg_we), .reg_waddr_o(id_reg_waddr),
        .stall_req(stall_req_id),
        .branch_tag(branch_tag), .branch_address(branch_address)
    );
    
    wire reg_we;
    wire[4:0] reg_waddr;
    wire[31:0] reg_wdata;
    wire ex_reg_we_o;
    wire[4:0] ex_reg_waddr_o;
    wire[31:0] ex_reg_wdata_o;
    wire mem_reg_we_o;
    wire[4:0] mem_reg_waddr_o;
    wire[31:0] mem_reg_wdata_o;
    regs regs(
        .clk(clk), .rst(rst),
        .we(reg_we), .waddr(reg_waddr), .wdata(reg_wdata),
        .ex_we(ex_reg_we_o), .ex_waddr(ex_reg_waddr_o), .ex_wdata(ex_reg_wdata_o),
        .mem_we(mem_reg_we_o), .mem_waddr(mem_reg_waddr_o), .mem_wdata(mem_reg_wdata_o),
        .re1(reg1_re), .raddr1(reg1_addr), .rdata1(reg1_data),
        .re2(reg2_re), .raddr2(reg2_addr), .rdata2(reg2_data)
    );
    
    wire[2:0] ex_inst_type;
    wire[2:0] ex_inst_op;
    wire[3:0] ex_alu_op;
    wire[31:0] ex_reg1;
    wire[31:0] ex_reg2;
    wire[31:0] ex_reg3;
    wire ex_reg_we;
    wire[4:0] ex_reg_waddr;

    id_ex id_ex(
        .clk(clk), .rst(rst), .stall(stall),
        .inst_type_id(id_inst_type), .inst_op_id(id_inst_op), .alu_op_id(id_alu_op),
        .reg1_id(id_reg1), .reg2_id(id_reg2), .reg3_id(id_reg3),
        .reg_we_id(id_reg_we), .reg_waddr_id(id_reg_waddr),
        .inst_type_ex(ex_inst_type), .inst_op_ex(ex_inst_op), .alu_op_ex(ex_alu_op),
        .reg1_ex(ex_reg1), .reg2_ex(ex_reg2), .reg3_ex(ex_reg3),
        .reg_we_ex(ex_reg_we), .reg_waddr_ex(ex_reg_waddr)
    );

    wire stall_req_ex;
    wire[2:0] ex_mem_op;
    wire[31:0] ex_mem_addr;
    wire[31:0] ex_mem_data;
    ex ex(
        .rst(rst),
        .inst_type(ex_inst_type), .inst_op(ex_inst_op), .alu_op(ex_alu_op),
        .reg1(ex_reg1), .reg2(ex_reg2), .reg3(ex_reg3),
        .reg_we_i(ex_reg_we), .reg_waddr_i(ex_reg_waddr),
        .reg_we_o(ex_reg_we_o), .reg_waddr_o(ex_reg_waddr_o),
        .reg_wdata_o(ex_reg_wdata_o),
        .mem_op(ex_mem_op), .mem_addr(ex_mem_addr), .mem_data(ex_mem_data),
        .stall_req(stall_req_ex)
    );
    
    wire mem_reg_we;
    wire[4:0] mem_reg_waddr;
    wire[31:0] mem_reg_wdata;
    wire[2:0] mem_op;
    wire[31:0] mem_addr;
    wire[31:0] mem_data;
    ex_mem ex_mem(
        .clk(clk), .rst(rst), .stall(stall),
        .ex_reg_we(ex_reg_we_o), .ex_reg_waddr(ex_reg_waddr_o),
        .ex_reg_wdata(ex_reg_wdata_o),
        .ex_mem_op(ex_mem_op), .ex_mem_addr(ex_mem_addr),
        .ex_mem_data(ex_mem_data),
        .mem_reg_we(mem_reg_we), .mem_reg_waddr(mem_reg_waddr),
        .mem_reg_wdata(mem_reg_wdata),
        .mem_op(mem_op), .mem_addr(mem_addr),
        .mem_data(mem_data)
    );
    
    assign data_sram_wdata = mem_data;
    assign data_sram_addr = mem_addr;
    
    wire stall_req_mem;
    mem mem(
        .rst(rst),
        .we_i(mem_reg_we), .waddr_i(mem_reg_waddr), .wdata_i(mem_reg_wdata),
        .mem_op(mem_op), .mem_rdata(data_sram_rdata),
        .reg_we_o(mem_reg_we_o), .reg_waddr_o(mem_reg_waddr_o), .reg_wdata_o(mem_reg_wdata_o),
        .mem_ce(data_sram_ce), .mem_we(data_sram_we),
        .stall_req(stall_req_mem)
    );
    
    wire wb_we;
    wire[4:0] wb_waddr;
    wire[31:0] wb_wdata;
    mem_wb mem_wb(
        .clk(clk), .rst(rst), .stall(stall),
        .mem_we(mem_reg_we_o), .mem_waddr(mem_reg_waddr_o), .mem_wdata(mem_reg_wdata_o),
        .wb_we(wb_we), .wb_waddr(wb_waddr), .wb_wdata(wb_wdata)
    );
    
    assign reg_we = wb_we;
    assign reg_waddr = wb_waddr;
    assign reg_wdata = wb_wdata;
    
    stall_control stall_control(
        .stall_req_id(stall_req_id),
        .stall_req_ex(stall_req_ex),
        .stall_req_mem(stall_req_mem),
        .stall(stall)
    );
endmodule
