%% ���ò��飺c7q1
% �տ�ϵ���������壨cp=1.005 kJ/kg-K��cv=0.785kJ/kg-K���ӳ�̬��1.5MPa��650K�����������̣�n=1.04���仯����̬��0.25MPa���������仯��
%
% by Dr. Guan Guoqiang @ SCUT on 2020-03-30
%
%%
% ��ʼ��
clear;
syms p v T
cp = 1.005e3; cv = 0.785e3; % ���ȵ�λΪJ/kg-K
n = 1.04; % ���ָ��
% ����Ϊ�������壬����Ү��ʽ�ɵ����峣��
Rg = cp-cv;
EOS = p*v == Rg*T;
% ��̬
p1 = 1.5e6; % ��λ��Pa
T1 = 650; % ��λ��K
v1 = eval(subs(solve(EOS, v), [p T], [p1 T1])); % ��λ��m3/kg
% ��̬
p2 = 0.25e6; % ��λ��Pa
% �տ�ϵ����������
v2 = (p1*v1^n/p2)^(1/n); % ��λ��m3/kg
T2 = eval(subs(solve(EOS, T), [p v], [p2 v2])); % ��λ��K
% ϵͳ���ܱ仯Ϊ
du = cv*(T2-T1);
% ϵͳ�������������������Ϊ
w = eval(int(p1*(v1/v)^n,v,v1,v2)); % ��λ��J/kg
% ϵͳ������Ϊ
q = du+w;
%% ���
% ��q�������ж�������
if q < 0
    prompt = 'Released';
else
    prompt = 'Absorbed';
end
prompt = [prompt,' heat is %.3e J/kg\n'];
% ��������ʾ
fprintf(prompt, q);