%% ������ӱ���е�����
% ���ڴ����µ��ӱ�������ݵĽű�:
%
%    ������: C:\Users\gqgua\Documents\Git\Attendence\ѧ����Ϣ���ܱ�.xlsx
%    ������: QQȺ��Ա
%
% Ҫ��չ�����Թ�����ѡ�����ݻ��������ӱ��ʹ�ã������ɺ���������ű���

% �� MATLAB �Զ������� 2020/02/26 10:48:43

%% ��������
[~, ~, raw] = xlsread('C:\Users\gqgua\Documents\Git\Attendence\ѧ����Ϣ���ܱ�.xlsx','QQȺ��Ա','A2:D59');
stringVectors = string(raw(:,[1,2,3,4]));
stringVectors(ismissing(stringVectors)) = '';

%% ������
PersonnelLists = table;

%% ����������������б�������
PersonnelLists.Name = stringVectors(:,1);
PersonnelLists.Nickname = stringVectors(:,2);
PersonnelLists.Group = categorical(stringVectors(:,3));
PersonnelLists.QQ = stringVectors(:,4);

%% �����ʱ����
clearvars data raw stringVectors;