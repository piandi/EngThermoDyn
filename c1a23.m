%% 习题1-23
%% 计算循环1231做功量
clear;
syms Rg Ta Tb p p1 v v1 v2 v3;
assume(v1<v2 & v1>0);
% 过程1-2为等温变化，其做功量为
w12 = int(Rg*Ta/v, v, v1, v2);
% 由于v1 = v3且v3 = v2*Tb/Ta，故v1 = v2*Tb/Ta
w12a = subs(w12, v1, v3);
w12b = subs(w12a, v3, Tb/Ta*v2);
% 化简得
w12c = simplify(w12b):
% 过程2-3为等压过程，其做功量为
w23 = int(Rg*Ta/v2, v, v2 ,v3);
% 化简得
w23a = expand(w23);
% 由于v3 = v2*Tb/Ta，故v1 = v2*Tb/Ta
w23b = subs(w23a, v3, Tb/Ta*v2);
% 过程3-1为等容过程，其做功量为
w31 = int(p, v, v1, v1);
% 过程1-2-3-1做功量为
w1231 = w12c+w23b+w31;
%% 同理计算循环4564做功量
syms p p4 v v4 v5 v6;
assume(v4<v5 & v4>0);
w45 = int(Rg*Ta/v, v, v4, v5);
w45a = simplify(subs(w45, v4, Tb/Ta*v5));
w56 = int(Rg*Ta/v5, v, v5 ,v6);
w56a = subs(expand(w56), v6, Tb/Ta*v5);
w64 = int(p, v, v4, v4);
w4564 = w45a+w56a+w64;
%% 比较两个过程的做功量
if isequal(w1231, w4564)
    results = ' equal';
else
    results = ' not equal';
end
str1 = 'The work of cycle 1-2-3-1 is ';
str2 = ' to that of cycle 4-5-6-4.\n';
fprintf(strcat(str1, results, str2))