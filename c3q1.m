%% �ܱ����׳�������ģ��
% ˵����
% �ó��������ݻ�Ϊ10L�ĸ�����ƿ���е��³�����ÿ�γ�����Ϊ0.1L�ҳ��������״���ڲ���
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-10
%
clear;
% ����ϵͳ���Գ���ǰ��ƿ�����彨���տ�ϵ
% ������ʣ��ٶ�����Ϊ�������壬��m = pV/Rg/T
% �������̣�����ƿ�в����������� + ����������� = ����ǰ��ƿ����������
%          m(i+1) + me(i+1) = m(i)
%          ����ǰ���ƿ�������������������¶Ⱥ����峣������
%          p(i)V = p(i+1)(V+Ve)
%
% ��ʼ����
V = 10; Ve = 0.1;
p(1) = 1;
i = 1;
% ����
while p(i) > 0.5
    p(i+1) = p(i)*V/(V+Ve); % ÿ�γ��������ƿѹ��
    i = i+1;
end
% ���
fprintf('Number of required suction: %d\n',i-1)
plot(p,'bo')
xlabel('Number of required suction');
ylabel('Pressure/Initial Pressure');