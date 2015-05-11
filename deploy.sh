cp zshrc ~/.zshrc
cp vimrc ~/.vimrc

install -d ~/.terminfo
tic -o ~/.terminfo/ ~/rxvt-unicode-256color.terminfo
