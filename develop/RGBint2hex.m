%RGBINT2HEX Convert RGB integer into hexadecimal colour
%   HEX = RGBINT2HEX(INT) given an RGB integer, convert it into a
%   hexadecimal string.
%   
%   This is a helper function which you can use when manually creating your
%   own MATLAB colour schemes. It is the inverse of COLOR2JAVARGBINT.
%   
%   See also COLOR2JAVARGBINT.

% Copyright (c) 2015-2016,  Scott C. Lowe <scott.code.lowe@gmail.com>
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function hex = RGBint2hex(int)

% Make a Java colour object
jc = java.awt.Color(int);
% Convert R,G,B into hexadecimal
hex = sprintf('%02s', ...
    dec2hex(jc.getRed), dec2hex(jc.getGreen), dec2hex(jc.getBlue));

end
