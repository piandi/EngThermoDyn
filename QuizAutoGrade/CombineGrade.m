%% 合并成绩单
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/14

clear
load('QzResults.mat','QzResults')

% 检查是否存在相同的课测成绩记录
QzNum = length(QzResults);
indices = false(1,QzNum);
QzNames = {QzResults.Descript};
for iQz = 1:QzNum
    idx = find(strcmp(QzNames{iQz},QzNames),1,'last');
    indices(idx) = true;
end

% 合并课测成绩
QzResults1 = QzResults(indices);
outTab1 = QzResults1(1).Transcript(:,1:5);
for iQz = 1:length(QzResults1)
    out2.(['Qz',num2str(iQz)]) = QzResults1(iQz).Transcript.Grade;
end
outTab = [outTab1,struct2table(out2)];

% 计算平均分
details = table2array(outTab(:,6:end));
if isequal(class(details),'string')
    details = str2double(details);
end
% 没提交的课测成绩设为0分
details(isnan(details)) = 0;
Avg = sum(details,2)./size(details,2);

% 输出结果
disp(sortrows([outTab,table(Avg)],{'Avg'},{'descend'}))