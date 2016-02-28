function sample()
% Create an output file with sys command
!touch test_file.txt
fid = fopen('test_file.txt', 'w');
for i=1:20
    fprintf(fid, '%d unterminated\n, i);
end
fclose(fid);
end

function unusedFunc(passedInput)
persistent global_value;
global_value = global_value + 1;
%% Title of cell
printed_var = subFunc(global_value)
unused_var = printed_var;
    function out = subFunc(scaleFactor)
        fprintf('Scale %.4f\n', scaleFactor);
        out = passedInput * scaleFactor;
    end
end
