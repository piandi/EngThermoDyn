%% 导入文本文件中的数据。
% 用于从以下文本文件导入数据的脚本:
%
%    C:\Users\gqgua\Documents\Git\Attendence\成员列表(2020年02月25日09时34分至2020年02月25日11时56分).csv
%
% 要将代码扩展到其他选定数据或其他文本文件，请生成函数来代替脚本。

% 由 MATLAB 自动生成于 2020/02/26 05:34:06

[File, PathName] = uigetfile('*.*', 'Select file ...', 'Multiselect', 'off');
if isequal(File,0)
    disp('User selected cancel');
else
    filename = [PathName,File];
    disp(['User selected ',filename]);
end

%% 初始化变量。
delimiter = ',';
startRow = 2;

%% 将数据列作为文本读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%s%s%s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false);

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值文本的列内容转换为数值。
% 将非数值文本替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

% 将输入元胞数组中的文本转换为数值。已将非数值文本替换为 NaN。
rawData = dataArray{3};
for row=1:size(rawData, 1)
    % 创建正则表达式以检测并删除非数值前缀和后缀。
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData(row), regexstr, 'names');
        numbers = result.numbers;
        
        % 在非千位位置中检测到逗号。
        invalidThousandsSeparator = false;
        if numbers.contains(',')
            thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
            if isempty(regexp(numbers, thousandsRegExp, 'once'))
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % 将数值文本转换为数值。
        if ~invalidThousandsSeparator
            numbers = textscan(char(strrep(numbers, ',', '')), '%f');
            numericData(row, 3) = numbers{1};
            raw{row, 3} = numbers{1};
        end
    catch
        raw{row, 3} = rawData{row};
    end
end


%% 将数据拆分为数值和字符串列。
rawNumericColumns = raw(:, 3);
rawStringColumns = string(raw(:, [1,2,4]));


%% 将非数值元胞替换为 NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % 查找非数值元胞
rawNumericColumns(R) = {NaN}; % 替换非数值元胞

%% 创建输出变量
ImportData = table;
ImportData.Nickname = rawStringColumns(:, 1);
ImportData.QQ = rawStringColumns(:, 2);
ImportData.Duration = cell2mat(rawNumericColumns(:, 1));
ImportData.Details = rawStringColumns(:, 3);

%% 清除临时变量
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R;