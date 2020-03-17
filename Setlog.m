function [log_flag] = Setlog(str_message, opt)
%% ���ֶ���Ϣд��log
%
% Dependancy: 
% logs - (global struct array)
%
% Input arguments
% str_message - (str)
% opt         - (integer scaler) 1: save the current strings into logs
%                                2: display all logs
%                                3: 1 + display the current strings on cmd
%                                windows
%
% Output arguments
% log_flag    - (integer scaler)
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/10/1
%
%%
% ���������ʼ��
switch nargin
    case 1
        opt = 1;
        log_flag = 0;
    case 2
    otherwise
        log_flag = -1;
        return
end
% ��ʼ��
global logs
msg_idx = length(logs); % ����logs��ǰλ��Ϊ���һ����¼
stamp_format = 'YYYY-mm-dd HH:MM:SS.FFF'; % ʱ�����ʽ
switch opt
    case 1 % �������ֶ���Ϣд��logs����
        msg_idx = msg_idx+1;
        logs(msg_idx).stamp = datestr(now, stamp_format);
        logs(msg_idx).message = str_message;
        log_flag = 1;
    case 2 % ��Ļ��ʾlogs
        for i = 1:msg_idx
            fprintf('%s - %s \n', logs(i).stamp, logs(i).message);
        end
    case 3 % �������ֶ���Ϣд��logs���鲢�������д�����ʾ��ǰ�ֶ���Ϣ
        msg_idx = msg_idx+1;
        logs(msg_idx).stamp = datestr(now, stamp_format);
        logs(msg_idx).message = str_message;
        log_flag = 1;  
        fprintf('%s - %s \n', logs(msg_idx).stamp, logs(msg_idx).message);
end