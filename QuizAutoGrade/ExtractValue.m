%% 从字段或字符串中提取其中的数值（正负整数、小数和百分数）
%
% by Dr. Guan Guoqiang @ SCUT on 2022-04-28

function outVal = ExtractValue(strVal)
% 检查输入参数
if ~exist('strVal','var')
    error('函数ExtractValue()应有输入参数strVal')
else
    switch class(strVal)
        case('char')
            s0 = strVal;
        case('string')
            s0 = char(strVal);
        otherwise
            error('函数ExtractValue()输入参数strVal数据类型错误')
    end
end
% 删除字符中的空格和英文逗号
s1 = s0(regexp(s0,'[^,\s]')); 
% 提取字符中数值（正负整数、小数和百分数）
s2 = regexp(s1,'(\-|\+)?\d+(\.\d+)?%?','match');
if length(s2) ~= 1
    warning('函数ExtractValue()无法从strVal=“%s”提取数值',s0);
    outVal = nan;
else
    s3 = s2{1};
    if isequal(s3(end),'%')
        outVal = str2double(s3(1:end-1))/100;
    else
        outVal = str2double(s3);
    end
end