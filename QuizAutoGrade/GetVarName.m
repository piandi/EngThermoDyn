function VarNameArray = GetVarName(NameCellArray)
VarNameArray = cell(size(NameCellArray));
if iscell(NameCellArray)
    NumName = length(NameCellArray);
    for iName = 1:NumName
        if contains(NameCellArray{iName},'���')
            VarNameArray{iName} = 'Num';
        elseif contains(NameCellArray{iName},'����')
            VarNameArray{iName} = 'Name';
        elseif contains(NameCellArray{iName},'ѧ��')
            VarNameArray{iName} = 'SN';
        elseif contains(NameCellArray{iName},'�༶')
            VarNameArray{iName} = 'Class';
        else
            VarNameArray{iName} = sprintf('VAR%d',iName);
        end
    end
end

