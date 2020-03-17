%% 用类似甘特图（Gantt diagram）形式直观展现同学们在线时间
% 
% by Dr. Guan, Guoqiang @ SCUT on 2020-02-26
%
clear;
%% 导入“腾讯课堂”导出的成员列表数据
Import
% 删除最后两行
ImportData((end-1):end,:) = [];
%
%% 导入人员信息表
ImportRoster
%
%% 数据提取
names = strings(height(ImportData),1);
for i = 1:height(ImportData)
    % 查找人员姓名
    Lia = ismember(PersonnelLists{:,4},ImportData{i,2});
    if Lia == 0
        names(i) = ImportData{i,1};
        NotInList = 1;
    else
        names(i) = PersonnelLists{Lia,1};
        NotInList = 0;
    end
    % 提取成员在线信息
    detail = ImportData{i,4};
    % 获得各小括号内信息
    extract_details = regexp(detail,'(?<=\()[^)]*(?=\))','match');
    periods = zeros(2,length(extract_details));
    for j = 1:length(extract_details)
        % 获得方括号内信息，即客户端系统信息
        client = extractBetween(extract_details(j),'[',']');
        % 获取起始时间
        start_idx = regexp(extract_details(j),'[');
        period = textscan(extractBetween(extract_details(j),1,start_idx-1),'%{hh:mm:ss}T','delimiter','-');
        periods(:,j) = datenum(period{1,1});       
    end
    % 绘图
    if NotInList == 0
        plot(periods,ones(size(periods))*i,'-b','LineWidth',5);
    else
        plot(periods,ones(size(periods))*i,'-r','LineWidth',5);
    end
    hold on
end
hold off
ylim([0,height(ImportData)+1])
datetick('x','HH:MM:SS')
% set(gca,'YTick',1:height(ImportData),'YTickLabel',ImportData.Nickname)
set(gca,'YTick',1:height(ImportData),'YTickLabel',names)
xlabel('时间')
ylabel('上课人员昵称')