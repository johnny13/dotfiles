#! /bin/bash


###############
#configure git#
###############
if [ ! -z "$git_user_email" ]; then
  ssh-keygen -t rsa -C "$git_user_email" -N "" -f ~/.ssh/id_rsa
  git config --global user.name "$git_user_name"
  git config --global user.email "$git_user_email"
  git config --global core.editor nano
  git config --global color.ui true

  echo "" >> /etc/bash.bashrc
  echo "alias commit='git add --all . && git commit -m'" >> /etc/bash.bashrc
  echo "alias push='git push -u origin master'" >> /etc/bash.bashrc
  echo "alias pull='git pull origin master'" >> /etc/bash.bashrc
fi


