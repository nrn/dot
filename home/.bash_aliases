alias l='ls -ltrahG'
set -o vi

#git config --global url.https://github.com/.insteadOf git://github.com/

PATH="$HOME/bin:/usr/local/bin:$PATH:$HOME/.bin:/usr/local/mysql/bin"

DOCKER_HOST=tcp://localhost:55123

proxyserver="yourproxyserver.com:8080"

function proxy(){
  echo -n "Proxy Server ($proxyserver):" 
  read -e promptproxy
  proxyserver=${promptproxy:-$proxyserver}
  echo -n "Username ($USER):"
  read -e proxyuser
  proxyuser=${proxyuser:-$USER}
  echo -n "password:"
  read -es password
  export http_proxy="http://$proxyuser:$password@$proxyserver"
  export https_proxy=$http_proxy
  export ftp_proxy="ftp://$proxyuser:$password@$proxyserver"
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.local"
  alias sudop="sudo http_proxy=$http_proxy https_proxy=$https_proxy ftp_proxy=$ftp_proxy no_proxy=$no_proxy"
  echo -e "\nProxy environment variable set."
}
 
function proxyoff(){
  unset HTTP_PROXY
  unset http_proxy
  unset HTTPS_PROXY
  unset https_proxy
  unset FTP_PROXY
  unset ftp_proxy
  unalias sudop
  echo -e "\nProxy environment variable removed."
}

function review(){
  files=`git diff --diff-filter=ACMTUXB --name-only --relative`
  vim $files +Gdiff
}

function vimg() {
 files=`git grep -Ie $1 --name-only`
 vim $files +/$1
}

function lint_update() {
  npm install -g \
    eslint\
    eslint-config-standard\
    eslint-config-standard-react\
    eslint-plugin-react\
    eslint-plugin-standard\
    babel-eslint
}

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
# if [ -f "${SSH_ENV}" ]; then
#   . "${SSH_ENV}" > /dev/null
#   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#     start_agent;
#   }
# else
#   start_agent;
# fi

