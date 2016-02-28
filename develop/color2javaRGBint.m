%COLOR2JAVARGBINT Converts a 256-bit color into a corresponding Java int
%   INT = COLOR2JAVARGBINT(HEX) converts the hexadecimal string HEX into a
%   negative integer INT which is used by Java as an RGB value equivalent
%   to the hexadecimal HEX. HEX should be a triple of 256-bit values,
%   possibly prepended by a hash ('#'). Alternatively, HEX can be a triple
%   of 16-bit values to provide a 16-bit colour instead.
%   
%   INT = COLOR2JAVARGBINT(RGB) converts the 3-element RGB colour into INT.
%   
%   INT = COLOR2JAVARGBINT(R, G, B) converts the triple [R G B] into INT.
%   
%   This is a helper function which you can use when manually creating your
%   own MATLAB colour schemes.
%   If you have a set of hexadecimal colours which you want to use,
%   you can copy the template colour scheme file, then convert each colour
%   using COLOR2JAVARGBINT. The output will be a negative integer, which
%   should be placed after the appropriate '...=C-' (with a only a single
%   minus sign present).
%   
%   See also SCHEME_EXPORT, RGBINT2HEX.

% Copyright (c) 2013-2016,  Scott C. Lowe <scott.code.lowe@gmail.com>
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

function int = color2javaRGBint(X, varargin)

% Input handling
if nargin==3
    if ~isnumeric(X) || ~isnumeric(varargin{1}) || ~isnumeric(varargin{2})
        error('With three inputs given, all should be scalars');
    end
    % Concatenate R,G,B together
    X = [X(:); varargin{1}(:); varargin{2}(:)];
elseif nargin~=1
    error('Incorrect number of inputs. Should be 1 or 3.');
end

if ischar(X)
    % Handle Hex string conversion
    int = hex2javaRGBint(X);
elseif isnumeric(X)
    % Handle RGB conversion
    int = RGB2javaRGBint(X);
else
    error('Input was neither string nor numeric');
end

end


function int = hex2javaRGBint(hex)

% Input handling
if length(hex)==7 && strcmp(hex(1),'#')
    hex = hex(2:end);
end
if length(hex)==3
    % Assume a 16-bit colour (fff, 333, 840, etc)
    % This should be replicated to make ffffff, 333333, 884400, etc.
    % This is sometimes used on the web as shorthand for the 256-bit
    % colours, particularly for the grey shades.
    hex = reshape(repmat(hex, 2, 1), 1, 6);
elseif length(hex)~=6
    % Length should be 6 for a three channel 256-bit hexadecimal
    error('Input string was not a hexadecimal number');
end

% Make a Java color object
jc = java.awt.Color(hex2dec(hex));
% Check what the RGB int is equal to
int = jc.getRGB();
% This is equivalent to
% int = hex2dec(hex) - (256^2*255 + 256*255 + 256);

end



function int = RGB2javaRGBint(X)

% Input handling
if numel(X)==1
    % Assume input is greyscale
    X = repmat(X, 3, 1);
end
if numel(X)~=3
    error('Input did not contain three colour channels');
end
if any(X<0)
    error('R,G,B cannot be negative');
end
if any(X>255)
    error('R,G,B should be not exceed 255');
end
if all(X<1)
    % Rescale from 0-1 to 0-255
    X = round(X*255);
end

% Convert R, G, and B into a single integer
dec = 256^2 * X(1) + 256 * X(2) + X(3);

% Make a Java color object
jc = java.awt.Color(dec);
% Check what the RGB int is equal to
int = jc.getRGB();
% This is equivalent to
% int = dec - (256^2*255 + 256*255 + 256);

end
