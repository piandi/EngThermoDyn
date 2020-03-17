%% ����11-3
% Rev.0 by GGQ on 2019-6-25
%
clear;
%% ����R134a����ѧ����
% reference
% * [�����ѧ��еϵ���ݱ�](https://www.ohio.edu/mechanical/thermo/property_tables/R134a/index.html)
load('R134a_sat.mat');
load('R134a_sup.mat');
%% ��ֵ�����R134a����
% ״̬��1Ϊ����������������ֵ���ɱ����¶�ȷ��
T1 = -20;
h1 = interp1(R134a_sat.T, R134a_sat.hg, T1);
% ��ȡ��ѹ���µ�����ѧ���ݱ������
fn_set = fieldnames(R134a_sup);
ptab_num = size(fn_set, 1); % ��ѹ���Ĺ�����������Ŀ
tmp_props = zeros(ptab_num, 4); % ��ʱ���ݼ�4�зֱ�Ϊ����������ܡ��ʺ���
p = zeros(ptab_num, 1);
% �ڸ�ѹ���Ĺ����������в��������¶ȵ�����
T3 = 40;
% ������ȡ��ѹ���µ�����ѧ����
for i = 1:ptab_num
    tmp_fn = fn_set(i);
    tmp_p = textscan(tmp_fn{:}, 's %f kPa');
    p(i) = tmp_p{:};
    sh_props = R134a_sup.(tmp_fn{:}); % ��ѹ���µ�����ѧ���ݱ�
    tmp_props(i,:) = interp1(sh_props(:,1), sh_props(:,2:end), T3);
end
% ͨ�������3�ı���ѹ���Լ�h2=h3��ȷ��h2
p3 = interp1(R134a_sat.T, R134a_sat.p, T3);
get_props = interp1(p, tmp_props, p3);
h2 = get_props(3);
% ״̬��3Ϊ����Һ��������ֵ���ɱ����¶�ȷ��
h3 = interp1(R134a_sat.T, R134a_sat.hf, T3);
% ����3-4Ϊ���ʽ������ͣ���״̬��4��ֵΪ
h4 = h3;
%% ������
q_endo = h1-h4;
%% ������ͨ��COP�Ƶ�
cop = 2.3;
w = -q_endo/cop;
% ѹ������������Ϊ
qc = (h2-h1)+w;