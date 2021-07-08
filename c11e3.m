%% 例题11-3
% Rev.0 by GGQ on 2019-6-25
%
clear;
%% 载入R134a热力学数据
% reference
% * [俄亥俄大学机械系数据表](https://www.ohio.edu/mechanical/thermo/property_tables/R134a/index.html)
load('R134a_sat.mat');
load('R134a_sup.mat');
%% 插值计算过R134a性质
% 状态点1为饱和蒸汽，故其焓值可由饱和温度确定
T1 = -20;
h1 = interp1(R134a_sat.T, R134a_sat.hg, T1);
% 获取各压力下的热力学数据表的名称
fn_set = fieldnames(R134a_sup);
ptab_num = size(fn_set, 1); % 各压力的过热蒸汽表数目
tmp_props = zeros(ptab_num, 4); % 临时数据集4列分别为比体积、内能、焓和熵
p = zeros(ptab_num, 1);
% 在各压力的过热蒸汽表中产生给定温度的性质
T3 = 40;
% 依次提取各压力下的热力学数据
for i = 1:ptab_num
    tmp_fn = fn_set(i);
    tmp_p = textscan(tmp_fn{:}, 's %f kPa');
    p(i) = tmp_p{:};
    sh_props = R134a_sup.(tmp_fn{:}); % 该压力下的热力学数据表
    tmp_props(i,:) = interp1(sh_props(:,1), sh_props(:,2:end), T3);
end
% 通过计算点3的饱和压力以及h2=h3，确定h2
p3 = interp1(R134a_sat.T, R134a_sat.p, T3);
get_props = interp1(p, tmp_props, p3);
h2 = get_props(3);
% 状态点3为饱和液，故其焓值可由饱和温度确定
h3 = interp1(R134a_sat.T, R134a_sat.hf, T3);
% 过程3-4为等焓节流膨胀，故状态点4焓值为
h4 = h3;
%% 吸热量
q_endo = h1-h4;
%% 做功量通过COP计得
cop = 2.3;
w = -q_endo/cop;
% 压缩过程吸热量为
qc = (h2-h1)+w;