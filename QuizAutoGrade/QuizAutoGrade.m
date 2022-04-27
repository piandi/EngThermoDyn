%% �Զ����Ŀ��ò���
% �ܰѹع�ǿ�ύ�Ķ�δ𰸾���Ϊ�ο��𰸣�ѧ���ύ�Ľ������һ�δ�һ�¼��÷�
% ѧ���ύ��δ�ʱ��������Excel�����������һ��Ϊ��ֱ�׼
%
% by Dr. Guan Guoqiang

%% ��ʼ��
clear all
% ��������ļ��Ƿ���ڣ�m�ļ���չ����ʡ��
fileChkList = {'XSteam' 'ConvertGrade' 'dispQzResult' 'QzResults.mat'};
if any(ChkFiles(fileChkList)) == false
    return
end

%% ����β����ռ����ӱ�
[Data,Workbook,meta] = importfile();
% ��ȡ��ͷ
Heads = Data(1,:);
Data(1,:) = [];
% ��ȡ��Ϣ��
idxInfoCol = cellfun(@(x)(contains(x,'�ύ��')|contains(x,'�ύʱ��')|contains(x,'����')|contains(x,'ѧ��')),Heads);
% ��ȡ�β���Ŀ��
idxQuestionCol = ~idxInfoCol;
% �β���Ŀ��
QNum = sum(idxQuestionCol);
% ���ݱ�ͷ��Ϣȷ���γ���Ŀ����
QTypeID = zeros(QNum,1);
QuestionHeads = Heads(idxQuestionCol);
for iQT = 1:QNum
    str = regexp(QuestionHeads{iQT},'��\w*��','match');
    if isempty(str)
        fprintf('�β��⣺%s\n',QuestionHeads{iQT})
        fprintf('��ָ�����ʹ��� \n 1-��ѡ�� \n 2-������ѡ���� \n 3-�����⣨��Ҫ��ȷһ�£� \n 4-�����⣨������5%%ƫ�\n ��С�ⲻ�Ʒ�������������ֵ\n')
        QTypeID(iQT) = input('���������ʹ��ţ�');
    else
        switch str
            case('����ѡ�⡿')
                QTypeID(iQT) = 1;
            case('��������ѡ���⡿')
                QTypeID(iQT) = 2;
            case('�������⡿')
                QTypeID(iQT) = 4;
            otherwise
                error('�޷�ʶ���ֶΡ�%s������',str)
        end
    end
end

%% �ع����
CollectSheets = struct([]);
Reference = struct([]);
DelIdx = [];
for i = 1:length(Data)
    % ����
    CollectSheets(i).Name = Data{i,cellfun(@(x)(contains(x,'����')),Heads)};
    % �ж��Ƿ����ѧ����
    idx_SN = cellfun(@(x)(contains(x,'ѧ��')|contains(x,'SN')),Heads);
    if any(idx_SN)
        if contains(Heads{idx_SN},'����λ')||contains(Heads{idx_SN},'��4λ')||contains(Heads{idx_SN},'L4D')
            CollectSheets(i).SN_L4D = Data{i,idx_SN};
        else
            CollectSheets(i).SN = Data{i,idx_SN};
        end
    end
    % �ύʱ��
    CollectSheets(i).Time = Data{i,cellfun(@(x)(contains(x,'�ύʱ��')),Heads)};
    % �β���Ŀ
    Answers = struct([]);
    % ���δ������
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
    % ��ȡ��׼��
    if CollectSheets(i).Name == '�ع�ǿ'
        DelIdx = [DelIdx;i];
        Reference = [Reference;CollectSheets(i)];
    end
end
% ���ռ�����ɾ����׼��
if exist('DelIdx','var')
    CollectSheets(DelIdx) =[];
else
    fprintf('������δ���ֱ�׼�𰸣�\n')
    return
end
% ��������
for i = 1:length(CollectSheets)
%     if i == 20
%         fprintf('Debugging!\n')
%     end
    for iQ = 1:QNum
        switch CollectSheets(i).Answers(iQ).TypeID
            case(1) % ��ѡ��
                for j = 1:length(Reference)
                    if CollectSheets(i).Answers(iQ).Options == Reference(j).Answers(iQ).Options
                        CollectSheets(i).Answers(iQ).Grade = 1;
                        break
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            case(2) % ������ѡ����
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
            case(3) % �����⣨�ϸ�һ�£�
                for j = 1:lenght(Reference)
                    if CollectSheets(i).Answers(iQ).Options == Reference(j).Answers(iQ).Options
                        CollectSheets(i).Answers(iQ).Grade = 1;
                        break
                    else
                        CollectSheets(i).Answers(iQ).Grade = 0;
                    end
                end
            case(4) %
                s0 = strrep(CollectSheets(i).Answers(iQ).Options,' ','');
                s1 = regexp(s0,'\d+(\.\d+)?[%]?','match');
                if length(s1) ~= 1
                    prompt = sprintf('%s�ύ�ĵ�%d���ʶ������',CollectSheets(i).Name,iQ+2);
                    warning(prompt)
                    A = nan;
                else
                    A = str2double1(s1);
                end               
                for j = 1:length(Reference)
                    B = str2double1(Reference(j).Answers(iQ).Options);
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

%% ����ѧ���ɼ�¼��ģ��
% ����������
OutputOrNot = input('�����롿��[1]/��[0]���롰ѧ���ɼ�¼��ģ��Excel�ļ�����');
switch OutputOrNot
    case(0)
        fprintf('����Ϣ��ѧ���ɼ�¼��ģ�壬�������С�\n')
        return
    case(1)
        fprintf('����Ϣ��ѧ���ɼ�¼��ģ��\n')
    otherwise
        fprintf('������δ֪���������\n')
        return
end
% ����ѧ������
Raw = importfile();
% ����ѧ���ɼ���
Heads = GetVarName(cellstr([Raw{1,:}]));
Student = cell2table(Raw(2:end,:),'VariableNames',Heads);
Questions = zeros(height(Student),QNum);
Time = string;
CorrectRate = zeros(height(Student),1);
RankByTime = zeros(height(Student),1);
Grade = string;
SN_L4D = cellfun(@(x)x(end-3:end),arrayfun(@(x)convertStringsToChars(x),Student.SN,'UniformOutput',false),'UniformOutput',false);
Student = [Student,table(SN_L4D)];
% ��ѧ���ɼ����е�����˳��
for iStudent = 1:height(Student)
    idx = cellfun(@(x)(strcmp(x,Student{iStudent,'Name'})),{CollectSheets.Name});
    if ~any(idx) % ���ɼ��������������޹�ʱ
        if any(strcmp(fieldnames(CollectSheets),'SN_L4D')) % ���ɼ�����ѧ�ź���λ����
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN_L4D'})),{CollectSheets.SN_L4D});
        else % ���ɼ�����ѧ�Ų���
            idx = cellfun(@(x)(strcmp(x,Student{iStudent,'SN'})),{CollectSheets.SN});
        end
    end
    if sum(idx) == 1
        Questions(iStudent,:) = [CollectSheets(idx).Answers.Grade];
        Time(iStudent,1) = CollectSheets(idx).Time;
        CorrectRate(iStudent,1) = mean(Questions(iStudent,:),'omitnan'); % ��ȷ��
%         Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:),'omitnan')); % �β�ɼ��������ֵ
        
    elseif sum(idx) > 1 % ����ύ       
        Questions(iStudent,:) = [CollectSheets(find(idx,1,'Last')).Answers.Grade];
        Time(iStudent,1) = CollectSheets(idx).Time;
        CorrectRate(iStudent,1) = mean(Questions(iStudent,:),'omitnan'); % ��ȷ��
%         Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:),'omitnan')); % �β�ɼ��������ֵ
    else
        fprintf('�ɼ��ǼǱ��%s�����ύ�β��ͬѧ��!\n',Student{iStudent,'Name'})
        Grade(iStudent,1) = missing;
    end
end
[~,RankByTime(~ismissing(Time))] = sort(datenum(Time(~ismissing(Time))));
cGrade = arrayfun(@(x)num2str(x,"%.1f"),CorrectRate.*RankCoefficient(RankByTime),'UniformOutput',false); % �ٷ��Ƴɼ� = �÷���*����ϵ��
Grade(~ismissing(Time),1) = cGrade(~ismissing(Time));
Transcript = [Student,table(Questions),table(CorrectRate),table(RankByTime),table(Grade)];
% 
QzResult.Descript = Workbook;
QzResult.QTypeId = QTypeID;
QzResult.Transcript = Transcript;
QzResult.FileMeta = meta;
% �������
if input('�����롿�����[1]/��[0]�����ļ�QzResults.mat��') == 1
    if exist('QzResults.mat','file') == 2
        load('QzResults.mat', 'QzResults')
        QzResults = [QzResults; QzResult];
    else
        QzResults = QzResult;
    end
    save('QzResults.mat', 'QzResults')
end

%% ������
% ����״ͼ��ʾ���ογ̸���÷���
dispQzResult(QzResult)
% ��ʾ�γ̳ɼ��ϸ�ͬѧ����
listNames = QzResult.Transcript.Name(str2double(QzResult.Transcript.Grade) >= 60);
if ~isempty(listNames)
    fprintf('�β�ɼ��ϸ�ͬѧ������%s\n',strjoin(listNames,'��'))
else
    fprintf('�β�ɼ��ϸ�ͬѧ������%s\n','��')
end
% ��ʾ��߷�ͬѧ
[bestGrade,iStudent] = max(str2double(QzResult.Transcript.Grade));
fprintf('%sͬѧ����߷�%.1f\n',QzResult.Transcript.Name{iStudent},bestGrade)

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
    value(idx) = 100-40*(ranking(idx)-1)/(N-1); % ��һ���ύΪ100�����һ��Ϊ60
end