module npc(
    input      [31:0] pcin,
    input      [31:0] rd1,
    input       [1:0] npcop,
    input             zero,
    input      [25:0] imm,
    output reg [31:0] nextpc,
	  output     [31:0] pc_4,
    
    input             rst
);
    assign pc_4 = pcin + 4;
    
    wire [31:0] j_target = {pc_4[31:28], imm, 2'b00};
    wire [31:0] b_offset = {{14{imm[15]}}, imm[15:0], 2'b00};

    always @(*) begin
        if (rst) begin
            nextpc = 32'h0000_3000;
        end else begin
            case (npcop)
                2'b00: nextpc = pc_4;//??
                2'b01: nextpc = zero ? pc_4 + b_offset : pc_4;//??
                2'b10: nextpc = j_target;//??
                2'b11: nextpc = rd1;//jr
                default: nextpc = pc_4;
            endcase
        end
    end
endmodule