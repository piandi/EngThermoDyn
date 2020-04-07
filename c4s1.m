%% ѧ�����⣺c4s1
% A������3m3��80kPa��27C������ղ���B��������ճ���ѹ��ʹB�п����¶Ⱥ�ѹ���ֱ�Ϊ27C��640kPa�������С��
%
% by Dr. Guan Guoqiang @ SCUT on 2020-03-31
%
%% ��ʼ��
clear
T = 27+273.15;
syms p V m;
Rg = 0.285e3; % ȫ������Ϊ���ʵ�λ
% A������̬
pA1 = 80e3; VA = 3; TA1 = T;
% B������̬
pB2 = 640e3; TB2 = T;
% �ٶ����ʿ���Ϊ��������
EOS = p*V == m*Rg*T;
% ��ʼA�еĹ�������
mA1 = eval(subs(solve(EOS, m), [p V], [pA1 VA]));
% ����B���������
mB2 = mA1;
VB = eval(subs(solve(EOS, V), [p m], [pB2 mB2]));
vB2 = VB/mB2;
% =================���¹��̲�����С��========================
% %% ��ȫ�����ʽ����տ�ϵ��ϵͳ״̬��(pA1,vA1)�仯��(pB2,vB2)
% % �ٶ����ʾ���������±仯���������Ϊ
% W = eval(int(subs(solve(EOS, p), m, mB2), V, VA, VB));
% %
%% A��������յ����������͵�ƽ�⣬pA2 = pB1, TB1 = TA2
% �����ͺ�����ռ���������ƽ��ѹ��
% A����
TA2 = TA1;
pA2 = eval(subs(solve(EOS, p), [V m], [VA+VB mA1]));
vA2 = (VA+VB)/mA1;
mA2 = VA/vA2;
% B����
TB1 = TA2;
pB1 = pA2;
vB1 = vA2;
mB1 = VB/vB1;
%% ��ƽ���A�����еĹ���Ϊ�տ�ϵ����״̬(pA2,vA2)�������±仯Ϊ(pB2,vB2)
% ���ʳ�̬ʱ��ռ���
VA1 = VA;
% ������̬ʱ��ռ���
TB2 = TB1;
VA2 = eval(subs(solve(EOS, V), [p m], [pB2 mA2]));
% ����������Ϊ
WA = eval(int(subs(solve(EOS, p), m, mA2), V, VA1, VA2));
%% ��ƽ���B�����еĹ���Ϊ�տ�ϵ����״̬(pB1,vB1)�������±仯Ϊ(pB2,vB2)
% ���ʳ�̬ʱ��ռ���
VB1 = VB;
% ������̬ʱ��ռ���
VB2 = mB1*vB2;
% ����������Ϊ
WB = eval(int(subs(solve(EOS, p), m, mB1), V, VB1, VB2));
%
%% ��A����������պ����´�A��B���������ͨ�������ʴ�B������A�������ɵ������͵�ƽ��
% A�����еĹ���״̬ΪTA2��pA2��vA2��mA2
% B�����еĹ���״̬ΪTB1��pB1��vB1��mB1
% �˹����ر�
dS = mA1*Rg*log(vA2/vB2);
% �����¶�
T0 = 27+273.15;
% �������������仯
Ex = -T0*dS;
%% ���
fprintf('Input work is %.2e W\n', -(WA+WB))
if Ex < 0
    prompt = 'where the negative value indicates the decrease of working ability';
else
    prompt = 'where the positive value indicates the increase of working ability';
end
fprintf('Change of work ability is %.2e W, %s\n', Ex, prompt)