%% �Զ����Ŀ��ò���
% �ܰѹع�ǿ�ύ�Ķ�δ𰸾���Ϊ�ο��𰸣�ѧ���ύ�Ľ������һ�δ�һ�¼��÷�
% ѧ���ύ��δ�ʱ��������Excel�����������һ��Ϊ��ֱ�׼
%
% by Dr. Guan Guoqiang
%
clear all

%% �û�����γ��������
QNum = input('�����롿������β���Ŀ����');
fprintf('�����롿������β�������ʹ��� \n 1-��ѡ�� \n 2-������ѡ���� \n 3-�����⣨��Ҫ��ȷһ�£� \n 4-�����⣨������5%%ƫ�\n')
QTypeID = zeros(QNum,1);
for iQ = 1:QNum
    prompt = sprintf('�����롿��%d������ʹ���Ϊ��',iQ);
    QTypeID(iQ) = input(prompt);
end

%% ����β����ռ����ӱ�
[Data,Workbook] = importfile();
% ��ȡ��ͷ
Heads = Data(1,:);
Data(1,:) = [];
% ��ȡ��Ϣ��
InfoCols = cellfun(@(x)(contains(x,'�ύ��')|contains(x,'�ύʱ��')|contains(x,'����')|contains(x,'ѧ��')),Heads);
% ��ȡ�β���Ŀ��
QuestionCols = ~InfoCols;
% ����û�����Ŀβ�����Ŀ���ռ����еļ�¼�Ƿ�һ��
if sum(QuestionCols) == QNum
    fprintf('����Ϣ���ռ����пβ���Ŀ������ָ��һ�¡�\n')
else
    fprintf('�������û�����Ŀβ�����Ŀ���ռ����еļ�¼��һ�£�\n')
    return
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
    Raws = Data(i,QuestionCols);
    for iQ = 1:QNum
        Answers(iQ).Raw = Raws{iQ};
        Answers(iQ).Options = strsplit(Answers(iQ).Raw,', ');
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
Grade = string;
SN_L4D = cellfun(@(x)x(end-3:end),arrayfun(@(x)convertStringsToChars(x),Student.SN,'UniformOutput',false),'UniformOutput',false);
Student = [Student,table(SN_L4D)];
% ��ѧ���ɼ����е�����˳��
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
    elseif sum(idx) > 1 % ����ύ       
        Questions(iStudent,:) = [CollectSheets(find(idx,1,'Last')).Answers.Grade];
        Grade(iStudent,1) = ConvertGrade(mean(Questions(iStudent,:)));
    end
end
Transcript = [Student,table(Questions),table(Grade)];
% 
QzResult.Descript = Workbook;
QzResult.QTypeId = QTypeID;
QzResult.Transcript = Transcript;
% �������
if input('�����롿�����[1]/��[0]�����ļ�QzResults.mat��') == 1
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

%% ������
dispQzResult(QzResult)