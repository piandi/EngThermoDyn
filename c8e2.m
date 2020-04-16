%% �̲ģ���5�棩��8-2
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
%% ��ʼ��
clear;
% �������ݽṹ
material = struct('Name', "Air", 'p', 0.1e6, 'v', [], 'T', 20+273.15, 'm', 120/3600, 'Rg', 287);
process = struct('n', 1.3);

%%
% �����������������
fprintf('Calculating the work for ideal gas (air) in a multi-stage compressor ...\n')
NStage = input('Please input the number of stage: ');
% ��ֵ
materials(1:2) = material;
processes(1:NStage) = process;
materials(2).p = 12.5e6;

%% ����С����
% Ŀ�꺯��
work = @(pval)(sum(abs(MultiStageCompressor(pval, materials, processes))));
% ��ֵ
pval0 = zeros(NStage-1,1);
for i = 1:(NStage-1)
    pval0(i) = (materials(2).p-materials(1).p)/(NStage-i+10);
end
% ��ʹĿ�꺯����С��pvalֵ
options = optimset('PlotFcns', @optimplotfval);
[pi,w_min,exitflag] = fminsearch(work, pval0, options);

%% ������
% �б��������ѹ���Ĺ��ļ����ڹ���״̬
StageNum = [1:NStage]';
[Work,pout,vout,Tout] = MultiStageCompressor(pi, materials, processes);
pout = pout(2:end);
vout = vout(2:end);
Tout = Tout(2:end);
table(StageNum, Work, pout, vout, Tout)