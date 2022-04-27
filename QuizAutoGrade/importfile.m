function [data,workbookFile,meta] = importfile(workbookFile, sheetName, range)
%IMPORTFILE 导入电子表格中的数据
%   DATA = IMPORTFILE(FILE) 读取名为 FILE 的 Microsoft Excel
%   电子表格文件的第一张工作表中的数据，并以元胞数组的形式返回该数据。
%
%   DATA = IMPORTFILE(FILE,SHEET) 从指定的工作表中读取。
%
%   DATA = IMPORTFILE(FILE,SHEET,RANGE) 从指定的工作表和指定的范围中读取。使用语法 'C1:C2'
%   指定范围，其中 C1 和 C2 是区域的对角。%
% 示例:
%   Untitled = importfile('第一章：绪论（课测）（收集结果）.xlsx','已恢复_Sheet1','A2:E52');
%
%   另请参阅 XLSREAD。

% 由 MATLAB 自动生成于 2020/09/16 22:55:44

%% 输入处理
% 若没指定workbookFile，则打开文件对话框
if nargin == 0 
    [workbookFile, workbookPath] = uigetfile('*.*', '选取一个Excel工作簿文件 ...', 'Multiselect', 'off');
end
fullpath = strcat(workbookPath,workbookFile);

% 如果未指定工作表，则将读取第一张工作表
if nargin == 1 || ~exist('sheetName','var')
    sheetName = 1;
end

% 如果未指定范围，则将读取所有数据
if nargin <= 2 || ~exist('range','var')
    range = '';
end

%% 导入数据
% [~, ~, data] = xlsread(fullpath, sheetName, range);
data = readcell(fullpath);
data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),data)) = {''};

idx = cellfun(@isnumeric, data) | cellfun(@ischar, data);
data(idx) = cellfun(@(x) string(x), data(idx), 'UniformOutput', false);

% 删除空行
NumRow = size(data,1);
DelRows = false(NumRow,1);
for iRow = 1:size(data,1)
    if all(cellfun(@(x)(x==""),data(iRow,:)))
        DelRows(iRow) = true;
    end
end
data(DelRows,:) = [];

% 删除空列
NumCol = size(data,2);
DelCols = false(NumCol,1);
for iCol = 1:size(data,2)
    if all(cellfun(@(x)(x==""),data(:,iCol)))
        DelCols(iCol) = true;
    end
end
data(:,DelCols) = [];

% 读取文件meta信息
meta = dir(fullpath);
