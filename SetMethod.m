function [method_flag] = SetMethod(SIN)
%% ���ݹ��������ж��Ƿ�������������������
%
% by Dr. GUAN Guoqiang @ SCUT on 2019-10-1
%
% ��ȡ�������»��ߺ���ֶ�
delimiter_idx = strfind(SIN.Name, '_');
if isempty(delimiter_idx)
    identifier = strtrim(SIN.Name); % ȥ���ֶ�ǰ��Ŀո�
    if strcmpi(identifier, 'steam')
        method_flag = 1; % ��ˮ�������ʳ������
        Setlog('Set the working substance as steam.'); 
    else
        method_flag = -1; 
        Setlog('[Warning] Unknown working substance!'); 
    end
else
    % ��ȡ�ָ������ʶ���ֶ�
    identifier = strtrim(SIN.Name((delimiter_idx+1):end)); % ȥ���ֶ�ǰ��Ŀո�
    if strcmpi(identifier, 'PG')
        method_flag = 0; % �������������
        Setlog('Set the working substance as perfect gas.'); 
    else
        method_flag = -2;
        Setlog('[Warning] Unknown identifier in the name of working substance!'); 
    end
end