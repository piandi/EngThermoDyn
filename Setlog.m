function [log_flag] = Setlog(str_message, opt)
%% 将字段信息写入log
%
% Dependancy: 
% logs - (global struct array)
%
% Input arguments
% str_message - (str)
% opt         - (integer scaler)
%
% Output arguments
% log_flag    - (integer scaler)
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/10/1
%
%%
% 输入变量初始化
switch nargin
    case 1
        opt = 1;
        log_flag = 0;
    case 2
    otherwise
        log_flag = -1;
        return
end
% 初始化
global logs
msg_idx = length(logs); % 设置logs当前位置为最后一个记录
stamp_format = 'YYYY-mm-dd HH:MM:SS.FFF'; % 时间戳格式
switch opt
    case 1 % 将输入字段信息写入logs数组
        msg_idx = msg_idx+1;
        logs(msg_idx).stamp = datestr(now, stamp_format);
        logs(msg_idx).message = str_message;
        log_flag = 1;
    case 2 % 屏幕显示logs
        for i = 1:msg_idx
            fprintf('%s - %s \n', logs(i).stamp, logs(i).message);
        end
end