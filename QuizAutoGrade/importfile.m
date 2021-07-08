function [data,workbookFile] = importfile(workbookFile, sheetName, range)
%IMPORTFILE ������ӱ���е�����
%   DATA = IMPORTFILE(FILE) ��ȡ��Ϊ FILE �� Microsoft Excel
%   ���ӱ���ļ��ĵ�һ�Ź������е����ݣ�����Ԫ���������ʽ���ظ����ݡ�
%
%   DATA = IMPORTFILE(FILE,SHEET) ��ָ���Ĺ������ж�ȡ��
%
%   DATA = IMPORTFILE(FILE,SHEET,RANGE) ��ָ���Ĺ������ָ���ķ�Χ�ж�ȡ��ʹ���﷨ 'C1:C2'
%   ָ����Χ������ C1 �� C2 ������ĶԽǡ�%
% ʾ��:
%   Untitled = importfile('��һ�£����ۣ��β⣩���ռ������.xlsx','�ѻָ�_Sheet1','A2:E52');
%
%   ������� XLSREAD��

% �� MATLAB �Զ������� 2020/09/16 22:55:44

%% ���봦��
% ��ûָ��workbookFile������ļ��Ի���
if nargin == 0 
    [workbookFile, workbookPath] = uigetfile('*.*', 'ѡȡһ��Excel�������ļ� ...', 'Multiselect', 'off');
end
fullpath = strcat(workbookPath,workbookFile);

% ���δָ���������򽫶�ȡ��һ�Ź�����
if nargin == 1 || ~exist('sheetName','var')
    sheetName = 1;
end

% ���δָ����Χ���򽫶�ȡ��������
if nargin <= 2 || ~exist('range','var')
    range = '';
end

%% ��������
[~, ~, data] = xlsread(fullpath, sheetName, range);
data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),data)) = {''};

idx = cellfun(@isnumeric, data) | cellfun(@ischar, data);
data(idx) = cellfun(@(x) string(x), data(idx), 'UniformOutput', false);

% ɾ������
NumRow = size(data,1);
DelRows = false(NumRow,1);
for iRow = 1:size(data,1)
    if all(cellfun(@(x)(x==""),data(iRow,:)))
        DelRows(iRow) = true;
    end
end
data(DelRows,:) = [];

% ɾ������
NumCol = size(data,2);
DelCols = false(NumCol,1);
for iCol = 1:size(data,2)
    if all(cellfun(@(x)(x==""),data(:,iCol)))
        DelCols(iCol) = true;
    end
end
data(:,DelCols) = [];
