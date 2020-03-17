%% ϰ��1-3
clear;
syms a0 a1;
% �������±��������±�������Զ�Ӧ��ϵ����N=a1*C+a0
% ��֪���±�[100 1000]��Ӧ�������±�[0 100]
eq1 = 1000 == a1*100 + a0;
eq2 = 100  == a0;
[a0, a1] = solve([eq1, eq2], [a0, a1]);
% ���±��������±�Ĺ�ϵ
str1 = 'New temperature scale can be converted into the Celcius as ��N = %.1f��C + %.1f \n';
fprintf(str1, eval(a1), eval(a0));
N = @(C)(a1*C + a0);
% Q0Ϊ���±��ھ������ʱ����ֵ
Q0 = N(-273.15);
% ���±��Ծ����±��ʾ
Q = @(N)(N-Q0);
% ���±������Ծ����±��ʾΪ
str2 = 'Absolute temperature of 0��N is %.2f��Q \n';
fprintf(str2, eval(Q(0)));