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
    % debug use only
%     if i == 2627
%         i
%     end
    if (length(content{1}) == 10) && (content{1}(5) == content{1}(8))
        % 标识该行为header
        log_sn = log_sn+1;
        dates(log_sn) = textscan(content{1},'%D');
        times(log_sn) = textscan(content{2},'%D');
        users(log_sn) = textscan([content{3:end}],'%s');
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
% convert cell array of datetime to array of datetime
dates = [dates{:}]'; times = [times{:}]'; 
users = users'; contents = contents'; QQNum = QQNum';
log_tab = table(dates,times,QQNum, users,contents);

%% 提取指定日期的记录
% 输入提取数据的日期
d = uidatepicker('Value',datetime('today'));
fprintf('Press any key to continue')
pause
setdate = d.Value; % datetime(2020,3,31);
delete(d)
% 提取记录
extract_log = log_tab(dates == setdate,:);

%% 提取上课打卡记录
% 上课码
flag_start = '110';
% 提取上课打码记录
idx_start = strcmp(extract_log.contents, flag_start);
user1 = extract_log.users(idx_start);
user1 = [user1{:}]';
QQNum = extract_log.QQNum(idx_start);
Start = extract_log.times(idx_start);
% 检查重复打卡
[~,idx_start_unique] = unique(user1);
user1 = user1(idx_start_unique);
QQNum = QQNum(idx_start_unique);
Start = Start(idx_start_unique);
% 列出学生姓名和学号
list1 = table(QQNum,user1,Start);

%% 提取下课打卡记录
% 下课码
flag_end = '119';
% 提取下课打码记录
idx_end = strcmp(extract_log.contents, flag_end);
user2 = extract_log.users(idx_end);
user2 = [user2{:}]';
QQNum = extract_log.QQNum(idx_end);
End = extract_log.times(idx_end);
% 检查重复打卡
[~,idx_end_unique] = unique(user2);
user2 = user2(idx_end_unique);
QQNum = QQNum(idx_end_unique);
End = End(idx_end_unique);
% 列出学生姓名和学号
list2 = table(QQNum,user2,End);

%% 添加下课打卡记录
nostart_idx = zeros(size(user2));
Remarks = zeros(size(user1));
EndTime = Start;
for i = 1:height(list1)
    get_idx = strcmp(user2, user1{i});
    if all(get_idx == 0)
        fprintf('Cannot find the finish flag for user: %s\n',list1.user1{i})
        Remarks(i) = 1;
    else
        EndTime(i) = list2.End(get_idx);
    end
    nostart_idx = nostart_idx+get_idx;
end
End = EndTime;
attendance_list = [list1,table(End,Remarks)]; 
if sum(nostart_idx) < length(user2)
    nostart_idx = ~logical(nostart_idx);
    fprintf('Cannot find the start flag for user: %s\n',list2.user2{nostart_idx})
    % 增列无开始记录的学生
    QQNum = QQNum(nostart_idx);
    user1 = user2(nostart_idx); 
    Start = End(nostart_idx);
    End = End(nostart_idx);
    Remarks = ones(size(QQNum))*2;
    attendance_list = [attendance_list;table(QQNum,user1,Start,End,Remarks)];
end
%% 输出打卡记录
% 绘图
for i = 1:height(attendance_list)
    switch attendance_list.Remarks(i) 
        case(0)
            period = [attendance_list.Start(i);attendance_list.End(i)];
            plot(period,ones(size(period))*i,'-b','LineWidth',5)
        case(1)
            plot(attendance_list.Start(i),i,'>r')
        case(2)
            plot(attendance_list.End(i),i,'<r')
    end
    hold on
end
hold off
ylim([0,height(attendance_list)+1])
datetick('x','HH:MM:SS')
% set(gca,'YTick',1:height(ImportData),'YTickLabel',ImportData.Nickname)
set(gca,'YTick',1:height(attendance_list),'YTickLabel',cellfun(@string,attendance_list.user1))
xlabel(['时间',' | ',datestr(setdate)])
ylabel('上课人员昵称')
