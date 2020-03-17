function [method_flag] = SetMethod(SIN)
%% 根据工质名称判定是否按理想气体计算相关性质
%
% by Dr. GUAN Guoqiang @ SCUT on 2019-10-1
%
% 获取工质名下划线后的字段
delimiter_idx = strfind(SIN.Name, '_');
if isempty(delimiter_idx)
    identifier = strtrim(SIN.Name); % 去掉字段前后的空格
    if strcmpi(identifier, 'steam')
        method_flag = 1; % 按水蒸气性质程序计算
        Setlog('Set the working substance as steam.'); 
    else
        method_flag = -1; 
        Setlog('[Warning] Unknown working substance!'); 
    end
else
    % 获取分隔符后的识别字段
    identifier = strtrim(SIN.Name((delimiter_idx+1):end)); % 去掉字段前后的空格
    if strcmpi(identifier, 'PG')
        method_flag = 0; % 按理想气体计算
        Setlog('Set the working substance as perfect gas.'); 
    else
        method_flag = -2;
        Setlog('[Warning] Unknown identifier in the name of working substance!'); 
    end
end