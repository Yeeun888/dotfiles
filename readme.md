# My Dotfiles
Contains all important dotfiles for configuring my stuff

**Dependent on GNU Stow only**
Importantly when installing the "dotfiles" repo into a non-home directory, use the command

1. Clone the repo into `$HOME`! This is important.
```
cd $HOME
git clone git@github.com:Yeeun888/dotfiles.git
```

2. Use the install script to stow everything. **Don't do this if you don't want everything.**
```
cd dotfiles
./install.sh
```

3. Optionally clone them one by one depending what you want.
```
stow --target=$HOME name_of_config
```

Example: 
```
stow --target=$HOME nvim
```
