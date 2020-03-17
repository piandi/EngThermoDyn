%% Pre-run script
clear;
% 检查需要调用的第三方文件是否存在
chk_filename = {'XSteam'};
result_chk = ChkFiles(chk_filename);
if all(result_chk)
    fprintf('All needed files existed\n');
else
    fprintf('STOP due to one of needed files NOT existed\n');
    return
end