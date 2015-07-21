%SCHEMER_EXPORT Export current MATLAB color scheme to text file
%   If this is your first time using SCHEMER_EXPORT, please ensure you
%   first read the IMPORTANT NOTE at the bottom of the help section.
%   
%   SCHEMER_EXPORT() with no input will prompt the user to locate a
%   destination file via the GUI. Please read the IMORTANT NOTE below
%   before running this script or it may not work correctly.
%   MATLAB preference options included are:
%   - All settings in the Color pane of Preferences
%   - All settings in the Color > Programming Tools pane
%   - From Editor/Debugger > Display pane, the following:
%      - Highlight current line (whether to highlight, and the colour)
%      - Right-hand text limit (colour and thickness, whether on/off)
%   The output format is the same as used in MATLAB's preferences file,
%   which is found at FULLFILE(PREFDIR,'matlab.prf').
%   
%   SCHEMER_EXPORT(FILENAME) exports the relevant MATLAB preferences
%   settings with regards to the interface color scheme currently in use to
%   the file FILENAME.
%   
%   SCHEMER_EXPORT(FILENAME, FLAG_MODE) controls which settings are output
%   into the preference file FILENAME. Along with the colour settings for
%   MATLAB syntax highlighting, one can also export the boolean preferences
%   (such as whether cells and non-local variables, etc, should be coloured
%   differently to the regular backgound and text); and one can also export
%   the colour settings for syntax highlighting in other languages
%   supported by MATLAB.
%   
%   The FLAG_MODE settings available are:
%     0 - neither boolean, nor additional languages are exported
%     1 - boolean settings are exported, but not additional languages
%     2 - additional language colours are exported, but not boolean settings
%     3 - both boolean and additional languages are exported
%   
%   By default, FLAG_MODE is set to 1, so boolean settings will be
%   exported, but not colours for additional languages.
%   
%   The colour settings for all MATLAB syntax highlighting will always be
%   exported, even for syntax options which are currently disabled, and
%   regardless of whether the boolean settings are being exported. This is
%   because users loading your exported color scheme may want syntax
%   options highlighted which you are not currently using. Consequently,
%   when designing a color scheme, it is advisable to set colours for all
%   possisble MATLAB colour settings, even if you don't usually use them.
%   By default, SCHEMER_IMPORT will not import boolean settings, so users
%   will keep their syntax options enabled or disabled as they prefer even
%   after importing your color scheme.
%   
%   Colours for highlighting syntax in other languages supported by MATLAB
%   (TLC, C++, Java, VHDL, Verilog, XML) can be set in the preferences
%   panel Editor/Debugger > Language. If you have not set any of these
%   colours yourself, you should not export them. If SCHEMER_IMPORT loads a
%   color scheme without additional language syntax included, the MATLAB
%   colours are extended to highlight syntax in the other languages
%   consistent with the MATLAB scheme.
%   
%   SCHEMER_EXPORT(FLAG_MODE, FILENAME) with a numeric and then string
%   input also work, as the input order is reversible.
%   
%   SCHEMER_EXPORT(FLAG_MODE) with a single numeric input will open the GUI
%   to pick the filename and will save the output according to FLAG_MODE.
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
%         - Click Programming Tools (underneath "Colors" as a subsection)
%         - Click Editor/Debugger (a different panel to Colors)
%         - Click Display (underneath "Editor/Debugger" as a subsection)
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
%   Example 3: User is sure they have OK'd all the relevent Preferences
%   panes already, knows the path they wish to save to, and doesn't want
%   to export their boolean settings.
%       schemer_export('some/path/schemeName.prf', false)
%   
%   See also SCHEMER_IMPORT, PREFDIR, COLOR2JAVARGBINT.

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

function varargout = schemer_export(fname, flag_mode)

VERSION = 'v1.2.0';
URL_GIT = 'https://github.com/scottclowe/matlab-schemer';

% ------------------------ Input handling ---------------------------------
% Default inputs
if nargin<2
    % Default is on. Recipient can pick themselves whether to import.
    flag_mode = 1;
end
if nargin<1
    fname = [];
end
% Input switching
if nargin>=1 && ~ischar(fname) && ~isempty(fname)
    if ~isnumeric(fname)
        error('Invalid input argument 1');
    end
    if nargin==1
        % First input omitted
        flag_mode = fname;
        fname = [];
    elseif ischar(flag_mode)
        % Inputs switched
        tmp = fname;
        fname = flag_mode;
        flag_mode = tmp;
        clear tmp;
    else
        error('Invalid combination of inputs');
    end
end
% Mode handling
if ~isnumeric(fname)
    error('Export mode flag must be numeric.');
elseif flag_mode < 0 || flag_mode > 3
    error('Bad mode specified: %s', num2str(flag_mode));
end
inc_bools      = mod(flag_mode, 2);
inc_otherlangs = flag_mode >= 2;
% 0:  no bools,  no other languages
% 1: yes bools,  no other languages
% 2:  no bools, yes other languages
% 3: yes bools, yes other languages

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
    'ColorsText'                                    ... % Color:    Desktop:    main text colour
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
names_color_otherlangs = { ...
    'Editor.Language.TLC.Color.Colors_M_SystemCommands' , ... % TLC
    'Editor.Language.TLC.Color.Colors_M_Keywords'       , ...
    'Editor.Language.TLC.Color.Colors_M_Comments'       , ...
    'Editor.Language.TLC.Color.string-literal'          , ...
    'Editor.Language.C.Color.keywords'                  , ... % C/C++
    'Editor.Language.C.Color.line-comment'              , ...
    'Editor.Language.C.Color.string-literal'            , ...
    'Editor.Language.C.Color.preprocessor'              , ...
    'Editor.Language.C.Color.char-literal'              , ...
    'Editor.Language.C.Color.errors'                    , ...
    'Editor.Language.Java.Color.keywords'               , ... % Java
    'Editor.Language.Java.Color.line-comment'           , ...
    'Editor.Language.Java.Color.string-literal'         , ...
    'Editor.Language.Java.Color.char-literal'           , ...
    'Editor.Language.VHDL.Color.Colors_M_Keywords'      , ... % VHDL
    'Editor.Language.VHDL.Color.operator'               , ...
    'Editor.Language.VHDL.Color.Colors_M_Comments'      , ...
    'Editor.Language.VHDL.Color.string-literal'         , ...
    'Editor.Language.Verilog.Color.Colors_M_Comments'   , ... % Verilog
    'Editor.Language.Verilog.Color.operator'            , ...
    'Editor.Language.Verilog.Color.Colors_M_Keywords'   , ...
    'Editor.Language.Verilog.Color.string-literal'      , ...
    'Editor.Language.XML.Color.error'                   , ... % XML
    'Editor.Language.XML.Color.tag'                     , ...
    'Editor.Language.XML.Color.attribute'               , ...
    'Editor.Language.XML.Color.operator'                , ...
    'Editor.Language.XML.Color.value'                   , ...
    'Editor.Language.XML.Color.comment'                 , ...
    'Editor.Language.XML.Color.doctype'                 , ...
    'Editor.Language.XML.Color.ref'                     , ...
    'Editor.Language.XML.Color.pi-content'              , ...
    'Editor.Language.XML.Color.cdata-section'           , ...
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
if inc_otherlangs
    names_color = [names_color names_color_otherlangs];
end

% ------------------------ Check -------------------------------------
% Check the user is not exporting without having visited any of the
% preference panels, or has otherwise set text and background to match
if isequal(com.mathworks.services.Prefs.getColorPref('ColorsText').getRGB,...
        com.mathworks.services.Prefs.getColorPref('ColorsBackground').getRGB)
    
    % Define the base error message. We will add to it depending on the
    % exact set up.
    msg = 'Colour for text and background are the same.';
    
    % The values match, so give an error
    if com.mathworks.services.Prefs.getColorPref('ColorsText').getRGB==-16777216
        % Since the colour is black, it seems the user hasn't visited the
        % colour preference panes at all
        msg = [msg, 10, ...
               'Are you sure you have visited all the preference panels,'...
               ' as per the instructions in the function description?'];
           
    elseif com.mathworks.services.Prefs.getBooleanPref('ColorsUseSystem')
        % The colour is something else, but both text and background match.
        % The user is managing to use the colours by overriding them with
        % the system colours.
        msg = [msg, 10, ...
           'Although you have enabled system colors, the underlying ', ...
           'colour settings match. This is not permitted because the ', ...
           'text would be illegible if system colours were disabled.'];
        
    else
        % The colour is something else, but both text and background match.
        % Presumably the text is currently illegible to the user right now.
        msg = [msg, 10, ...
           'This is not permitted because the text is illegible.'];
    end
    
    % Raise the error with the completed message
    error(msg);
end

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

% Loop through the colour type settings
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
