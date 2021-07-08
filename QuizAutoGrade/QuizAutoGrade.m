%% 自动批改课堂测验
% 能把关国强提交的多次答案均作为参考答案，学生提交的结果与任一次答案一致即得分
% 学生提交多次答案时按导出的Excel工作表中最后一个为算分标准
%
% by Dr. Guan Guoqiang
%
clear all

%% 用户输入课程题的题型
QNum = input('【输入】请输入课测题目数：');
fprintf('【输入】请输入课测题的题型代号 \n 1-单选题 \n 2-不定项选择题 \n 3-计算题（答案要求精确一致） \n 4-计算题（答案允许5%%偏差）\n')
QTypeID = zeros(QNum,1);
for iQ = 1:QNum
    prompt = sprintf('【输入】第%d题的题型代号为：',iQ);
    QTypeID(iQ) = input(prompt);
end

%% 导入课测结果收集电子表
[Data,Workbook] = importfile();
% 获取表头
Heads = Data(1,:);
Data(1,:) = [];
% 获取信息列
InfoCols = cellfun(@(x)(contains(x,'提交者')|contains(x,'提交时间')|contains(x,'姓名')|contains(x,'学号')),Heads);
% 获取课测题目列
QuestionCols = ~InfoCols;
% 检查用户输入的课测题数目与收集表中的记录是否一致
if sum(QuestionCols) == QNum
    fprintf('【信息】收集表中课测题目数量与指定一致。\n')
else
    fprintf('【错误】用户输入的课测题数目与收集表中的记录不一致！\n')
    return
end

%% 重构答卷
CollectSheets = struct([]);
Reference = struct([]);
DelIdx = [];
for i = 1:length(Data)
    % 姓名
    CollectSheets(i).Name = Data{i,cellfun(@(x)(contains(x,'姓名')),Heads)};
    % 判定是否存在学号列
    idx_SN = cellfun(@(x)(contains(x,'学号')|contains(x,'SN')),Heads);
    if any(idx_SN)
        if contains(Heads{idx_SN},'后四位')||contains(Heads{idx_SN},'后4位')||contains(Heads{idx_SN},'L4D')
            CollectSheets(i).SN_L4D = Data{i,idx_SN};
        else
            CollectSheets(i).SN = Data{i,idx_SN};
        end
    end
    % 提交时间
    CollectSheets(i).Time = Data{i,cellfun(@(x)(contains(x,'提交时间')),Heads)};
    % 课测题目
    Answers = struct([]);
    % 依次处理各题
    Raws = Data(i,QuestionCols);
    for iQ = 1:QNum
        Answers(iQ).Raw = Raws{iQ};
        Answers(iQ).Options = strsplit(Answers(iQ).Raw,', ');
        Answers(iQ).TypeID = QTypeID(iQ);
    end
    CollectSheets(i).Answers = Answers;
    % 提取标准答案
    if CollectSheets(i).Name == '关国强'
        DelIdx = [DelIdx;i];
        Reference = [Reference;CollectSheets(i)];
    end
end
% 在收集表中删除标准答案
if exist('DelIdx','var')
    CollectSheets(DelIdx) =[];
else
    fprintf('【错误】未发现标准答案！\n')
    return
end
% 依次批改
for i = 1:length(CollectSheets)
%     if i == 20
%         fprintf('Debugging!\n')
%     end
    for iQ = 1:QNum
        switch CollectSheets(i).Answers(iQ).TypeID
            case(1) % 单选题
                for j = 1:length(Reference)
                    if CollectSheets(i).Answers(iQ).Options == Reference(j).Answers(iQ).Options
                        CollectSheets(i).Answers(iQ).Grade = 1;
                        break
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            case(2) % 不定项选择题
                for j = 1:length(Reference)
                    ONum = length(CollectSheets(i).Answers(iQ).Options);
                    if ONum == length(Reference(j).Answers(iQ).Options)
                        if all(CollectSheets(i).Answers(iQ).Options == Reference(j).Answers(iQ).Options)
                            CollectSheets(i).Answers(iQ).Grade = 1;
                            break
                        else
                            CollectSheets(i).Answers(iQ).Grade = 0;
                        end
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            case(3) % 计算题（严格一致）
                for j = 1:lenght(Reference)
                    if CollectSheets(i).Answers(iQ).Options == Reference(j).Answers(iQ).Options
                        CollectSheets(i).Answers(iQ).Grade = 1;
                        break
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            case(4) %
                A = str2double(regexp(CollectSheets(i).Answers(iQ).Options,'\d+[.]?\d+','match'));
                for j = 1:length(Reference)
                    B = str2double(Reference(j).Answers(iQ).Options);
                    if abs((A-B)/B) <= 0.05
                        CollectSheets(i).Answers(iQ).Grade = 1;
                        break
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            otherwise
                CollectSheets(i).Answers(iQ).Grade = NaN;
        end
    end
end

%% 导入学生成绩录入模板
% 程序流控制
OutputOrNot = input('【输入】是[1]/否[0]导入“学生成绩录入模板Excel文件”：');
switch OutputOrNot
    case(0)
        fprintf('【信息】学生成绩录入模板，结束运行。\n')
        return
    case(1)
        fprintf('【信息】学生成绩录入模板\n')
    otherwise
        fprintf('【错误】未知输入参数！\n')
        return
end
% 导入学生名单
Raw = importfile();
% 构造学生成绩册
Heads = GetVarName(cellstr([Raw{1,:}]));
Student = cell2table(Raw(2:end,:),'VariableNames',Heads);
Questions = zeros(height(Student),QNum);
Grade = string;
SN_L4D = cellfun(@(x)x(end-3:end),arrayfun(@(x)convertStringsToChars(x),Student.SN,'UniformOutput',false),'UniformOutput',false);
Student = [Student,table(SN_L4D)];
% 按学生成绩册中的名单顺序
for iStudent = 1:height(Student)
    idx = cellfun(@(x)(strcmp(x,Student{iStudent,'Name'})),{CollectSheets.Name});
    if ~any(idx)
        if any(strcmp(fieldnames(CollectSheets),'SN_L4D'))
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN_L4D'})),{CollectSheets.SN_L4D});
        else
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN'})),{CollectSheets.SN});
        end
    end
    if sum(idx) == 1
        Questions(iStudent,:) = [CollectSheets(idx).Answers.Grade];
        Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:)));
    elseif sum(idx) > 1 % 多次提交       
        Questions(iStudent,:) = [CollectSheets(find(idx,1,'Last')).Answers.Grade];
        Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:)));
    end
end
Transcript = [Student,table(Questions),table(Grade)];
% 
QzResult.Descript = Workbook;
QzResult.QTypeId = QTypeID;
QzResult.Transcript = Transcript;
% 结果存盘
if input('【输入】结果是[1]/否[0]存入文件QzResults.mat：') == 1
    if exist('QzResults.mat','file') == 2
        load('QzResults.mat', 'QzResults')
        QzResults = [QzResults; QzResult];
    else
        QzResults = QzResult;
    end
    save('QzResults.mat', 'QzResults')
else
    return
end

%% 输出结果
dispQzResult(QzResult)