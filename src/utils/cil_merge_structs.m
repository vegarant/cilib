% Merges scructB into structA. If the two structs have equal elements
% structB's values will be preserved. 

function opts = cil_merge_structs(structA, structB)
    f = fieldnames(structB);
    for i = 1:length(f)
        structA.(f{i}) = structB.(f{i});
    end
    opts = structA;
end

