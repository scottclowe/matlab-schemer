%SCHEMER_EXPORT Export current MATLAB color scheme to text file
%   Note: if this is your first time using SCHEMER_EXPORT, please read the
%   IMPORTANT NOTE at the bottom of the help section.
%   
%   SCHEMER_EXPORT() with no input will prompt the user to locate a
%   destination file via the GUI. Please read the IMORTANT NOTE below
%   before running this script or it may not work correctly.
%   MATLAB preference options included are:
%   - All settings in the Color pane of Preferences
%   - All settings in the Color > Programming Tools pane
%   - From Editor/Debugger > Display pane, the following:
%      - Highlight current line (whether to highlight, and the color)
%      - Right-hand text limit (color and thickness, whether on/off)
%   The output format is the same as used in MATLAB's preferences file,
%   which is found at FULLFILE(PREFDIR,'matlab.prf').
%   
%   SCHEMER_EXPORT(FILENAME) exports the relevant MATLAB preferences
%   settings with regards to the interface color scheme currently in use to
%   the file FILENAME.
%   
%   SCHEMER_EXPORT(FILENAME,INCLUDEBOOLS) can control whether boolean
%   preferences are included in the export (default: TRUE). If INCLUDEBOOLS
%   is set to false, all the boolean preference options such as whether to
%   highlight autofixable errors, or to show variables with shared scope in
%   a different color are not included in the output. However, the colors
%   which would be used if the options where enabled are still outputted,
%   even when the settings are turned off. By default SCHEME_IMPORT
%   will not import the boolean settings, even if they have been exported.
%   NOTE: input order is reversible, so the command
%   SCHEMER_EXPORT(INCLUDEBOOLS,FILENAME) will also work, and 
%   SCHEMER_EXPORT(INCLUDEBOOLS) with boolean input will open the GUI to
%   pick the file.
%   
%   RET = SCHEMER_EXPORT(...) returns 1 on success, 0 on user
%   cancellation at output file selection screen, -1 on fopen error, and -2
%   on any other error.
%   
%   [RET, NAMES, PREFS] = SCHEMER_EXPORT(...) also returns two cell
%   arrays listing the names and preferences which were saved to file.
%   
%   For more details on how to get and set MATLAB preferences with
%   commands, see the following URL.
%   http://undocumentedmatlab.com/blog/changing-system-preferences-programmatically
%   
%   IMPORTANT NOTE:
%   You must at some point since installation have visited the
%   Color, Color>Programming Tools and Editor/Debugger>Display panes of
%   Preferences within MATLAB and then clicked OK in order for all the 
%   settings to be exported correctly. You will obviously have done this
%   for any settings you have changed but, for example, you may have left
%   the Editor/Debugger>Display settings unchanged. If this preference pane
%   has not been set, its entries will not have been defined, and when
%   trying to export these they will be incorrectly saved as off/black.
%   
%   Example 1: User is not sure if they have OK'd all the relevent
%   Preferences panes (or sure they haven't).
%       - Open File>Preferences
%       - On the left-hand side
%         - Click Colors
%         - Click Programming Tools (underneath Colors)
%         - Click Editor/Debugger
%         - Click Display (underneath Editor/Debugger)
%       - Click OK
%           (Yes, that is literally all you need to do to make sure you can
%           export correctly. No need to click anywhere I didn't mention.
%           You just have to have each pane appear, and then click OK at
%           the end.)
%       - Go to your command window and execute SCHEMER_EXPORT
%       - The GUI appears, you pick where to save the file.
%   
%   Example 2:  User is sure they have OK'd all the relevent Preferences
%   panes already.
%       schemer_export
%       
%   Example 2: User is sure they have OK'd all the relevent Preferences
%   panes already, knows the path they wish to save to, and doesn't want
%   to export their boolean settings.
%       schemer_export('some/path/schemeName.prf', false)
%   
%   See also SCHEMER_IMPORT, PREFDIR.

% Copyright (c) 2013, Scott Lowe
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

function varargout = schemer_export(fname, inc_bools)

VERSION = 'v1.1.0';
URL_GIT = 'https://github.com/scottclowe/matlab-schemer';

% ------------------------ Default inputs ---------------------------------
if nargin<2
    % Default is on. Recipient can pick themselves whether to import.
    inc_bools = true;
end
if nargin<1
    fname = [];
end
% Input switching
if nargin>=1 && ~ischar(fname) && ~isempty(fname)
    if ~islogical(fname) && ~isnumeric(fname)
        error('Invalid input argument 1');
    end
    if nargin==1
        % First input omitted
        inc_bools = fname;
        fname = [];
    elseif ischar(inc_bools)
        % Inputs switched
        tmp = fname;
        fname = inc_bools;
        inc_bools = tmp;
        clear tmp;
    else
        error('Invalid combination of inputs');
    end
end

% ------------------------ Settings ---------------------------------------
names_boolean = {                                   ...
    'ColorsUseSystem'                               ... % Color:    Desktop:    Use system colors
};
names_boolextra = {                                 ...
    'ColorsUseMLintAutoFixBackground'               ... % Color>PT: Analyser:   autofix highlight
    'Editor.VariableHighlighting.Automatic'         ... % Color>PT: Var&fn:     auto highlight
    'Editor.NonlocalVariableHighlighting'           ... % Color>PT: Var&fn:     with shared scope
    'EditorCodepadHighVisible'                      ... % Color>PT: CellDisp:   highlight cells
    'EditorCodeBlockDividers'                       ... % Color>PT: CellDisp:   show lines between cells
    'Editorhighlight-caret-row-boolean'             ... % Editor>Display:       Highlight current line
    'EditorRightTextLineVisible'                    ... % Editor>Display:       Show Right-hand text limit
};
names_integer = {                                   ...
    'EditorRightTextLimitLineWidth'                 ... % Editor>Display:       Right-hand text limit Width
};
names_color = {                                     ...
    'ColorsText'                                    ... % Color:    Desktop:    main text color
    'ColorsBackground'                              ... % Color:    Desktop:    main background
    'Colors_M_Keywords'                             ... % Color:    Syntax:     keywords
    'Colors_M_Comments'                             ... % Color:    Syntax:     comments
    'Colors_M_Strings'                              ... % Color:    Syntax:     strings
    'Colors_M_UnterminatedStrings'                  ... % Color:    Syntax:     unterminated strings
    'Colors_M_SystemCommands'                       ... % Color:    Syntax:     system commands
    'Colors_M_Errors'                               ... % Color:    Syntax:     errors
    'Colors_HTML_HTMLLinks'                         ... % Color:    Other:      hyperlinks
    'Colors_M_Warnings'                             ... % Color>PT: Analyser:   warnings
    'ColorsMLintAutoFixBackground'                  ... % Color>PT: Analyser:   autofix
    'Editor.VariableHighlighting.Color'             ... % Color>PT: Var&fn:     highlight
    'Editor.NonlocalVariableHighlighting.TextColor' ... % Color>PT: Var&fn:     with shared scope
    'Editorhighlight-lines'                         ... % Color>PT: CellDisp:   highlight
    'Editorhighlight-caret-row-boolean-color'       ... % Editor>Display:       Highlight current line Color
    'EditorRightTextLimitLineColor'                 ... % Editor>Display:       Right-hand text limit line Color
};



def_fname = 'ColorSchemeForMATLAB.prf';

% ------------------------ Setup ------------------------------------------
if nargout==0
    varargout = {};
else
    varargout = {-2};
end
if inc_bools
    names_boolean = [names_boolean names_boolextra];
end

% ------------------------ Check -------------------------------------
% Let the user know they are doing a stupid thing if they export when using
% the default settings
if com.mathworks.services.Prefs.getBooleanPref('ColorsUseSystem')
    warning(...
        ['You are exporting with system colors for main text and background.'...
         10, 'The exported theme will look different on different systems.']);
end

% ------------------------ File stuff -------------------------------------
if ~isempty(fname)
    if ~exist(fname,'file')
        error('Specified file does not exist');
    end
else
    % Get user's name
    username = java.lang.System.getProperty('user.name');
    % Prepend to filename
    def_fname = [char(username) def_fname];
    % Dialog asking for savename
    [filename, pathname] = uiputfile(def_fname, ...
        'Select file to write MATLAB color scheme');
    % End if user cancels
    if isequal(filename,0);
        if nargout>0; varargout{1} = 0; end;
        return;
    end
    fname = fullfile(pathname,filename);
end

% Open for write access of text file, create if necessary
fid = fopen(fname,'w+t','n');
if isequal(fid,-1);
    if nargout>0; varargout{1} = -1; end;
    return;
end
% Add a cleanup object incase of failure
finishup = onCleanup(@() fclose(fid));

% Find the name of the color scheme based on the filename
[~, schemename] = fileparts(filename);

% Write a few comments to the start of the file
fprintf(fid,'# %s - MATLAB color scheme\n', schemename);
fprintf(fid,'# Generated with schemer_export %s, on MATLAB %s\n',VERSION,version);
fprintf(fid,'# %s\n', char(java.util.Date));
fprintf(fid,'# To enable this color scheme in MATLAB use schemer_import, available at:\n');
fprintf(fid,'#     %s\n', URL_GIT);

% ------------------------ Read and Write ---------------------------------
% Loop through the boolean type settings
prefs_boolean = cell(size(names_boolean));
for i=1:length(names_boolean)
    
    iname = names_boolean{i};
    ipref = com.mathworks.services.Prefs.getBooleanPref(iname);
    prefs_boolean{i} = ipref;
    
    % Write to file
    outstr = [iname '=B'];
    if ipref
        outstr = [outstr 'true'];
    else
        outstr = [outstr 'false'];
    end
    outstr = [outstr '\n'];
    fprintf(fid,outstr);
    
end

% Loop through the integer type settings
prefs_integer = cell(size(names_integer));
for i=1:length(names_integer)
    
    iname = names_integer{i};
    ipref = com.mathworks.services.Prefs.getIntegerPref(iname);
    prefs_integer{i} = ipref;
    
    % Write to file
    outstr = '%s=I%d\n';
    fprintf(fid,outstr,iname,ipref);
    
end

% Loop through the color type settings
prefs_color = cell(size(names_color));
for i=1:length(names_color)
    
    iname = names_color{i};
    ipref = com.mathworks.services.Prefs.getColorPref(iname);
    prefs_color{i} = ipref;
    
    % Write to file
    outstr = '%s=C%d\n';
    fprintf(fid,outstr,iname,ipref.getRGB);
end

% ------------------------ Tidy up ----------------------------------------
% fclose(fid); % Don't need to close as it will autoclose
if nargout>0; varargout{1} = 1; end;

fprintf('Exported color scheme to %s\n',fname);

if nargout>1;
    varargout{2} = [names_boolean names_integer names_color];
    varargout{3} = [prefs_boolean prefs_integer prefs_color];
end

end
