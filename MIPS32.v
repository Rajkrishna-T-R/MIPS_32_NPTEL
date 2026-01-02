


module MIPS32_RISC_V(

                     input clk1,
                     
                     input clk2

                    );
                    
  reg [31:0] PC,IF_ID_IR,IF_ID_NPC;
             
  reg [31:0] ID_EX_IR,ID_EX_NPC,ID_EX_A,ID_EX_B,ID_EX_Imm;
  
  reg [2:0] ID_EX_type,EX_MEM_type,MEM_WB_type;
  
  reg [31:0] EX_MEM_IR,EX_MEM_ALUout,EX_MEM_B,EX_MEM_cond;
  
  reg [31:0] MEM_WB_IR,MEM_WB_ALUout,MEM_WB_LMD;
  
  reg [31:0] REG[0:31]; // Register Bank 32 x 32 
  
  reg [31:0] MEM[0:1023]; // 1024 x 32 Memory 
  
  
  // Below are the instruction encoding
  
  parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011,
            SLT=6'b000100, MUL=6'b000101, HLT=6'b111111, LW=6'b001000,
            SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100,
            BNEQZ=6'b001101, BEQZ=6'b001110;
            
            
            
            
  parameter Delay=2'd2; // Delay used is this one
  
  
  
  // Type of instruction is mentioned below
  
  parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010, STORE = 3'b011,
            BRANCH=3'b100, HALT=3'b101;
            
  reg HALTED;  // Set after HLT instruction is completed(in WB stage)
  
  reg TAKEN_BRANCH; // Required to disable instructions afer branch
  
  
  // Instruction Fetch Stage
  
  always@(posedge clk1)
    
    if(HALTED==0)
        
        begin
            
            if(((EX_MEM_IR[31:26]==BEQZ)&&(EX_MEM_cond==1))||
                 (EX_MEM_IR[31:26]==BNEQZ)&&(EX_MEM_cond==0)) // why zero?
                 begin
                 
                    IF_ID_IR <= #Delay MEM[EX_MEM_ALUout];
                    TAKEN_BRANCH <= #Delay 1'b1;
                    IF_ID_NPC <= #Delay EX_MEM_ALUout+1;
                    PC <= #Delay EX_MEM_ALUout+1;
                  
                  end
             else
                 
                 begin
                    
                    IF_ID_IR <= #Delay MEM[PC];
                    IF_ID_NPC <= #Delay PC+1;
                    PC <= #Delay PC+1;
                    
                 end
                 
           end
  
  
  // Instruction Decode
  
always@(posedge clk2)
    
    
 begin
 
  if(HALTED==0)
  
    begin
        
        if(IF_ID_IR[25:21]==5'b00000)
          
          begin
          
           ID_EX_A   <=  0;     // rs -- source reg 1          
           
          end
          
         else
         
               begin
                
                    ID_EX_A <= #Delay REG[IF_ID_IR[25:21]]; // rs -- source reg 1 
                
               end
               
         if(IF_ID_IR[20:16]==5'b00000)
                     
                begin
                    
                    ID_EX_B <= 0;
                    
                end
                
         else 
            
                begin
                    
                    ID_EX_B <= REG[IF_ID_IR[20:16]]; // rt -- Source register 2
            
                end
                
                
         ID_EX_NPC <= #Delay IF_ID_NPC;
         
         ID_EX_IR <= #Delay IF_ID_IR;
         
         ID_EX_Imm <= #Delay {{16{IF_ID_IR[15]}},{IF_ID_IR[15:0]}};
         
         
         
         case(IF_ID_IR[31:26])
            
            ADD,SUB,AND,OR,MUL,SLT : ID_EX_type <= #Delay RR_ALU;
            
            ADDI,SUBI,SLTI         : ID_EX_type <= #Delay RM_ALU;
            
            LW                     : ID_EX_type <= #Delay LOAD;
            
            SW                     : ID_EX_type <= #Delay STORE;
            
            BNEQZ,BEQZ             : ID_EX_type <= #Delay BRANCH;
            
            HLT                    : ID_EX_type <= #Delay HALT;
            
            default                : ID_EX_type <= #Delay HALT; // Invalid instruction opcode
            
            
                                
         
         endcase
         
         
         
         
         
  
   end
   
   
   
end   
  
  // Excecution stage
  
  
always@(posedge clk1)
    
    begin
       
        if(HALTED == 0)
                
                begin
                    
                    EX_MEM_type <= #Delay ID_EX_type;
                    
                    EX_MEM_IR <= #Delay ID_EX_IR;
                    
                    TAKEN_BRANCH <= #Delay 0;
                    
                    case (ID_EX_type)
                            
                            RR_ALU: begin
                                        case (ID_EX_IR[31:26])  // OPCODE
                                                
                                                ADD:  EX_MEM_ALUout <= #Delay ID_EX_A + ID_EX_B;
                                                SUB:  EX_MEM_ALUout <= #Delay ID_EX_A - ID_EX_B;
                                                AND:  EX_MEM_ALUout <= #Delay ID_EX_A & ID_EX_B;
                                                OR:   EX_MEM_ALUout <= #Delay ID_EX_A | ID_EX_B;
                                                SLT:  EX_MEM_ALUout <= #Delay ID_EX_A < ID_EX_B;
                                                MUL:  EX_MEM_ALUout <= #Delay ID_EX_A * ID_EX_B;
                                                default: EX_MEM_ALUout <= #Delay 32'hxxxxxxxx;
                                         endcase
                                         
                                     end
                            RM_ALU: begin
                                        case(ID_EX_IR[31:26])
                                                ADDI : EX_MEM_ALUout <= #Delay ID_EX_A + ID_EX_Imm;
                                                SUBI : EX_MEM_ALUout <= #Delay ID_EX_A - ID_EX_Imm;
                                                SLTI:  EX_MEM_ALUout <= #Delay ID_EX_A < ID_EX_Imm;
                                                default: EX_MEM_ALUout <= #Delay 32'hxxxxxxxx;
                                        endcase
                                        
                                     end               
                            LOAD, STORE:
                                    begin
                                        EX_MEM_ALUout <= #Delay ID_EX_A + ID_EX_Imm;
                                        EX_MEM_B      <= #Delay ID_EX_B;
                                    end
                            
                            BRANCH: begin
                                        EX_MEM_ALUout <= #2 ID_EX_NPC + ID_EX_Imm;
                                        EX_MEM_cond <= #2 (ID_EX_A == 0);
                                    end
                    endcase      
                    
                     
             end        
         
    end
    
    // MEM Stage
    
    always@(posedge clk2)
           begin
            
            if(HALTED == 0)
                    begin
                          
                          MEM_WB_type <= #Delay EX_MEM_type;
                          MEM_WB_IR   <= #Delay EX_MEM_IR;
                          
                          case(EX_MEM_type)
                                
                                RR_ALU,RM_ALU:
                                        
                                      begin
                                        
                                        MEM_WB_ALUout <= #Delay EX_MEM_ALUout;
                                        
                                      end
                                      
                                LOAD: 
                                      begin
                                      
                                        MEM_WB_LMD <= #Delay MEM[EX_MEM_ALUout];
                                      
                                      end
                                      
                                STORE: 
                                        begin
                                                
                                                if(TAKEN_BRANCH == 0) // Disable write
                                                   
                                                   begin
                                                        
                                                        MEM[EX_MEM_ALUout] <= #Delay EX_MEM_B;
                                                        
                                                   end     
                                        end
                        endcase
               end
               
           end   
           
           
           //  WRITE BACK STAGE
           
always@(posedge clk1) 
        
        begin
            
            if(TAKEN_BRANCH == 0) // Disable write if branch taken
            
            case (MEM_WB_type)
                
                RR_ALU : REG[MEM_WB_IR[15:11]] <= #Delay MEM_WB_ALUout; // "rd"
                
                RM_ALU : REG[MEM_WB_IR[20:16]] <= #Delay MEM_WB_ALUout; // "rt"
                
                LOAD   : REG[MEM_WB_IR[20:16]] <= #Delay MEM_WB_LMD;  // "rt"
                
                HALT   : HALTED <= #Delay 1'b1;
                
             endcase
         
         end
               
               
endmodule
