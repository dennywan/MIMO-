function [3:0]become ;
input [3:0]signal_reg_1;

if(signal_reg_1 == pos1)
    signal = neg1;
else if(signal_reg_1 == neg1)
     signal = pos1;
else if(signal_reg_1 == pos3)
     signal = neg3;
else if(signal_reg_1 == neg3)
     signal = pos3;
else if(signal_reg_1 == pos5)
     signal = neg5;
else if(signal_reg_1 == neg5)
     signal = pos5;
else if(signal_reg_1 == pos7)
     signal = neg7;
else if(signal_reg_1 == neg7)
    signal = pos7;


endfunction