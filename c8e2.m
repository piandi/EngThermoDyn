%% 教材（第5版）例8-2
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
%% 初始化
clear;
% 定义数据结构
material = struct('Name', "Air", 'p', 0.1e6, 'v', [], 'T', 20+273.15, 'm', 120/3600, 'Rg', 287);
process = struct('n', 1.3);

%%
% 命令行输入计算条件
fprintf('Calculating the work for ideal gas (air) in a multi-stage compressor ...\n')
NStage = input('Please input the number of stage: ');
% 初值
materials(1:2) = material;
processes(1:NStage) = process;
materials(2).p = 12.5e6;

%% 求最小功耗
% 目标函数
work = @(pval)(sum(abs(MultiStageCompressor(pval, materials, processes))));
% 初值
pval0 = zeros(NStage-1,1);
for i = 1:(NStage-1)
    pval0(i) = (materials(2).p-materials(1).p)/(NStage-i+10);
end
% 求使目标函数最小的pval值
options = optimset('PlotFcns', @optimplotfval);
[pi,w_min,exitflag] = fminsearch(work, pval0, options);

%% 输出结果
% 列表输出各级压缩的功耗及出口工质状态
StageNum = [1:NStage]';
[Work,pout,vout,Tout] = MultiStageCompressor(pi, materials, processes);
pout = pout(2:end);
vout = vout(2:end);
Tout = Tout(2:end);
table(StageNum, Work, pout, vout, Tout)