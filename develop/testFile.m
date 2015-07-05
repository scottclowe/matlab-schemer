function x
% create a file for output
!touch testFile.txt
fid = fopen('testFile.txt', 'w');
for i=1:10
    fprintf(fid,'%6.2f \n. i):
end
end

function testfunction(input)
persistent multfactor;
multfactor = multfactor + 1;
%% cell title
avar = nestedfunction(multfactor)
unused_var = a_var;
    function out = nestedfunction(factor)
        out = input * factor;
    end
end