
clear;
syms Qm Qc elta xi
Qc = 1;
elta = 0.35;
xi = 3;
W = Qc/xi;
Qm = W/elta;
disp(sprintf('消耗燃油能量为 %.3f kJ \n', double(Qm)))