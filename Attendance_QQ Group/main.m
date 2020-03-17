%% 从QQ群中聊天记录中提取特定的上课打卡记录
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020/03/09
%
clear;
%% 将QQ群聊天记录txt文件中的数据以字段向量形式导入MATLAB工作空间
import_log;
% Delete the first six rows
QQGroup_log(1:6) = [];
%
%% 顺序扫描工作空间文件，获取有效数据记录
% 初始化
line_num = length(QQGroup_log);
log_sn = 0;
i = 1;
while i<(line_num)
    % 扫描第i行
    content = textscan(QQGroup_log(i),'%s');
    content = content{:};    
    if length(content) == 3 && length(content{1}) == 10 && length(content{2}) == 8
        % 标识该行为header
        log_sn = log_sn+1;
        dates(log_sn) = textscan(content{1},'%D');
        times(log_sn) = textscan(content{2},'%D');
        users(log_sn) = textscan(content{3},'%s');
        user_infocell = users(log_sn);
        user_infocell = user_infocell{:};
        chk_bracket = strfind(user_infocell,'(');
        if isempty(chk_bracket{:})
            fprintf('No bracket found in line %d: %s\n',i, user_infocell{:})
        else
            BracketNumber = extractBetween(user_infocell,'(',')');
            QQNum(log_sn) = BracketNumber(end);
        end
    else
        contents(log_sn) = cellstr(QQGroup_log(i));
    end
    i = i+1;
end
contents(log_sn) = cellstr(QQGroup_log(i));
dates = dates'; times = times'; users = users'; contents = contents'; QQNum = QQNum';
log_tab = table(dates,times,QQNum, users,contents);