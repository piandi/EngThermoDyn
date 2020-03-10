%% �����Ƹ���ͼ��Gantt diagram����ʽֱ��չ��ͬѧ������ʱ��
% 
% by Dr. Guan, Guoqiang @ SCUT on 2020-02-26
%
clear;
%% ���롰��Ѷ���á������ĳ�Ա�б�����
Import
% ɾ���������
ImportData((end-1):end,:) = [];
%
%% ������Ա��Ϣ��
ImportRoster
%
%% ������ȡ
names = strings(height(ImportData),1);
for i = 1:height(ImportData)
    % ������Ա����
    Lia = ismember(PersonnelLists{:,4},ImportData{i,2});
    if Lia == 0
        names(i) = ImportData{i,1};
        NotInList = 1;
    else
        names(i) = PersonnelLists{Lia,1};
        NotInList = 0;
    end
    % ��ȡ��Ա������Ϣ
    detail = ImportData{i,4};
    % ��ø�С��������Ϣ
    extract_details = regexp(detail,'(?<=\()[^)]*(?=\))','match');
    periods = zeros(2,length(extract_details));
    for j = 1:length(extract_details)
        % ��÷���������Ϣ�����ͻ���ϵͳ��Ϣ
        client = extractBetween(extract_details(j),'[',']');
        % ��ȡ��ʼʱ��
        start_idx = regexp(extract_details(j),'[');
        period = textscan(extractBetween(extract_details(j),1,start_idx-1),'%{hh:mm:ss}T','delimiter','-');
        periods(:,j) = datenum(period{1,1});       
    end
    % ��ͼ
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
xlabel('ʱ��')
ylabel('�Ͽ���Ա�ǳ�')