//---------------------------------------------------------------------\                                                                          
// scrambler module for data[31:0],   lfsr[15:0]=1+x^4+x^13+x^15+x^16; |                                                                                 
//---------------------------------------------------------------------/                                                                          
`timescale 1ns / 1ps
module scrambler(                                                                                                                                        
   input             clk,      
   input             rst,
   input             scram_rst,                                                                                                                                       
   input             scram_en,                                                                                                                                        
   input      [31:0] data_in,                                                                                                                                  
   output reg [31:0] data_out,                                                                                                                            
   output reg [31:0] data_c                                                                                                                                              
);                                                                                                                                            
                                                                                                                                                          
reg [15:0] lfsr_q, lfsr_c;                                                                                                                              
                                                                                                            
always @(*) begin                                                                                                                                      
      lfsr_c[0]  = lfsr_q[0]   ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ 
                   lfsr_q[11]  ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ;                          
      lfsr_c[1]  = lfsr_q[0]   ^ lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ 
                   lfsr_q[11]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ;                           
      lfsr_c[2]  = lfsr_q[1]   ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ 
                   lfsr_q[12]  ^ lfsr_q[13] ^ lfsr_q[14] ;                                        
      lfsr_c[3]  = lfsr_q[2]   ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ 
                   lfsr_q[13]  ^ lfsr_q[14] ^ lfsr_q[15] ;                                       
      lfsr_c[4]  = lfsr_q[3]   ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ 
                   lfsr_q[9]   ^ lfsr_q[12] ;                                                      
      lfsr_c[5]  = lfsr_q[4]   ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ 
                   lfsr_q[10]  ^ lfsr_q[13] ;                                                     
      lfsr_c[6]  = lfsr_q[5]   ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ 
                   lfsr_q[11]  ^ lfsr_q[14] ;                                                     
      lfsr_c[7]  = lfsr_q[0]   ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ 
                   lfsr_q[10]  ^ lfsr_q[12] ^ lfsr_q[15] ;                                        
      lfsr_c[8]  = lfsr_q[1]   ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ 
                   lfsr_q[11]  ^ lfsr_q[13] ;                                                    
      lfsr_c[9]  = lfsr_q[2]   ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ 
                   lfsr_q[12]  ^ lfsr_q[14] ;                                                   
      lfsr_c[10] = lfsr_q[3]   ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ 
                   lfsr_q[13]  ^ lfsr_q[15] ;                                                 
      lfsr_c[11] = lfsr_q[0]   ^ lfsr_q[4]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ 
                   lfsr_q[13]  ^ lfsr_q[14] ;                                                 
      lfsr_c[12] = lfsr_q[1]   ^ lfsr_q[5]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ 
                   lfsr_q[14]  ^ lfsr_q[15] ;                                                 
      lfsr_c[13] = lfsr_q[2]   ^ lfsr_q[5]  ^ lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ^ 
                   lfsr_q[13]  ;                                                               
      lfsr_c[14] = lfsr_q[3]   ^ lfsr_q[6]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ 
                   lfsr_q[14]  ;                                                               
      lfsr_c[15] = lfsr_q[4]   ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ 
                   lfsr_q[11]  ^ lfsr_q[13] ^ lfsr_q[14] ;                                      
                                                                                                                                                           
      data_c[0]  = data_in[0]  ^ lfsr_q[15] ;                                                                                                                 
      data_c[1]  = data_in[1]  ^ lfsr_q[14] ^ lfsr_q[15] ;                                                                                                    
      data_c[2]  = data_in[2]  ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ;                                                                                       
      data_c[3]  = data_in[3]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ;                                                                                       
      data_c[4]  = data_in[4]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ;                                                                          
      data_c[5]  = data_in[5]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ;                                                                          
      data_c[6]  = data_in[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ;                                                                           
      data_c[7]  = data_in[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ 
                                 lfsr_q[15] ;                                                               
      data_c[8]  = data_in[8]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ 
                                 lfsr_q[14] ^ lfsr_q[15];                                                   
      data_c[9]  = data_in[9]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ 
                                 lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ;                                      
      data_c[10] = data_in[10] ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ lfsr_q[9]  ^ 
                                 lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ;                                     
      data_c[11] = data_in[11] ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[8]  ^ 
                                 lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ;                        
      data_c[12] = data_in[12] ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[7]  ^ 
                                 lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ 
                                 lfsr_q[15] ;           
      data_c[13] = data_in[13] ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ 
                                 lfsr_q[14] ;            
      data_c[14] = data_in[14] ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ 
                                 lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[12] ^ 
                                 lfsr_q[13] ;             
      data_c[15] = data_in[15] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[11] ^ 
                                 lfsr_q[12] ^ lfsr_q[15] ; 
      data_c[16] = data_in[16] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[10] ^ lfsr_q[11] ^ 
                                 lfsr_q[14] ^ lfsr_q[15] ;
      data_c[17] = data_in[17] ^ lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[13] ^ 
                                 lfsr_q[14] ;             
      data_c[18] = data_in[18] ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ;                          
      data_c[19] = data_in[19] ^ lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ;                          
      data_c[20] = data_in[20] ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[10] ^ lfsr_q[11] ;                                      
      data_c[21] = data_in[21] ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[5]  ^ 
                                 lfsr_q[6]  ^ lfsr_q[9]  ^ lfsr_q[10] ^ lfsr_q[15] ;                          
      data_c[22] = data_in[22] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[4]  ^ 
                                 lfsr_q[5]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ lfsr_q[14] ^ 
                                 lfsr_q[15] ;              
      data_c[23] = data_in[23] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[8]  ^ lfsr_q[13] ^ lfsr_q[14] ^ 
                                 lfsr_q[15] ;             
      data_c[24] = data_in[24] ^ lfsr_q[0]  ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[7]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ;                         
      data_c[25] = data_in[25] ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ 
                                 lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ;                                      
      data_c[26] = data_in[26] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[4]  ^ lfsr_q[5]  ^ 
                                 lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ;                        
      data_c[27] = data_in[27] ^ lfsr_q[0]  ^ lfsr_q[3]  ^ lfsr_q[4]  ^ lfsr_q[9]  ^ 
                                 lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ;                        
      data_c[28] = data_in[28] ^ lfsr_q[2]  ^ lfsr_q[3]  ^ lfsr_q[8]  ^ lfsr_q[9]  ^ 
                                 lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ;                        
      data_c[29] = data_in[29] ^ lfsr_q[1]  ^ lfsr_q[2]  ^ lfsr_q[7]  ^ lfsr_q[8]  ^ 
                                 lfsr_q[9]  ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ;                         
      data_c[30] = data_in[30] ^ lfsr_q[0]  ^ lfsr_q[1]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ 
                                 lfsr_q[8]  ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ 
                                 lfsr_q[15] ;            
      data_c[31] = data_in[31] ^ lfsr_q[0]  ^ lfsr_q[5]  ^ lfsr_q[6]  ^ lfsr_q[7]  ^ 
                                 lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ 
                                 lfsr_q[15] ;           
   end // always                                                                                                                                          
                                                                                                                                                          
   always @(posedge clk) 
   begin                                                                                                               
      if(rst) 
      begin                                                                                                                                        
         lfsr_q   <= {16{1'b1}};                                                                                                                       
      end                                                                                                                                                  
      else 
      begin                                                                                                                                           
         lfsr_q   <= scram_rst ? {16{1'b1}} : scram_en ? lfsr_c : lfsr_q;                                                                                     
         data_out <= scram_en ? data_c : data_out;                                                                                                          
      end                                                                                                                                                  
   end              
endmodule    

