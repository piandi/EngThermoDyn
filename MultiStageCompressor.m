%% �༶ѹ���ܹ��ļ��㺯��
%
% ���ò���˵��
% pi       - (i, double array) ����ѹ����Ĺ���ѹ������
% material - (i, struct array(2)) ������̬��������
% process  - (i, struct array(NStage)) ����ѹ����������
% wval     - (o, double array) ����ѹ���Ĺ�������
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function [wval,pval,vval,Tval] = MultiStageCompressor(pi, materials, processes)
%% ��ʼ��
% ͨ��pi����������ѹ������
MStage = length(pi)+1;
NState = length(pi)+2;
%
% syms p v T
% �ٶ�����Ϊ��������
Rg = materials(1).Rg; 
% eos = p*v == Rg*T;
% 
wval = zeros(MStage,1);
pval = zeros(NState,1);
vval = zeros(NState,1);
Tval = zeros(NState,1);
% ������֪����
% ��̬
pval(1) = materials(1).p; Tval(1) = materials(1).T; % ���ù��ʵ�λ����ͬ��
% �м�̬
pval(2:NState-1) = pi;
% ��̬
pval(NState) = materials(2).p;

%% ˳�α��״̬������   
% ״̬1���ʣ����ʳ�̬��
% vval(1) = eval(subs(solve(eos, v), [p T], [pval(1) Tval(1)]));
vval(1) = Rg*Tval(1)/pval(1);
for i = 1:MStage
    % ѹ��ǰ״̬
    p1 = pval(i); v1 = vval(i); T1 = Tval(i);
    % ѹ����״̬
    p2 = pval(i+1);
    % ���ʴ�״̬1ͨ�������̣�n=1.3���仯��״̬2
    n = processes(i).n;
%     syms dlnp dlnv
%     eq1 = dlnp+n*dlnv == 0;
%     eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
%     v2 = subs(solve(eq1a, v), p, p2);
    v2 = v1*exp((log(p1) - log(p2))/n);
%     T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
    T2 = p2*v2/Rg;
    Tval(i+1) = T2;
    % ѹ�����̹���
%     wval(i) = -eval(int(solve(eq1a, v), p, p1, p2));
    w = @(p)((p1./p).^(1/n)*v1);
    wval(i) = integral(w, p1, p2);    
    % �����ѹ��ȴ
%     v2 = subs(solve(eos, v), [p T], [p2 T2]);
    v2 = Rg*Tval(1)/p2;
    vval(i+1) = v2;    
end

end