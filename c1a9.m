%% 习题1-9
clear;
syms PA PB PG3;
% 表1测量室A压力PA = 表压 + 大气压
eq1 = PA == 0.294+0.1013;
% 表2测量室A压力PA = 表压 + 室B压力
eq2 = PA == 0.04+PB;
% 表3测量室B压力PB = 表压 + 大气压
eq3 = PB == PG3+0.1013;
% 联立求解得
[PA, PB, PG3] = solve([eq1, eq2, eq3], [PA, PB, PG3]);
% 表3的读数为
fprintf('Gauge Pressure 3 is %.3f MPa \n', eval(PG3)));