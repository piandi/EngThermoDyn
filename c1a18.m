
clear;
syms Qm Qc eta xi
Qc = 1;
eta = 0.35;
xi = 3;
W = Qc/xi;
Qm = W/eta;
fprintf('消耗燃油能量为 %.3f kJ \n', double(Qm))