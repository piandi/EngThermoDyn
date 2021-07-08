function VarNameArray = GetVarName(NameCellArray)
VarNameArray = cell(size(NameCellArray));
if iscell(NameCellArray)
    NumName = length(NameCellArray);
    for iName = 1:NumName
        if contains(NameCellArray{iName},'ÐòºÅ')
            VarNameArray{iName} = 'Num';
        elseif contains(NameCellArray{iName},'ÐÕÃû')
            VarNameArray{iName} = 'Name';
        elseif contains(NameCellArray{iName},'Ñ§ºÅ')
            VarNameArray{iName} = 'SN';
        elseif contains(NameCellArray{iName},'°à¼¶')
            VarNameArray{iName} = 'Class';
        else
            VarNameArray{iName} = sprintf('VAR%d',iName);
        end
    end
end

