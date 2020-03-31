%% ѧ�����⣺c4s1
% A������3m3��80kPa��27C������ղ���B��������ճ���ѹ��ʹB�п����¶Ⱥ�ѹ���ֱ�Ϊ27C��640kPa�������С��
%
% by Dr. Guan Guoqiang @ SCUT on 2020-03-31
%
%% ��ʼ��
clear
syms p V T;
Rg = 0.285e3; % ȫ������Ϊ���ʵ�λ
% A������̬
pA1 = 80e3; VA = 3; TA1 = 27+273.15;
% B������̬
pB2 = 640e3; TB2 = 27+273.15;
% �ٶ����ʿ���Ϊ��������
% ��ʼA�еĹ�������
m = eval(subs(p*V/Rg/T, [p V T], [pA1 VA TA1]));
% ����B���������
VB = eval(subs(m*Rg*T/p, [p T], [pB2 TB2]));
vB2 = VB/m;
%% =================���¹��̲�����С��========================
% %% ��ȫ�����ʽ����տ�ϵ��ϵͳ״̬��(pA1,vA1)�仯��(pB2,vB2)
% % �ٶ����ʾ���������±仯���������Ϊ
% W = m*Rg*TA1*(VB-VA);
% %
%% A��������յ����������͵�ƽ�⣬pA2 = pB1, TB1 = TA2
% �����ͺ�����ռ���������ƽ��ѹ��
% A����
TA2 = TA1;
pA2 = m*Rg*TA2/(VA+VB);
vA2 = (VA+VB)/m;
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
VA2 = mA2*Rg*TB2/pB2;
% ����������Ϊ
WA = Rg*TA2*(VA2-VA1);
%% ��ƽ���B�����еĹ���Ϊ�տ�ϵ����״̬(pB1,vB1)�������±仯Ϊ(pB2,vB2)
% ���ʳ�̬ʱ��ռ���
VB1 = VB;
% ������̬ʱ��ռ���
VB2 = mB1*vB2;
% ����������Ϊ
WB = Rg*TB2*(VB2-VB1);
%
%% ��A����������պ����´�A��B���������ͨ�������ʴ�B������A�������ɵ������͵�ƽ��
% A�����еĹ���״̬ΪTA2��pA2��vA2��mA2
% B�����еĹ���״̬ΪTB1��pB1��vB1��mB1
% �˹����ر�
dS = m*Rg*log(vA2/vB2);
% �����¶�
T0 = 27+273.15;
% �������������仯
Ex = -T0*dS;
%% ���
fprintf('Input work is %.1e W\n', -(WA+WB))
if Ex < 0
    prompt = 'where the negative value indicates the decrease of working ability';
else
    prompt = 'where the positive value indicates the increase of working ability';
end
fprintf('Change of work ability is %.1e W, %s\n', Ex, prompt)