Contributing
============

Adding a new colour scheme
--------------------------

If you have created a new colour scheme, please add it to the [matlab-schemes]
repository and *not* here. Instructions for this are available
[here](https://github.com/scottclowe/matlab-schemes/blob/master/CONTRIBUTING.md).

If you have already added a new colour scheme to [matlab-schemes] via an
accepted pull request and want to mirror the change in [matlab-schemer], you
will need to use [git-subtree].

Some general handy instructions for `git subtree` are available
[here](https://medium.com/@v/git-subtrees-a-tutorial-6ff568381844#.lwmv2uwwk),
[here](https://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/),
and [here](https://developer.atlassian.com/blog/2015/05/the-power-of-git-subtree/).
Specifically for use with this repository, the instructions are as follows.

You will first need to set up subtree so there is a remote tracking the
[matlab-schemes] repository in addition to the usual origin remote tracking
your fork of [matlab-schemer].
```bash
# One-time setup
git remote add matlab-schemes https://github.com/scottclowe/matlab-schemes.git
```

Having done this setup, you can now merge commits from matlab-schemes into
matlab-schemer as follows:
```bash
git pull
git subtree pull --prefix schemes matlab-schemes master
git push
```

Improving MATLAB Schemer
------------------------

If you have made enhancements or bug fixes to MATLAB Schemer, itself please add
them with a regular [pull request] to this repository.


  [matlab-schemer]: https://github.com/scottclowe/matlab-schemer
  [matlab-schemes]: https://github.com/scottclowe/matlab-schemes
  [git-subtree]: https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt
  [pull request]: https://help.github.com/articles/using-pull-requests/
