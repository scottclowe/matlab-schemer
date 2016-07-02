%SCHEMER_EXPORT Export current MATLAB color scheme to text file
%   If this is your first time using SCHEMER_EXPORT, please ensure you
%   read the IMPORTANT NOTE at the bottom of the help section before using
%   this function.
%
%   SCHEMER_EXPORT() with no input will prompt the user to locate a
%   destination file via the GUI, and will save the current color scheme
%   to this location. Please read the IMORTANT NOTE below
%   before running this script or it may not work correctly.
%   The MATLAB preference options which are exported are:
%   - All settings in the Color pane of Preferences
%   - All settings in the Color > Programming Tools pane
%   - From Editor/Debugger > Display pane, the following:
%      - Highlight current line (whether to highlight, and the colour)
%      - Right-hand text limit (colour and thickness, whether on/off)
%   The output format is the same as used in MATLAB's preferences file,
%   which is found at FULLFILE(PREFDIR,'matlab.prf').
%
%   SCHEMER_EXPORT(FILENAME) exports the relevant MATLAB preferences
%   to the file FILENAME.
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
%     0 - neither booleans, nor additional languages are exported
%     1 - boolean settings are exported, but not additional languages
%     2 - additional language colours are exported, but not boolean settings
%     3 - both booleans and additional languages are exported
%
%   By default FLAG_MODE is set to 1, so boolean settings will be
%   exported, but the settings for syntax highlighting in additional
%   languages will not be.
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
%   (MuPAD, TLC, VRML, C++, Java, VHDL, Verilog, XML) can be set in the
%   preferences panel Editor/Debugger > Language. If you have not set any
%   of these colours yourself, you should not export them. If SCHEMER_IMPORT
%   loads a color scheme without additional language syntax included, the
%   MATLAB colours are extended to highlight syntax in the other languages
%   consistent with the MATLAB scheme.
%
%   SCHEMER_EXPORT(FLAG_MODE, FILENAME), with a numeric input followed by a
%   string, will also work as above because the input order is reversible.
%
%   SCHEMER_EXPORT(FLAG_MODE) with a single numeric input will open the GUI
%   to pick the filename and will save the output according to FLAG_MODE.
%
%   RET = SCHEMER_EXPORT(...) returns 1 on success, 0 on user
%   cancellation at the output file selection screen, -1 on fopen error,
%   and -2 on any other error.
%
%   [RET, NAMES, PREFS] = SCHEMER_EXPORT(...) also returns two cell
%   arrays listing the names and preferences which were saved to file.
%
%   For more details on how to get and set MATLAB preferences with
%   commands, see the following URL.
%   http://undocumentedmatlab.com/blog/changing-system-preferences-programmatically
%
%   IMPORTANT NOTE:
%   You must have, at any point since installing MATLAB, visited the
%   Color, Color>Programming Tools and Editor/Debugger>Display panes of
%   the Preferences diaglogue within MATLAB and then clicked OK in order
%   for all the settings to be exported correctly. You will obviously have
%   done this for any settings you have changed but, for example, you may
%   have left the Editor/Debugger>Display settings unchanged. If this
%   preference pane has not been set its entries will not have been
%   defined, and when trying to export these they will be incorrectly saved
%   as off (for booleans) or black (for colours).
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
%           export correctly. There is no need to click anywhere which was
%           not mentioned. You just have to have each pane appear, and then
%           click OK at the end.)
%       - Go to your command window and execute SCHEMER_EXPORT
%       - The GUI appears, and you pick where to save the file.
%
%   Example 2:  User is sure they have OK'd all the relevent Preferences
%   panes already.
%       schemer_export
%
%   Example 3: User is sure they have OK'd all the relevent Preferences
%   panes already, knows the path they wish to save to, and doesn't want
%   to export their boolean settings.
%       schemer_export('some/path/schemeName.prf', 0)
%
%   Example 4: User has set some colour preferences for C/C++ syntax
%   highlighting in addition to MATLAB syntax highlighting, and wants to
%   output this along with their boolean settings
%       schemer_export(3)
%
%   See also SCHEMER_IMPORT, PREFDIR, COLOR2JAVARGBINT.

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

function varargout = schemer_export(fname, flag_mode)

% ------------------------ Parameters -------------------------------------
SCHEMER_VERSION = 'v1.4.0';
SCHEMER_URLGIT  = 'https://github.com/scottclowe/matlab-schemer';
SCHEMER_URLFEX  = 'https://www.mathworks.com/matlabcentral/fileexchange/53862-matlab-schemer';
DEFOUTNAME      = 'ColorSchemeForMATLAB.prf';

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
if ~isnumeric(flag_mode)
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
% Names of boolean preferences which should always be output
names_boolean = {                                   ...
    'ColorsUseSystem'                               ; ... % Color:    Desktop:    Use system colors
};
% Names of boolean preferences which the user can choose whether to output
names_boolextra = {                                 ...
    'ColorsUseMLintAutoFixBackground'               ; ... % Color>PT: Analyser:   autofix highlight
    'Editor.VariableHighlighting.Automatic'         ; ... % Color>PT: Var&fn:     auto highlight
    'Editor.NonlocalVariableHighlighting'           ; ... % Color>PT: Var&fn:     with shared scope
    'EditorCodepadHighVisible'                      ; ... % Color>PT: CellDisp:   highlight cells
    'EditorCodeBlockDividers'                       ; ... % Color>PT: CellDisp:   show lines between cells
    'Editorhighlight-caret-row-boolean'             ; ... % Editor>Display:       Highlight current line
    'EditorRightTextLineVisible'                    ; ... % Editor>Display:       Show Right-hand text limit
};
% Names of preferences for which the values are integers
names_integer = {                                   ...
    'EditorRightTextLimitLineWidth'                 ; ... % Editor>Display:       Right-hand text limit Width
};
% The names of the main colour panels, so we can let the user know by name
% if there is an issue with any of them
panels_main = {                                     ...
    'Color'                                         ; ...
    'Color > Programming Tools'                     ; ...
    'Editor/Debugger > Display'                     ; ...
};
% Names of colour preferences which are in the main panels and used in
% MATLAB syntax highlighting
names_color_main = {                                ...
  { ... % Color panel
    'ColorsText'                                    ; ... % Color:    Desktop:    main text colour
    'ColorsBackground'                              ; ... % Color:    Desktop:    main background
    'Colors_M_Keywords'                             ; ... % Color:    Syntax:     keywords
    'Colors_M_Comments'                             ; ... % Color:    Syntax:     comments
    'Colors_M_Strings'                              ; ... % Color:    Syntax:     strings
    'Colors_M_UnterminatedStrings'                  ; ... % Color:    Syntax:     unterminated strings
    'Colors_M_SystemCommands'                       ; ... % Color:    Syntax:     system commands
    'Colors_M_Errors'                               ; ... % Color:    Syntax:     errors
    'Colors_HTML_HTMLLinks'                         ; ... % Color:    Other:      hyperlinks
  } ...
  { ... % Color > Programming Tools
    'Colors_M_Warnings'                             ; ... % Color>PT: Analyser:   warnings
    'ColorsMLintAutoFixBackground'                  ; ... % Color>PT: Analyser:   autofix
    'Editor.VariableHighlighting.Color'             ; ... % Color>PT: Var&fn:     highlight
    'Editor.NonlocalVariableHighlighting.TextColor' ; ... % Color>PT: Var&fn:     with shared scope
    'Editorhighlight-lines'                         ; ... % Color>PT: CellDisp:   highlight
  } ...
  { ... % Editor/Debugger > Display
    'Editorhighlight-caret-row-boolean-color'       ; ... % Editor>Display:       Highlight current line Color
    'EditorRightTextLimitLineColor'                 ; ... % Editor>Display:       Right-hand text limit line Color
  }
};
% Names of colour preferences which are known to have been added since the
% year 2011, and so their presence in the preferences is not guaranteed
%   column 1: name of setting
%   column 2: first version in which preference might have been implemented
%   column 3: first version in which preference has been observed to exist
names_color_versioned = { ...
    'Color_CmdWinWarnings'                          , ... % Color: Command Window Warning messages
        '7.13'                                          , ... % Known to NOT be in 2011a (7.12)
        '8.2'                                           ; ... % Known to be in 2013b
    'Color_CmdWinErrors'                            , ... % Color: Command Window Error messages
        '8.3'                                           , ... % Known to NOT be in 2013b (8.2)
        '8.4'                                           ; ... % Known to be in 2014b
};
% Names of colour preferences for syntax highlighting in languages other
% than MATLAB
names_color_otherlangs = {                          ...
  { ... % MuPAD
    'Editor.Language.MuPAD.Color.keyword'               ; ...
    'Editor.Language.MuPAD.Color.operator'              ; ...
    'Editor.Language.MuPAD.Color.block-comment'         ; ...
    'Editor.Language.MuPAD.Color.option'                ; ...
    'Editor.Language.MuPAD.Color.string'                ; ...
    'Editor.Language.MuPAD.Color.function'              ; ...
    'Editor.Language.MuPAD.Color.constant'              ; ...
  } ...
  { ... % TLC
    'Editor.Language.TLC.Color.Colors_M_SystemCommands' ; ...
    'Editor.Language.TLC.Color.Colors_M_Keywords'       ; ...
    'Editor.Language.TLC.Color.Colors_M_Comments'       ; ...
    'Editor.Language.TLC.Color.string-literal'          ; ...
  } ...
  { ... % C/C++
    'Editor.Language.C.Color.keywords'                  ; ...
    'Editor.Language.C.Color.line-comment'              ; ...
    'Editor.Language.C.Color.string-literal'            ; ...
    'Editor.Language.C.Color.preprocessor'              ; ...
    'Editor.Language.C.Color.char-literal'              ; ...
    'Editor.Language.C.Color.errors'                    ; ...
  } ...
  { ... % Java
    'Editor.Language.Java.Color.keywords'               ; ...
    'Editor.Language.Java.Color.line-comment'           ; ...
    'Editor.Language.Java.Color.string-literal'         ; ...
    'Editor.Language.Java.Color.char-literal'           ; ...
  } ...
  { ... % VHDL
    'Editor.Language.VHDL.Color.Colors_M_Keywords'      ; ...
    'Editor.Language.VHDL.Color.operator'               ; ...
    'Editor.Language.VHDL.Color.Colors_M_Comments'      ; ...
    'Editor.Language.VHDL.Color.string-literal'         ; ...
  } ...
  { ... % Verilog
    'Editor.Language.Verilog.Color.Colors_M_Comments'   ; ...
    'Editor.Language.Verilog.Color.operator'            ; ...
    'Editor.Language.Verilog.Color.Colors_M_Keywords'   ; ...
    'Editor.Language.Verilog.Color.string-literal'      ; ...
  } ...
  { ... % XML
    'Editor.Language.XML.Color.error'                   ; ...
    'Editor.Language.XML.Color.tag'                     ; ...
    'Editor.Language.XML.Color.attribute'               ; ...
    'Editor.Language.XML.Color.operator'                ; ...
    'Editor.Language.XML.Color.value'                   ; ...
    'Editor.Language.XML.Color.comment'                 ; ...
    'Editor.Language.XML.Color.doctype'                 ; ...
    'Editor.Language.XML.Color.ref'                     ; ...
    'Editor.Language.XML.Color.pi-content'              ; ...
    'Editor.Language.XML.Color.cdata-section'           ; ...
  }
};

% Names of colour preferences for syntax highlighting in languages other
% than MATLAB
names_color_vrml = {                          ...
    % VRML
    'Editor.Language.VRML.Color.keyword'                ; ...
    'Editor.Language.VRML.Color.node-keyword'           ; ...
    'Editor.Language.VRML.Color.field-keyword'          ; ...
    'Editor.Language.VRML.Color.data-type-keyword'      ; ...
    'Editor.Language.VRML.Color.terminal-symbol'        ; ...
    'Editor.Language.VRML.Color.comment'                ; ...
    'Editor.Language.VRML.Color.string'                 ; ...
};
% First version of matlab which uses VRMLX3DV instead of VRML
version_vrmlx3dv = '9.0';

% Names of preferences for other language syntax and where setting value
% is a string
%   column 1: name of preference
%   column 2: a regex which the string must match if it is to be exported
%             use '.' or '.+' to allow any non-empty string to be output
%             use  '' or '.*' for anything, including empty strings
%             use '\S' for anything except empty or whitespace-only strings
%             use '^str1|str2|str3$' to allow only a finite set of strings
names_string_otherlang = {                              ...
    'Editor.Language.Java.method'                       , ... % Java: Show methods
        '^(none|bold|italic)$'                             ; ...
};


% ------------------------ Setup ------------------------------------------
% Initialise output
if nargout==0
    % Empty if no output requested
    varargout = {};
else
    % -2 to signify unknown error otherwise
    varargout = {-2};
end
% If we are outputting all the bools, add them to the list to do
if inc_bools
    names_boolean = [names_boolean; names_boolextra];
end

% ------------------------ Check -------------------------------------
% Check the user is not exporting without having visited any of the
% preference panels, or has otherwise set text and background to match
if isequal(com.mathworks.services.Prefs.getColorPref('ColorsText').getRGB, ...
        com.mathworks.services.Prefs.getColorPref('ColorsBackground').getRGB)

    % Define the base error message. We will add to it depending on the
    % exact set up.
    msg = 'Colour for text and background appear to be the same.';

    % The values match, so give an error
    if com.mathworks.services.Prefs.getColorPref('ColorsText').getRGB ...
            == -16777216
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

% Go through all the main color preference panels, checking their settings
% are available to us
% Initialise outer level of holding variables
cprefs_main = cell(size(names_color_main));
colors_main = cell(size(names_color_main));
% Loop over every one of the main colour preference panels
for iPanel = 1:numel(names_color_main)
    % Fetch the colours for this panel
    [cprefs_main{iPanel}, colors_main{iPanel}] = ...
        fetch_colors(names_color_main{iPanel});
    % Only give the error on the Color and Programming Tools pages, because
    % there are only two colours set in the Editor > Display and they could
    % plausibly both be black. We instead check this panel seperately below.
    if iPanel <= 2 && all(colors_main{iPanel} == -16777216)
        % This panel appears to all be black, so we make an error
        error(...
            ['Colours for all of %1$s panel appear to be black. ' 10 ...
             'This will be because you have never set the preferences ' ...
             'in this panel. You can do so by visiting the %1$s ' ...
             'Preferences page and clicking OK, as detailed in the ' ...
             'description of this function.'], panels_main{iPanel});
    end
end
% Check the Editor > Display panel has been initialised.
% If it hasn't, the line width will appear to be 0, which is not a possible
% setting.
if com.mathworks.services.Prefs.getIntegerPref(...
        'EditorRightTextLimitLineWidth') == 0
    % It hasn't been set, so we generate an error
    error(...
        ['Properties from the %1$s preference panel could not be loaded. ' ...
         10 ...
         'This will be because you have never set the preferences in '...
         'this panel. You can do so by visiting the %1$s ' ...
         'Preferences page and clicking OK, as detailed in the ' ...
         'description of this function.'], panels_main{3});
end

% Let the user know they are doing a stupid thing if they export when using
% the default settings
if com.mathworks.services.Prefs.getBooleanPref('ColorsUseSystem')
    warning(...
        ['You are exporting with system colors for main text and background.'...
         10, 'The exported theme will look different on different systems.']);
end

% ------------------------ File stuff -------------------------------------
if isempty(fname)
    % Get user's name
    username = java.lang.System.getProperty('user.name');
    % Prepend username to default filename
    outFileName = [char(username) DEFOUTNAME];
    % Dialog asking for savename, with smart default output filename
    [filename, pathname] = uiputfile(outFileName, ...
        'Select file to write MATLAB color scheme');
    % End if user cancels
    if isequal(filename, 0);
        if nargout>0; varargout{1} = 0; end;
        return;
    end
    fname = fullfile(pathname, filename);
end

% Open for write access of text file, create if necessary
fid = fopen(fname, 'w+t', 'n');
if isequal(fid, -1);
    if nargout>0; varargout{1} = -1; end;
    return;
end
% Add a cleanup object incase of failure
finishup = onCleanup(@() fclose(fid));

% Find the name of the color scheme based on the filename
[~, schemename] = fileparts(fname);

% Write a few comments to the start of the file
fprintf(fid, '# %s - MATLAB color scheme\n', schemename);
fprintf(fid, '# Generated with schemer_export %s, on MATLAB %s\n', ...
                SCHEMER_VERSION, version);
fprintf(fid, '# %s\n', char(java.util.Date));
fprintf(fid, '# To enable this color scheme in MATLAB use schemer_import, available at:\n');
fprintf(fid, '#     %s\n', SCHEMER_URLGIT);
fprintf(fid, '#     %s\n', SCHEMER_URLFEX);


% ------------------------ Read and Write ---------------------------------
% Loop through the boolean type settings
prefs_boolean = cell(size(names_boolean));
for i=1:length(names_boolean)
    % Check the name of this preference
    nm = names_boolean{i};
    % Get the value of this boolean preference
    prefs_boolean{i} = com.mathworks.services.Prefs.getBooleanPref(nm);
    % Construct the string to output
    outstr = [nm '=B'];
    if prefs_boolean{i}
        outstr = [outstr 'true'];
    else
        outstr = [outstr 'false'];
    end
    outstr = [outstr '\n'];
    % Write this boolean value to the output file
    fprintf(fid, outstr);
end

% Loop through the integer type settings
prefs_integer = cell(size(names_integer));
for i=1:length(names_integer)
    % Check the name of this preference
    nm = names_integer{i};
    % Get the integer value for this preference
    prefs_integer{i} = com.mathworks.services.Prefs.getIntegerPref(nm);
    % Write this integer value to the output file
    fprintf(fid, '%s=I%d\n', nm, prefs_integer{i});
end

% Loop through the colour type settings for MATLAB syntax highlighting
for iPanel=1:numel(names_color_main)
    for iPref=1:numel(names_color_main{iPanel})
        % Check the name of this preference
        nm = names_color_main{iPanel}{iPref};
        % Write its colour value to the output file
        fprintf(fid, '%s=C%d\n', nm, colors_main{iPanel}(iPref));
    end
end

% Loop over colours which may or may not be available
% Initialise cell arrays for successful fields
onames_versioned = {};
cprefs_versioned = {};
% Loop over the colours
for iPref=1:size(names_color_versioned, 1)
    % Check the name of this preference
    nm = names_color_versioned{iPref, 1};
    % Try to get the colour for this preference
    prf = com.mathworks.services.Prefs.getColorPref(nm);
    % If the current MATLAB version is less the first version where it is
    % not known whether it has implemented this preference feature
    % Or if the MATLAB version is less than the first version known to have
    % implemented the feature and the colour appears to be black
    % Then we skip this preference
    if verLessThan('matlab', names_color_versioned{iPref, 2}) ...
        || ( ...
            verLessThan('matlab', names_color_versioned{iPref, 3}) ...
            && prf.getRGB==-16777216 ...
           )
        % It appears that this version of MATLAB does not include this
        % preference. So we skip it.
        continue;
    end
    % Otherwise, we write its colour value to the output file
    fprintf(fid, '%s=C%d\n', nm, prf.getRGB);
    % And we add the values to the list to output
    onames_versioned{end+1} = nm;
    cprefs_versioned{end+1} = prf;
end


% Initialise a cell array to output for other language syntax
onames_langs = {};
cprefs_langs = {};
% Loop through the colour type settings for other language syntax, only if
% it is requested
if inc_otherlangs
    % Go through all the language color syntax preference panels, checking
    % their settings are available to us
    % Loop over every one of the main colour preference panels
    for iPanel = 1:numel(names_color_otherlangs)
        [panel_prefs, panel_colors] = fetch_colors(...
            names_color_otherlangs{iPanel});
        if all(panel_colors==-16777216)
            % All the colours in this panel are black, so we assume the
            % color settings have not loaded because they have not been set
            continue;
        end
        % Not all the colours are black, so we assume we have loaded the
        % values for this language panel.

        % Loop again over every colour setting in the panel
        for iPref = 1:numel(names_color_otherlangs{iPanel})
            % Get the name for the color setting we are interested in
            nm = names_color_otherlangs{iPanel}{iPref};
            % Write its colour value to the output file
            fprintf(fid, '%s=C%d\n', nm, panel_colors(iPref));
        end
        % Remember the prefences so we can return them
        onames_langs = [onames_langs; names_color_otherlangs{iPanel}];
        cprefs_langs = [cprefs_langs; panel_prefs];
    end
end

% We have to do special handling for VRML because in R2016a, MathWorks
% changed the encoding name from VRML to VRMLX3DV. Aside from this, nothing
% else was changed. The rest of the preference name is the same, and the
% default values are unchanged.
if inc_otherlangs
    % Deal with VRML and VRMLX3DV possibilities
    if verLessThan('matlab', version_vrmlx3dv)
        names_color_vrml_usable = names_color_vrml;
    else
        names_color_vrml_usable = strrep(names_color_vrml, ...
            '.VRML.', '.VRMLX3DV.');
    end
    % Get the colours from the appropriate preference names
    [panel_prefs, panel_colors] = fetch_colors(names_color_vrml_usable);
    % If all the colours in this panel are black, we assume the color
    % settings have not loaded because they have not been set.
    if ~all(panel_colors==-16777216)
        for iPref = 1:numel(names_color_vrml)
            % Get the name for the color setting we are interested in
            nm = names_color_vrml{iPref};
            % Write its colour value to the output file
            fprintf(fid, '%s=C%d\n', nm, panel_colors(iPref));
        end
        % Remember the prefences so we can return them
        onames_langs = [onames_langs; names_color_otherlangs{iPanel}];
        cprefs_langs = [cprefs_langs; panel_prefs];
    end
end

% Do strings for other languages
if inc_otherlangs
    for iPref=1:size(names_string_otherlang, 1)
        % Get the name for the string preference we are interested in
        nm  = names_string_otherlang{iPref, 1};
        % Read the string
        str = com.mathworks.services.Prefs.getStringPref(nm);
        % Turn it from a java.lang.String object to a regular char object
        str = char(str);
        % Check it is okay
        if isempty(regexp(str, names_string_otherlang{iPref, 2}, ...
                    'start', 'emptymatch'))
            % It did not have any matches for the regex, so we will not use
            % this setting. We will assume its value is not available.
            continue;
        end
        % It matched the regex for acceptable values, so we will export it
        fprintf(fid, '%s=S%s\n', nm, str);
        % Remember the prefence so we can return it
        onames_langs = [onames_langs; nm];
        cprefs_langs = [cprefs_langs; str];
    end
end

% ------------------------ Tidy up ----------------------------------------
% fclose(fid); % Don't need to close as it will autoclose
if nargout>0; varargout{1} = 1; end;

fprintf('Exported color scheme to %s\n', fname);

if nargout>1;
    varargout{2} = cat(1, ...
                    names_boolean       , ...
                    names_integer       , ...
                    names_color_main{:} , ...
                    onames_versioned    , ...
                    onames_langs        );
    varargout{3} = cat(1, ...
                    prefs_boolean       , ...
                    prefs_integer       , ...
                    cprefs_main{:}      , ...
                    cprefs_versioned    , ...
                    cprefs_langs        );
end

end


function [prefs, colors] = fetch_colors(names)
    % Initialise holding variable for settings in this panel
    prefs = cell(size(names));
    colors = nan(size(names));
    % Loop over every colour setting in the panel
    for iName = 1:numel(names)
        % Read the preference for this colour and get a Java color object
        prefs{iName} = com.mathworks.services.Prefs.getColorPref(...
            names{iName});
        % Turn this into an integer colour value
        colors(iName) = prefs{iName}.getRGB;
    end
end