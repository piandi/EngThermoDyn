%% �����ı��ļ��е����ݡ�
% ���ڴ������ı��ļ��������ݵĽű�:
%
%    C:\Users\gqgua\OneDrive\Documents\Enginneering Thermodynamics\2018��\QQȺ��¼\��������ѧ��SCUT.ChE��.txt
%
% Ҫ��������չ������ѡ�����ݻ������ı��ļ��������ɺ���������ű���

% �� MATLAB �Զ������� 2020/03/09 11:21:30

%% ��ʼ��������
filename = '��������ѧ��SCUT.ChE��.txt';
delimiter = {''};

%% ÿ���ı��еĸ�ʽ:
%   ��1: �ı� (%s)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%s%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r','n','UTF-8');
% ���� BOM (�ֽ�˳����)��
fseek(fileID, 3, 'bof');

%% ���ݸ�ʽ��ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% ����������������б�������
QQGroup_log = dataArray{:, 1};


%% �����ʱ����
clearvars filename delimiter formatSpec fileID dataArray ans;