%% 习题1-3
clear;
syms a0 a1;
% 假设新温标与摄氏温标存在线性对应关系，即N=a1*C+a0
% 已知新温标[100 1000]对应于摄氏温标[0 100]
eq1 = 1000 == a1*100 + a0;
eq2 = 100  == a0;
[a0, a1] = solve([eq1, eq2], [a0, a1]);
% 新温标与摄氏温标的关系
str1 = 'New temperature scale can be converted into the Celcius as °N = %.1f°C + %.1f \n';
fprintf(str1, eval(a1), eval(a0));
N = @(C)(a1*C + a0);
% Q0为新温标在绝对零度时的数值
Q0 = N(-273.15);
% 新温标以绝对温标表示
Q = @(N)(N-Q0);
% 新温标的零度以绝对温标表示为
str2 = 'Absolute temperature of 0°N is %.2f°Q \n';
fprintf(str2, eval(Q(0)));