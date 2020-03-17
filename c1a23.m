%% ϰ��1-23
%% ����ѭ��1231������
clear;
syms Rg Ta Tb p p1 v v1 v2 v3;
assume(v1<v2 & v1>0);
% ����1-2Ϊ���±仯����������Ϊ
w12 = int(Rg*Ta/v, v, v1, v2);
% ����v1 = v3��v3 = v2*Tb/Ta����v1 = v2*Tb/Ta
w12a = subs(w12, v1, v3);
w12b = subs(w12a, v3, Tb/Ta*v2);
% �����
w12c = simplify(w12b);
% ����2-3Ϊ��ѹ���̣���������Ϊ
w23 = int(Rg*Ta/v2, v, v2 ,v3);
% �����
w23a = expand(w23);
% ����v3 = v2*Tb/Ta����v1 = v2*Tb/Ta
w23b = subs(w23a, v3, Tb/Ta*v2);
% ����3-1Ϊ���ݹ��̣���������Ϊ
w31 = int(p, v, v1, v1);
% ����1-2-3-1������Ϊ
w1231 = w12c+w23b+w31;
%% ͬ�����ѭ��4564������
syms p p4 v v4 v5 v6;
assume(v4<v5 & v4>0);
w45 = int(Rg*Ta/v, v, v4, v5);
w45a = simplify(subs(w45, v4, Tb/Ta*v5));
w56 = int(Rg*Ta/v5, v, v5 ,v6);
w56a = subs(expand(w56), v6, Tb/Ta*v5);
w64 = int(p, v, v4, v4);
w4564 = w45a+w56a+w64;
%% �Ƚ��������̵�������
if isequal(w1231, w4564)
    results = ' equal';
else
    results = ' not equal';
end
str1 = 'The work of cycle 1-2-3-1 is ';
str2 = ' to that of cycle 4-5-6-4.\n';
fprintf(strcat(str1, results, str2))