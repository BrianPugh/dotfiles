This uses [yadm](https://yadm.io), which is basically a lightweight wrapper around git to store your config files in a repo. There are other ways of managing your dotfiles with more generic tools, but yadm is lightweight enough and offers enough "just works" that its worth it.

# Usage

This is standard yadm stuff copied here for convenience.

### Mac

```
# Install yadm on your system
brew install yadm

# Clone py repo
# or yadm clone git@github.com:BrianPugh/dotfiles.git if you're me.
yadm clone https://github.com/BrianPugh/dotfiles.git

# runs my installation script located at ~/.config/yadm/bootstrap
yadm bootstrap
```

### Ubuntu

```
# Install yadm on your system
sudo apt install yadm

# Clone py repo
# or yadm clone git@github.com:BrianPugh/dotfiles.git if you're me.
yadm clone https://github.com/BrianPugh/dotfiles.git

# runs my installation script located at ~/.config/yadm/bootstrap
yadm bootstrap
```

