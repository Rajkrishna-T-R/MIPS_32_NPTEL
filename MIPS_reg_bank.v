



module MIPS_REG_BANK_WITH_RST(

                            rd1,
                            rd2,
                            wrData,
                            sr1,
                            sr2,
                            dr,
                            write,
                            clk,
                            reset
                   
                           );
         
    
    
    input clk,write,reset;
    
    input [4:0]sr1,sr2,dr; // Source(sr) and destination(dr) registers
    
    input [31:0]wrData;
    
    output  [31:0] rd1,rd2;
    
    reg [31:0] reg_file [0:31];
    
    integer K;
    
    assign rd1 = reg_file[sr1];
    
    assign rd2 = reg_file[sr2];
  
  
  
        
        

        
    always @(posedge clk)
    
        begin
        
        if(reset)
        
            begin
                
                for(K=0;K<32;K=K+1)
                    
                    begin
                        
                        reg_file[K]<=0;
                    end
            end
        
          if(write)
          
           begin
        
             reg_file[dr] <= wrData; 
             
           end
           
        end
        
 endmodule
