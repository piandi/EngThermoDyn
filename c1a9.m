%% ϰ��1-9
clear;
syms PA PB PG3;
% ��1������Aѹ��PA = ��ѹ + ����ѹ
eq1 = PA == 0.294+0.1013;
% ��2������Aѹ��PA = ��ѹ + ��Bѹ��
eq2 = PA == 0.04+PB;
% ��3������Bѹ��PB = ��ѹ + ����ѹ
eq3 = PB == PG3+0.1013;
% ��������
[PA, PB, PG3] = solve([eq1, eq2, eq3], [PA, PB, PG3]);
% ��3�Ķ���Ϊ
fprintf('Gauge Pressure 3 is %.3f MPa \n', eval(PG3)));