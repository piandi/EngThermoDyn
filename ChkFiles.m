function [ ExistFlags ] = ChkFiles( filenames )
% �����Ҫ���õĵ������ļ��Ƿ����
% ���룺filenames - �����ļ�����������չ����������ļ���cell���鹹���л�������
% �����ExistFlags - ��Ӧ�ļ��������ı�ǣ�����Ϊ1��������Ϊ0
ExistFlags = zeros(size(filenames));
% ��ȡ��������
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

