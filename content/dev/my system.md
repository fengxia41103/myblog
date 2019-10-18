Title: My system
Date: 2019-10-08 19:05
Tags: dev
Slug: my system
Author: Feng Xia
Summary: Instructions to rebuild my system from scratch based on Ubuntu 18.04.
Modified: 2019-10-17 20:55


Now setting up my Flex Pro from scratch (well, it's too difficult to
get to its hard drive, so without ruining this beautiful machine, I
decided to install Ubuntu from scratch), I'm going to document (rather
a bit catch up) what I need to install in order to get my working
environment back.

# system files

```shell
apt install \
  git \
  terminator \
  conky \
  build-essential \
  python-pip \
  fonts-inconsolata \
  texlive-full \
  run-one \
  emacs \
  python-dev \
  i3 \
  wicd-curses \
  virtualenvwrapper \
  pandoc \
  dia \
  evince \
  gimp \
  pidgin \
  pidgin-sipe \
  git \
  dkms \
  openssh-server \
  openssh-client \
  tmux \
  python-mysqldb \
  mysql-client \
  libmysqlclient-dev \
  graphviz \
  libgraphviz-dev \
  imagemagick \
  libssl-dev \
  libcurl4-openssl-dev \
  pkg-config \
  libmemcached-dev \
  zlib1g-dev \
  libxml2-dev \
  libxslt1-dev \
  nginx \
  mplayer \
  vlc \
  youtube-dl \
  rsync \
  gthumb \
  libvirt-bin \
  virt-manager \
  virtinst \
  libvirt-bin \
  bridge-utils \
  cloud-utils \
  cloud-init \
  libguestfs-tools \
  pkg-config \
  uwsgi \
  uwsgi-plugin-python \
  cpu-checker \
  htop \
  tree \
  libffi6 \
  libffi-dev \
  gthumb \
  isync \
  mu4e \
  default-jre \
  openconnect \
  zsh \
  powerline \
  fonts-powerline \
  thunderbird \
  sshfs \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  remmina \
  pandoc-citeproc \

```

# local kvm setup

1. `sshkey-gen`: u can leave the passphrase to none (just ENTER).
2. `git clone http://github.com/fengxia41103/dev`.
  1. paste the content in `.ssh/id_rsa.pub` to `dev/kvm/my-user-data`:
     this will then allow KVM to be accessible using this key.

For more info on KVM, read [here][1].

# 4k display and font size

Fonts will be way too small on a 4k display. The best instruction I
found and works is [by ArchLinux][2].

First of all, **don't use `xrandr --outout <whatever> --scale
0.5x0.5`**. This will only decrease the resolution, which makes the
screen/font blurry!

Instead, there are two things you need to do:

1. Add these to `.Xresources` (if file doesn't exist, create
   one). Play w/ the `Xft.dpi` value &larr; the smaller the value, the
   smaller the font will be (you can check by evoking i3wm's menu bar
   `WIN+d`). No idea what the other values are. Then logout and log
   back in, you will be super happy!

        ```shell
        Xft.dpi: 200
        Xft.autohint: 0
        Xft.lcdfilter:  lcddefault
        Xft.hintstyle:  hintfull
        Xft.hinting: 1
        Xft.antialias: 1
        Xft.rgba: rgb
        ```
   Use `xdpyinfo` to check screen resolution[^1]:
   
     1. On X1 gen 8, it's shown `2560x1440 pixels (677x381
        millimeters)`. Set `dpi=180` gives the same exp/size as what was
        on gen 4 without any tweaking.
     2. On Flex pro, it gives `3840 x 2160`, use `dpi=200` is good; 180
        is too small.
      
2. For Gtk applications, eg. dia, add these to our `.zshrc` or `.bashrc`:

        ```shell
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export GDK_SCALE=2
        ```

# disable NetworkManager

You have to disable NetworkManager service in order for wicd to take
over cleanly:

1. stop service: `systemctl stop NetworkManager`
2. disable the service: `systemctl disable NetworkManager.service`
3. uninstall: `apt remove network-manager-gnome network-manager`
4. purge: `dpkg --purge network-manager-gnome network-manager`

Without doing so will also mess up the `openconnect` when it is not
able to modify `/etc/resolv.conf` after its connection.

# nvm and Node.js stuff

1. Install [nvm][3]. Then, `nvm install node` will install the latest
   version. Or, do `nvm install <versaion>`. Use `nvm ls-remote` to
   find which versions are available for installation.
2. Update npm `npm install npm@latest -g`.
3. Install bower, `npm install -g bower `.
4. Now go to `myblog/template/feng/static`, and run `bower install`.

# zsh

Follow [this blog][4], and you will get a cool looking shell:

1. `git clone https://github.com/robbyrussell/oh-my-zsh.git
   ~/.oh-my-zsh`
2. `cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`
3. change theme in `.zshrc` to `ZSH_THEME="agnoster"`
4. Set zsh as the default shell: `chsh -s /bin/zsh`
5. `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
   "$HOME/.zsh-syntax-highlighting" --depth 1`
6. `echo "source
   $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>
   "$HOME/.zshrc"`

If you want to revert back to bash: `chsh -s /bin/bash`.

# sshfs

Use this to mount another machine's file system into your local. This
is a great way to share the same code between your localhost and vms.

1. `apt install sshfs`
2. Uncomment `user_allow_other` in `/etc/fuse.conf`.
3. to mount: `sshfs -o allow_other
   fengxia@192.168.1.112:/home/fengxia/workspace ./tmp` &larr; mount
   remove `workspace/` to your local `./tmp`.

# i3

Under `~/.config`, find two folder named `i3/` and `i3status`. Copy
[i3.conf][5] to `i3/config`, and [i3status.confg][6] to
`i3status/i3status.conf`.

# pandoc

Use Pandoc [2.7.3][7]. The v1.9 in Ubuntu 18.04 didn't work for compiling
[RA PDF][8]. Read [this article][9] for more details of my Pandoc notes.

1. `pip install pandoc-fignos`
2. `apt install pandoc-citeproc texlive-full`
3. optional: install `mermaid-filter`: `npm install -g mermaid-filter`

# enterprise stuff

Working in an enterprise means that you need a few tools, eg. emails,
to work w/ everybody else (which == Microsoft, actually, sigh).

1. for Cisco's Anyconnect vpn: [here][10]

2. for emails: [mbsync & davmail][11], or [thunderbird][10]. But
   honestly, setting up [Davmail][11] is a lot better, and you can
   have Thunderbird acting as just an email agent off davmail anyway.

3. for Skype business/Lync: use [pidgin][10].

[1]: {filename}/dev/kvm.md
[2]: https://wiki.archlinux.org/index.php/HiDPI
[3]: https://github.com/nvm-sh/nvm
[4]: https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
[5]: {static}/downloads/i3.conf
[6]: {static}/downloads/i3status.conf
[7]: https://github.com/jgm/pandoc/releases/tag/2.7.3
[8]: {static}/downloads/loc%20ra.pdf
[9]: {filename}/dev/pandoc.md
[10]: {filename}/dev/lenovo%20linux%20box.md
[11]: {filename}/dev/mbsync.md

[^1]: To check screen resolution: `xdpyinfo | grep dimensions`.
