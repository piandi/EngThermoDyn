%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: C:\Users\gqgua\Documents\Git\Attendence\学生信息汇总表.xlsx
%    工作表: QQ群成员
%
% 要扩展代码以供其他选定数据或其他电子表格使用，请生成函数来代替脚本。

% 由 MATLAB 自动生成于 2020/02/26 10:48:43

%% 导入数据
[~, ~, raw] = xlsread('C:\Users\gqgua\Documents\Git\Attendence\学生信息汇总表.xlsx','QQ群成员','A2:D59');
stringVectors = string(raw(:,[1,2,3,4]));
stringVectors(ismissing(stringVectors)) = '';

%% 创建表
PersonnelLists = table;

%% 将导入的数组分配给列变量名称
PersonnelLists.Name = stringVectors(:,1);
PersonnelLists.Nickname = stringVectors(:,2);
PersonnelLists.Group = categorical(stringVectors(:,3));
PersonnelLists.QQ = stringVectors(:,4);

%% 清除临时变量
clearvars data raw stringVectors;