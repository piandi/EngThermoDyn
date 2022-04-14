classdef StatePG < handle
    % StatePG应用理想气体状态方程确定p-v-T
    %   已知p-v-T中2个变量，计算另一变量
    
    properties
        Material = MaterialPG
        p % [kPa]
        v % [m3/kg]
        T % [K]
        status = ''
    end
    
    methods
        function obj = StatePG(propName1,propValue1,propName2,propValue2)
            % 输入pvT
            if nargin == 4
                propList = {'p','v','T'};
                if ~any(strcmp(propName1,propList))
                    error('构造StatePG类时指定的属性%s不存在！',propName1)
                end
                if ~any(strcmp(propName2,propList))
                    error('构造StatePG类时指定的属性%s不存在！',propName2)
                end
                obj.(propName1) = propValue1;
                obj.(propName2) = propValue2;
                CalcVar(obj);
            end
        end
        
        function set.p(obj,inputArg)
            DelProp(obj,'p')
            % 设定压力[kPa]           
            obj.p = inputArg;
            if ~isempty(inputArg)
                CalcVar(obj)
            end
        end

        function set.v(obj,inputArg)
            DelProp(obj,'v')
            % 设定比体积[m3/kg]
            obj.v = inputArg;
            if ~isempty(inputArg)
                CalcVar(obj)
            end
        end
        
        function set.T(obj,inputArg)
            DelProp(obj,'T')
            % 设定温度[K]
            obj.T = inputArg;
            if ~isempty(inputArg)
                CalcVar(obj)
            end
        end
        
    end
        
    methods (Access = 'private')

        function DelProp(obj,currentVarChar)
            % 根据obj.status记录删除上次计算的属性值
            if ~isempty(obj.status)
                calcVarChar = obj.status(1);
                if ~isequal(calcVarChar,currentVarChar)
                    obj.(calcVarChar) = [];
                end
            end
        end
        
        function [nKnown,calcVarChars] = CountKnown(obj)
            if ~isequal(obj.Material.status,'给定')
                return
            end
            propNames = {'p','v','T'};
            idx = cellfun(@(x)~isempty(obj.(x)),propNames); % 找出已赋值属性
            nKnown = sum(idx);
            calcVarChars = propNames(~idx);
        end
        
        function CalcVar(obj)
            if ~isequal(obj.Material.status,'给定')
                return
            end
            [nKnown,calcVarChars] = CountKnown(obj);
            if nKnown == 2 && length(calcVarChars) == 1
                switch calcVarChars{:}
                    case('p')
                        obj.p = obj.Material.Rg*obj.T/obj.v;
                    case('v')
                        obj.v = obj.Material.Rg*obj.T/obj.p;
                    case('T')
                        obj.T = obj.p*obj.v/obj.Material.Rg;
                end
                obj.status = sprintf('%s已计算',calcVarChars{:});
            end
        end
        
        
    end
end

