%% Pre-run script
clear;
% �����Ҫ���õĵ������ļ��Ƿ����
chk_filename = {'XSteam'};
result_chk = ChkFiles(chk_filename);
if all(result_chk)
    fprintf('All needed files existed\n');
else
    fprintf('STOP due to one of needed files NOT existed\n');
    return
end