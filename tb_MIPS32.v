`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2025 21:12:28
// Design Name: 
// Module Name: tb_MIPS_32
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


 module tb_MIPS_32;

 reg clk1;
                   
 reg clk2;
 
 integer k;
 
 MIPS32_RISC_V mips( 
                .clk1(clk1),
 
                .clk2(clk2)
                
               );
               
  initial 
            
            begin
                    
                    clk1=0;
                    clk2=0;
                    
                    repeat (1000) // Two phase clock non over lapping
                    
                    
                        begin
                        
                            #5 clk1=1; #5 clk1=0;
                            #5 clk2=1; #5 clk2=0;
                            
                        end
        
             end     
             
 
 initial 
    
    begin
        
      // TEST ONE
        
        
        /*for(k=0;k<31;k=k+1)  
        
           mips.REG[k]=k;
           
            begin
            
                mips.MEM[0]=32'h2801000a; // ADDI R1,R0,10
                mips.MEM[1]=32'h28020014; // ADDI R2,R0,20
                mips.MEM[2]=32'h28030019; // ADDI R3,R0,25
                mips.MEM[3]=32'h0ce77800; // OR R7,R7,R7 --> Dummy instruction to prevent hazards
                mips.MEM[4]=32'h0ce77800; // OR R7,R7,R7 --> Dummy instruction to prevent hazards
                mips.MEM[5]=32'h00222000; // ADD R4,R1,R2
                mips.MEM[6]=32'h0ce77800; // OR R7,R7,R7 --> Dummy instruction to avoid Hazards
                mips.MEM[7]=32'h00832800; // ADD R5,R4,R3
                mips.MEM[8]=32'hfc000000; // HALT
           
            end 
            */  
            
           // TEST TWO
           
         /*  
           for(k=0;k<31;k=k+1)  
        
             begin
             
              mips.REG[k]=k;
              
             end
           
           for(k=0;k<=1023;k=k+1)
            
            begin
                
                mips.MEM[k]=0;
                
            end
           
           
               
                mips.MEM[120]=85;
            
                mips.MEM[0]=32'h28010078; // ADDI R1,R0,120
                mips.MEM[1]=32'h0c631800; // OR R3,R3,R3 --> Dummy instruction to prevent hazards
                mips.MEM[2]=32'h20220000; // LW R2,0(R1)
                mips.MEM[3]=32'h0c631800; // OR R3,R3,R3 --> Dummy instruction to prevent hazards
                mips.MEM[4]=32'h2842002d; // ADDI R2,R2,45
                mips.MEM[5]=32'h0c631800; // OR R3,R3,R3 --> Dummy instruction to prevent hazards
                mips.MEM[6]=32'h24220001; // SW R2,1(R1)
                mips.MEM[7]=32'hfc000000; // HALT
           
              
            */
            
            
           //  TEST 3 FACTORIAL OF A NUMBER
            
  
            
             
              for(k=0;k<=31;k=k+1)  
        
                begin
             
                  mips.REG[k]=k;
              
                end
                
            for(k=0;k<=1023;k=k+1)
            
               begin
                
                 mips.MEM[k]=0;
                
               end
             
              mips.HALTED=0;
              mips.PC=0;
              mips.TAKEN_BRANCH=0;
              
             mips.MEM[200]=7; // FInding the factorial of 7
             
             
             mips.MEM[0]=32'h280a00c8;  // ADDI R10,R0,200
             mips.MEM[1]=32'h28020001;  // ADDI R2,R0,1
             mips.MEM[2]=32'h0e94a000;  // OR R20,R20,R20 --> Dummy Instruction
             mips.MEM[3]=32'h21430000;  // LW  R3,0(R10)
             mips.MEM[4]=32'h0e94a000;  // OR R20,R20,R20 --> Dummy Instruction
             mips.MEM[5]=32'h14431000;  // LOOP:MUL R2,R2,R3  // 14431000
             mips.MEM[6]=32'h2c630001;  // SUBI R3,R3,1
             mips.MEM[7]=32'h0e94a000;  // OR R20,R20,R20 --> Dummy Instruction
             mips.MEM[8]=32'h3460fffc;  // c , d? // BNEQZ R3, Loop (ie -3 , -4 offset)
             mips.MEM[9]=32'h2542fffe;  // SW R2, -2(R10)  2452fffe
             mips.MEM[10]=32'hfc000000; // HLT
             
             
            /*  #280 ;
              
              for(k=0;k<6;k=k+1)
                    
                   begin
                   
                        $display ("Reg values are  REG[%d]=%2d",k,mips.REG[k]);
                        
                    end
            */
            
           /* #1000;
            
                    
                   begin
                   
                        $display ("MEMORY VALUES ARE : MEM[120]=%d,MEM[121]=%d",mips.MEM[120],mips.MEM[121]);
                        
                    end
          */
          
          
          #2000;
          $display ("MEM[200]=%2d, MEM[198]=%6d",mips.MEM[200],mips.MEM[198]);
      
         #3000;
         $finish;
      
      
      end
        
        
        initial 
                begin   
                        
                        $monitor ("MEM[200]=%2d, MEM[198]=%6d",mips.MEM[200],mips.MEM[198]);
                        
                end
             
endmodule
