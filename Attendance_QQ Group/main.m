%% ��QQȺ�������¼����ȡ�ض����Ͽδ򿨼�¼
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020/03/09
%
clear;
%% ��QQȺ�����¼txt�ļ��е��������ֶ�������ʽ����MATLAB�����ռ�
import_log;
% Delete the first six rows
QQGroup_log(1:6) = [];
%
%% ˳��ɨ�蹤���ռ��ļ�����ȡ��Ч���ݼ�¼
% ��ʼ��
line_num = length(QQGroup_log);
log_sn = 0;
i = 1;
while i<(line_num)
    % ɨ���i��
    content = textscan(QQGroup_log(i),'%s');
    content = content{:};
    % debug use only
%     if i == 2627
%         i
%     end
    if (length(content{1}) == 10) && (content{1}(5) == content{1}(8))
        % ��ʶ����Ϊheader
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

%% ��ȡָ�����ڵļ�¼
% ������ȡ���ݵ�����
d = uidatepicker('Value',datetime('today'));
fprintf('Press any key to continue')
pause
setdate = d.Value; % datetime(2020,3,31);
delete(d)
% ��ȡ��¼
extract_log = log_tab(dates == setdate,:);

%% ��ȡ�Ͽδ򿨼�¼
% �Ͽ���
flag_start = '110';
% ��ȡ�Ͽδ����¼
idx_start = strcmp(extract_log.contents, flag_start);
user1 = extract_log.users(idx_start);
user1 = [user1{:}]';
QQNum = extract_log.QQNum(idx_start);
Start = extract_log.times(idx_start);
% ����ظ���
[~,idx_start_unique] = unique(user1);
user1 = user1(idx_start_unique);
QQNum = QQNum(idx_start_unique);
Start = Start(idx_start_unique);
% �г�ѧ��������ѧ��
list1 = table(QQNum,user1,Start);

%% ��ȡ�¿δ򿨼�¼
% �¿���
flag_end = '119';
% ��ȡ�¿δ����¼
idx_end = strcmp(extract_log.contents, flag_end);
user2 = extract_log.users(idx_end);
user2 = [user2{:}]';
QQNum = extract_log.QQNum(idx_end);
End = extract_log.times(idx_end);
% ����ظ���
[~,idx_end_unique] = unique(user2);
user2 = user2(idx_end_unique);
QQNum = QQNum(idx_end_unique);
End = End(idx_end_unique);
% �г�ѧ��������ѧ��
list2 = table(QQNum,user2,End);

%% ����¿δ򿨼�¼
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
    % �����޿�ʼ��¼��ѧ��
    QQNum = QQNum(nostart_idx);
    user1 = user2(nostart_idx); 
    Start = End(nostart_idx);
    End = End(nostart_idx);
    Remarks = ones(size(QQNum))*2;
    attendance_list = [attendance_list;table(QQNum,user1,Start,End,Remarks)];
end
%% ����򿨼�¼
% ��ͼ
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
xlabel(['ʱ��',' | ',datestr(setdate)])
ylabel('�Ͽ���Ա�ǳ�')
