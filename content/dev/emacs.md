Title: Emacs
Date: 2017-01-21 11:45
Tags: dev
Slug: emacs
Author: Feng Xia
Modified: 2020-11-23 18:14

What a wonderful editor!

I wouldn't even call it an editor because it can do so much beyond
text editing. Still on the learning curve to get a grasp of what it
can do in my daily development workflow.

# install emacs26

The easiest way to get this: `sudo add-apt-repository
ppa:kelleyk/emacs`, then `apt remove emacs emacs25 && apt update &&
apt install emacs26`, then verify `emacs --version`.

# bootstrap & config

Welcome the wonderful `org-mode` and the [config file in org-mode][1]. Bootstrap is easy:

1. backup your current emacs: `mv ~/.emacs.d ~/.emacs.d.bak`
2. create `.emacs`, or copy [.emacs][2] to `~`.
3. launch emacs, sit back, and once all packages are downloaded and
   compiled, you are done.

# replace in files

Replacing a string match in multiple files is common, but
tricky. Emacs doesn't make this intuitive at all. Follow these steps
to get there:

1. `M-x find-grep-dired`
2. `Find-grep (directory)`: is to select the root folder for the scan
3. `Find-grep (grep regexp)`: is the regex for the string pattern you
   are searching, eg. `"images/` is to find anything starts with a
   double quote sign and `images/` after &larr; in my attempt to
   change image from relative path to absolute path.
4. A new buffer will open w/ the list of files that contains a match.
5. In that buffer, press `t` to select all (press `t` again will
   toggle it off).
6. Press `Q` (capital).
7. `Query replace regexp in marked files...`:
  1. set the old string
  2. `with:`: set new string

    If you skip these two steps, it will use the default (the previous replacement).
8. A buffer will open showing the line that can be replaced:

  - `y`: replace it
  - `n`: skip
  - `Y`: replace all w/ YES &rarr; and watch the mini buffer showing
    "x occurance" flashing so you know replacement is happening.
  - `q`: quit

9. `C-x s`, then `!` to save all buffers.

I find that the easiest way to revert a mistake is to `git checkout
-f`, then start this exercise from beginning.


Happy coding.

[1]: {filename}/downloads/emacs/emacs_setup.html
[2]: {filename}/downloads/emacs/dot_emacs.el
