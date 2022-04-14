classdef MaterialPG < handle
    % MaterialPG 工质物性
    
    properties
        Rg = missing;
        cv = missing;
        cp = missing;
        kappa = missing;
        status = '未指定';
    end
    
    methods
        function obj = MaterialPG(propName1,propValue1,propName2,propValue2)
            % 通过指定输入参数构造此类的实例
            if nargin == 4
                propList = {'Rg','cp','cv','kappa'};
                if ~any(strcmp(propName1,propList))
                    error('构造MaterialPG类时指定的属性%s不存在！',propName1)
                end
                if ~any(strcmp(propName2,propList))
                    error('构造MaterialPG类时指定的属性%s不存在！',propName2)
                end
                obj.(propName1) = propValue1;
                obj.(propName2) = propValue2;
                FillProps(obj);
            end
        end
        
        function set.Rg(obj,inputArg)
            obj.Rg = inputArg;
            FillProps(obj);
        end
        
        function set.cv(obj,inputArg)
            obj.cv = inputArg;
            FillProps(obj);
        end
        
        function set.cp(obj,inputArg)
            obj.cp = inputArg;
            FillProps(obj);
        end
        
        function set.kappa(obj,inputArg)
            obj.kappa = inputArg;
            FillProps(obj);
        end        
        
    end
    
    methods(Access = 'private')
        function FillProps(obj)
            % 若已知2个物性参数，则计算其余参数
            syms x1 x2 x3 x4
            x = [x1 x2 x3 x4];
            propNames = {'Rg','cv','cp','kappa'};
            idx = cellfun(@(x)~ismissing(obj.(x)),propNames); % 找出已赋值的属性
            if sum(idx) == 2
                xVal = cellfun(@(x)(obj.(x)),propNames(idx));
                eq1 = x1 == x3-x2;
                eq2 = x4 == x3/x2;
                sol = solve([subs(eq1,x(idx),xVal),subs(eq2,x(idx),xVal)]);
                result = eval(cellfun(@(x)sol.(x),fieldnames(sol)));
                pos = find(~idx);
                for i = 1:length(pos)
                    obj.(propNames{pos(i)}) = result(i);
                end
                obj.status = '给定';
            end
        end

    end
end

