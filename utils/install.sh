#!/bin/sh

if [ -d $HOME/.config/nvim ]
then
    cd ~/.config/nvim ; git pull
else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/andrzejsliwa/nvim.git ~/.config/nvim;
fi
ln -s $HOME/.config/nvim/tmux.conf $HOME/.tmux.conf