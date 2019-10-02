function [SOUT, Ready] = StagnantProp(SIN, Method)
%% 计算滞止性质
%
% 输入参数
% SIN - (struct scalar) .Name 工质名
%                       .Mass 质量 [kg]
%                       .Velocity 速度 [m/s]
%                       .Pressure 压力 [Pa]
%                       .Temperature 温度 [K]
%                       .SpecVolume 比体积 [m3/kg]
%                       .kappa 绝热指数
%                       .SpecEnthalpy 比焓 [J/kg]
%                       .cp 恒压比热 [J/kg-K]
%                       .cv 恒容比热 [J/kg-K]
%                       .Rg 质量气体常数 [J/kg-K]
%                       .Mw 分子量 [mol/kg]
% Method - (struct scalar) 计算方法
%
% 输出参数
% SOUT   - (struct scalar) same struct as SIN
% Ready  - (integer scalar) Complete successfully
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/9/30
%

%% 初始化
SOUT = SIN; 
Ready = 0;
% 输入参数初始化
switch nargin
    case 1
        % 根据工质名称判定是否按理想气体计算相关性质
        Method.Property = SetMethod(SIN);
    case 2
        
    otherwise
        Setlog('[Abort] Incorrect number of input arguments in StagnantProp()!');
        Ready = 0;
        return
end
%% 计算滞止性质
Setlog('Calculate the stagnant properties.');
switch Method.Property
    case 0 % 按理想气体计算
        % 检查通用气体常数是否存在
        if ~isfield(SOUT, 'Rg') && isfield(SOUT, 'Mw') % 通过通用气体常数R计算Rg
            SOUT.Rg = 8.3145/SOUT.Mw;
            Setlog('Calculate Rg from generalized gas constant.');          
        end
        % 完成绝热指数、恒压比热、恒容比热和质量气体常数的计算
        [SOUT, Ready] = CalcKCCR(SIN);
        if Ready
            SOUT.Mw = 8.3145/SOUT.Rg; % 若Mw不存在，通过R和Rg计算Mw
            Setlog('Calculate Mw from Rg.');
        else
            Setlog('[Abort] Required parameters are absent!');
            return
        end
        % 计算滞止温度、压力
        if isfield(SOUT, 'Velocity')
            Ready = 1;
        else
            Ready = 1;
            SOUT.Velocity = 0;
            Setlog('[Warning] Velocity is unknown and default 0 is used!');  
        end
        if isfield(SOUT, 'Temperature')
            Ready = 1;
        else
            Ready = 1;
            SOUT.Temperature = 273.15+25;
            Setlog('[Warning] Temperature is unknown and default 298.15K is used!'); 
        end
        if SOUT.cp ~= 0 && Ready
            kappa = SOUT.kappa;
            Rg = SOUT.Rg;
            cf = SOUT.Velocity;
            cp = SOUT.cp;
            T = SOUT.Temperature;
            T0 = cf^2/2/cp+T;
            p = SOUT.Pressure;
            p0 = p*(T/T0)^(kappa/(1-kappa));
            v0 = Rg*T0/p0;
            % 输出滞止性质
            stagProp.T = T0;
            stagProp.p = p0;
            stagProp.v = v0;
            SOUT.StagnantProp = stagProp;
        else
            setlog('[Abort] Stagnant temperature calculation stopped due to cp = 0！'); 
            return
        end
    case 1 % 用水蒸气程序计算
        Setlog('Use XSteam() to calculate the stagnant properties'); 
    otherwise
        Setlog('[Warning] Skip the properties calculation'); 
end
Ready = 1;
