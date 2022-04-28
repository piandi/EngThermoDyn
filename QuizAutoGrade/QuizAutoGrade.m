%% 自动批改课堂测验
% 能把关国强提交的多次答案均作为参考答案，学生提交的结果与任一次答案一致即得分
% 学生提交多次答案时按导出的Excel工作表中最后一个为算分标准
%
% by Dr. Guan Guoqiang

%% 初始化
clear all
% 检查所需文件是否存在，m文件扩展名可省略
fileChkList = {'XSteam' 'ConvertGrade' 'dispQzResult' 'QzResults.mat'};
if any(ChkFiles(fileChkList)) == false
    return
end

%% 导入课测结果收集电子表
[Data,Workbook,meta] = importfile();
% 获取表头
Heads = Data(1,:);
Data(1,:) = [];
% 获取信息列
idxInfoCol = cellfun(@(x)(contains(x,'提交者')|contains(x,'提交时间')|contains(x,'姓名')|contains(x,'学号')),Heads);
% 获取课测题目列
idxQuestionCol = ~idxInfoCol;
% 课测题目数
QNum = sum(idxQuestionCol);
% 根据表头信息确定课程题目类型
QTypeID = zeros(QNum,1);
QuestionHeads = Heads(idxQuestionCol);
for iQT = 1:QNum
    str = regexp(QuestionHeads{iQT},'【\w*】','match');
    if isempty(str)
        fprintf('课测题：%s\n',QuestionHeads{iQT})
        fprintf('请指定题型代号 \n 1-单选题 \n 2-不定项选择题 \n 3-计算题（答案要求精确一致） \n 4-计算题（答案允许5%%偏差）\n 本小题不计分请输入其他数值\n')
        QTypeID(iQT) = input('请输入题型代号：');
    else
        switch str
            case('【单选题】')
                QTypeID(iQT) = 1;
            case('【不定项选择题】')
                QTypeID(iQT) = 2;
            case('【计算题】')
                QTypeID(iQT) = 4;
            otherwise
                error('无法识别字段“%s”类型',str)
        end
    end
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
    Raws = Data(i,idxQuestionCol);
    for iQ = 1:QNum
        Answers(iQ).Raw = Raws{iQ};
        if ~ismissing(Answers(iQ).Raw)
            Answers(iQ).Options = strsplit(Answers(iQ).Raw,', ');
        else
            Answers(iQ).Options = "";
        end
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
    if CollectSheets(i).Name == '黄炜航'
        fprintf('Debugging!\n')
    end
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
                        if all(matches(CollectSheets(i).Answers(iQ).Options, ...
                                Reference(j).Answers(iQ).Options)) % 用match函数判定答案与选项顺序无关
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
            case(4) % 计算题（结果允许+/-5%偏差）
                A = ExtractValue(string(CollectSheets(i).Answers(iQ).Options));             
                for j = 1:length(Reference)
                    B = ExtractValue(string(Reference(j).Answers(iQ).Options));
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
Time = string;
CorrectRate = zeros(height(Student),1);
RankByTime = zeros(height(Student),1);
Grade = string;
SN_L4D = cellfun(@(x)x(end-3:end),arrayfun(@(x)convertStringsToChars(x),Student.SN,'UniformOutput',false),'UniformOutput',false);
Student = [Student,table(SN_L4D)];
% 按学生成绩册中的名单顺序
for iStudent = 1:height(Student)
    if isequal(Student{iStudent,'Name'},'金宇心')
        fprintf('debug')
    end
    idx = cellfun(@(x)(strcmp(x,Student{iStudent,'Name'})),{CollectSheets.Name});
    if ~any(idx) % 按成绩单的姓名查找无果时
        if any(strcmp(fieldnames(CollectSheets),'SN_L4D')) % 按成绩单的学号后四位查找
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN_L4D'})),{CollectSheets.SN_L4D});
        else % 按成绩单的学号查找
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN'})),{CollectSheets.SN});
        end
    end
    if sum(idx) == 1
        Questions(iStudent,:) = [CollectSheets(idx).Answers.Grade];
        Time(iStudent,1) = CollectSheets(idx).Time;
        CorrectRate(iStudent,1) = mean(Questions(iStudent,:),'omitnan'); % 正确率
%         Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:),'omitnan')); % 课测成绩采用五分值        
    elseif sum(idx) > 1 % 多次提交       
        Questions(iStudent,:) = [CollectSheets(find(idx,1,'Last')).Answers.Grade];
        Time(iStudent,1) = CollectSheets(find(idx,1,'Last')).Time;
        CorrectRate(iStudent,1) = mean(Questions(iStudent,:),'omitnan'); % 正确率
%         Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:),'omitnan')); % 课测成绩采用五分值
    else
        fprintf('成绩登记表的%s不在提交课测的同学中!\n',Student{iStudent,'Name'})
        Grade(iStudent,1) = missing;
    end
end
[~,RankByTime(~ismissing(Time))] = sort(datenum(Time(~ismissing(Time))));
cGrade = arrayfun(@(x)num2str(x,"%.1f"),CorrectRate.*RankCoefficient(RankByTime),'UniformOutput',false); % 百分制成绩 = 得分率*排名系数
Grade(~ismissing(Time),1) = cGrade(~ismissing(Time));
Transcript = [Student,table(Questions),table(CorrectRate),table(RankByTime),table(Grade)];
% 
QzResult.Descript = Workbook;
QzResult.QTypeId = QTypeID;
QzResult.Transcript = Transcript;
QzResult.FileMeta = meta;
% 结果存盘
if input('【输入】结果是[1]/否[0]存入文件QzResults.mat：') == 1
    if exist('QzResults.mat','file') == 2
        load('QzResults.mat', 'QzResults')
        QzResults = [QzResults; QzResult];
    else
        QzResults = QzResult;
    end
    save('QzResults.mat', 'QzResults')
end

%% 输出结果
% 用柱状图显示本次课程各题得分率
dispQzResult(QzResult)
% 显示课程成绩合格同学名单
listNames = QzResult.Transcript.Name(str2double(QzResult.Transcript.Grade) >= 60);
if ~isempty(listNames)
    fprintf('课测成绩合格同学名单：%s\n',strjoin(listNames,'、'))
else
    fprintf('课测成绩合格同学名单：%s\n','无')
end
% 显示最高分同学
[bestGrade,iStudent] = max(str2double(QzResult.Transcript.Grade));
fprintf('%s同学得最高分%.1f\n',QzResult.Transcript.Name{iStudent},bestGrade)

function value = str2double1(strValue)
    if contains(strValue,"%")
        value = sscanf(strValue,'%f')/100;
    else
        value = sscanf(strValue,'%f');
    end
end

function value = RankCoefficient(ranking)
    value = zeros(size(ranking));
    N = max(ranking);
    idx = (ranking>0);
    value(idx) = 100-40*(ranking(idx)-1)/(N-1); % 第一名提交为100，最后一名为60
end