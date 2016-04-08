Contributing a colour scheme
============================

Glad to hear you've made a colour scheme to use with [MATLAB Schemer]!
Thanks for sharing this with us.

Please only add one colour scheme per pull request.
If you have multiple colorschemes to add, make a pull request for each of them.

It is preferable to include a screenshot demonstrating an example of your new MATLAB theme.
To make your screenshot, 

- Load your color scheme `schemer_import('yourscheme.prf', 1)`
- Exit MATLAB `exit();`
- Reopen MATLAB
- Open the [matlab-schemer/develop/sample.m] file and take a screenshot with your favourite screenshot program.
- If not done at capture time, crop the screenshot down to the right size with your [favourite image editor].
- Make sure the screenshot is saved in [matlab-schemes/screenshots] as `yourscheme.png`.


Reproducible screenshot workflow for Linux
------------------------------------------

Here is workflow for Linux users, which will create the same screenshots
every time.

1.  **Setup**

    Define these variables appropriately.

    ```bash
    # Set this variable appropriately, without extension
    SCHEME_NAME='yourschemename'
    # Set the path to your copy of MATLAB Schemer
    PATH_TO_SCHEMER='../matlab-schemer/'
    ```

2.  **Load scheme**

    Run this code block to load the scheme, restart MATLAB, and edit
    `sample.m`.

    ```bash
    # Remove extension, if present
    SCHEME_NAME=${SCHEME_NAME%.prf}
    echo "Making screenshot for scheme $SCHEME_NAME";
    # Load the template and restart matlab
    matlab -r "addpath(genpath('$PATH_TO_SCHEMER')); schemer_import('$SCHEME_NAME.prf',1); exit;";
    # Edit the sample.m file
    matlab -r "edit(fullfile('$PATH_TO_SCHEMER','develop','sample.m'))" &
    # What next
    echo "Now undock sample.m, and highlight middle scaleFactor";
    ```

3.  **Undock sample.m editor**

    Either
    - in MATLAB GUI, undock `sample.m` only

    Or
    - in MATLAB GUI, undock the Editor panel
    - move tabs to bottom, if more than one file is being editted

4.  **Highlight**

    Highlight the middle instance of `scaleFactor` (on line 18).

5.  **Resize window and take screenshot**

    Run this code block to resize the editor window and take a screenshot,
    cropped with ImageMagick.

    The crop location is correct for MATLAB 2016a.

    ```bash
    # Check for a window for the develop/sample.m file
    if wmctrl -l | grep -q develop/sample.m
    then
        WINDOW_NAME='develop/sample.m';
    else
        # If it's not there, use the Editor window
        WINDOW_NAME='Editor';
    fi
    if wmctrl -l | grep -qv "$WINDOW_NAME"
    then
        echo "Window $WINDOW_NAME is absent";
    fi
    # Resize the window
    wmctrl -r "$WINDOW_NAME" -e 0,100,100,700,650;
    # Try getting screenshot with Imagemagick, and cropping it down to the
    # just the relevant section
    wmctrl -a "$WINDOW_NAME"; sleep 0.1; import -window root -crop 700x379+100+249 +repage "${SCHEME_NAME}.png";
    # Inspect the result
    xdg-open "${SCHEME_NAME}.png";
    # Is it cropped correctly?
    echo "How does it look? If no good, try one of the other options to manually crop";
    ```

6.  If screenshot cropped incorrectly, **manually crop screenshot**

    If the ImageMagick crop is not aligned correctly, 
    - Either use gnome-screenshot for the whole window, and then crop in GIMP
      ```bash
      wmctrl -a "$WINDOW_NAME" \
          && gnome-screenshot -w -f "$SCHEME_NAME.png" \
          && gimp "$SCHEME_NAME.png";
      ```

    - Or use gnome-screenshot to select the area to use (which is likely to
      be less precise).
      ```bash
      wmctrl -a "$WINDOW_NAME" && gnome-screenshot -a -f "$SCHEME_NAME.png";
      ```

7.  When you are happy, **move** the final copy into the screenshots folder

    ```bash
    mv "$SCHEME_NAME.png" screenshots/"$SCHEME_NAME.png";
    ```


Incorporating into MATLAB Schemer
---------------------------------

Once you've added the new scheme to this repository, it will be merged into
[MATLAB Schemer] using [git-subtree].
If you are merging it into Schemer yourself, please consult this
[step-by-step guide](https://github.com/scottclowe/matlab-schemer/blob/master/CONTRIBUTING.md).


  [MATLAB Schemer]: https://github.com/scottclowe/matlab-schemer
  [matlab-schemes/screenshots]: https://github.com/scottclowe/matlab-schemes/tree/master/screenshots
  [matlab-schemer/develop/sample.m]: https://github.com/scottclowe/matlab-schemer/blob/master/develop/sample.m
  [git-subtree]: https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt
  [favourite image editor]: https://www.gimp.org
