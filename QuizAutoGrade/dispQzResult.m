%% 显示指定的课测结果
% 
% by Dr. Guan Guoqiang @ SCUT on 2021/3/23
function dispQzResult(QzResult)
fprintf('课测提交成绩%d份（名册人数：%d人）\n', ...
    sum(~ismissing(QzResult.Transcript.Grade)), ...
    height(QzResult.Transcript))
stat = sum(QzResult.Transcript.Questions)./sum(~ismissing(QzResult.Transcript.Grade));
bar(stat)
set(gca,'FontName','等线')
getTexts = strsplit(QzResult.Descript,'.');
xlabel('题号'); ylabel('正确率'); title(getTexts{1});