Contributing a colour scheme
============================

Glad to hear you've made a colour scheme to use with [MATLAB Schemer]!
Thanks for sharing this with us.

Please only add one colour scheme per pull request.
If you have multiple colorschemes to add, make a pull request for each of them.

It is preferable to include a screenshot demonstrating an example of your new MATLAB theme.
To make your screenshot, 

- Load your color scheme `schemer_import('yourscheme.prf')`
- Exit MATLAB `exit();`
- Reopen MATLAB
- Open the [matlab-schemer/develop/sample.m] file and take a screenshot with your favourite screenshot program. Here is an example for Linux users:
```bash
matlab -r "edit develop/sample.m" &
# If Editor is docked
wmctrl -a 'MATLAB R2015b'; gnome-screenshot -w -f yourscheme.png
# If Editor is undocked
wmctrl -a 'Editor'; gnome-screenshot -w -f yourscheme.png
```
- If not done at capture time, crop the screenshot down to the right size with your [favourite image editor].
- Make sure the screenshot is saved in [matlab-schemes/screenshots] as `yourscheme.png`.

Once you've added the new scheme to this repository, it will be merged into
[MATLAB Schemer] using [git-subtree].

[MATLAB Schemer]: https://github.com/scottclowe/matlab-schemer
[matlab-schemes/screenshots]: https://github.com/scottclowe/matlab-schemes/tree/master/screenshots
[matlab-schemer/develop/sample.m]: https://github.com/scottclowe/matlab-schemer/blob/master/develop/sample.m
[git-subtree]: https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt
[favourite image editor]: https://www.gimp.org
