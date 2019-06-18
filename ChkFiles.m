function [ ExistFlags ] = ChkFiles( filenames )
% 检查需要调用的第三方文件是否存在
% 输入：filenames - 检查的文件名（无需扩展名），多个文件用cell数组构造行或列向量
% 输出：ExistFlags - 相应文件存在与否的标记，存在为1，不存在为0
ExistFlags = zeros(size(filenames));
% 获取向量长度
filenum = max(size(filenames));
fprintf('The following files have been checked for existence ...\n');
for i=1:filenum
    fprintf('%s - ', filenames{i});
    if exist(filenames{i}, 'file') == 2
        fprintf('Okey\n');
        ExistFlags(i) = 1;
    else
        fprintf('File not exist\n');
    end
end

