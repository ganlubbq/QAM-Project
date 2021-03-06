clear all
close all
clc

fs = 800e3;
Ts = 1/fs;
numberofSamples=24;
fm = 33e3;
w = 2*pi*fm;
wm = 2*pi*fm;
t = Ts:Ts:(numberofSamples*Ts);
% t=0 : pi/10 : 2*pi ;  
% t=0 : pi/50 : 2*pi ; 
output=int16(cos(wm*t)*2^11)   %8 for 12 bit output.
length(output)
plot(output)
fid = fopen('33KHzCosineLookUpTable.txt', 'w');
% fprintf(fid, '%4.0f  \n', output);
fprintf(fid, '%4.0f ,', output);
fclose(fid)