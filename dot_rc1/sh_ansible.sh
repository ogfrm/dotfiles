##############    OZ   ###############

ans_alisas () {
  if [ -d $1 ] ; then
    alias anscd$2="export ANSIBLE_CONFIG=$1/ansible.cfg;cd $1"
    alias ansp$2="ansible-playbook local.yml"
    alias ansrun$2="ans_run $1 local.yml"
    alias ansrunc$2="ans_run $1 'local.yml -C'"
    # ansapp_ oz 'eeee,ll  11l,333' -C
    alias ansapp$2="ans_runapp $1 'local.yml' APPS ''"
    alias anscon$2="ans_runapp $1 'local.yml' CONTAINERS ''"
    alias ansconf$2="ans_runapp $1 'local.yml' CONTAINERS _force"
    alias ansconpurge$2="ans_runapp $1 'local.yml' CONTAINERS _purge"
  fi
}
ans_runapp() {
  apps=$(echo "$6" | sed 's/,/","/g')
  tagslower=$(echo "$3" | awk '{print tolower($0)}')
  ans_run  $1 $2 $5 $tagslower$4 "{\"__e_$3\": [\"$apps\"]}" $7
}
ans_run() {
  \cd $1
  limits="";tags=""
  [ -z "${3}" ] || limits="-l $3"
  [ -z "${4}" ] || tags="-t $4"
  # [ -z "${5}" ] || env="-e '''$5'''"
  export ANSIBLE_CONFIG=$1/ansible.cfg
  mkdir -p $1/tree
  export ANSIBLE_CALLBACK_TREE_DIR=$1/tree
  echo $1
  unset ANSIBLE_CALLBACKS_ENABLED
  # export ANSIBLE_CALLBACKS_ENABLED=ansible.builtin.tree
  # export ANSIBLE_CALLBACKS_ENABLED=ansible.builtin.tree,ansible.posix.timer,ansible.posix.profile_roles,ansible.posix.profile_tasks
  echo ansible-playbook $2 $limits $tags -e ''$5'' $6
  ansible-playbook $2 $limits $tags -e ''$5'' $6
  \cd $OLDPWD
}
# if ! command -v <the_command> &> /dev/null
if [ -x "$(command -v ansible)" ]; then
  ans_alisas "/mnt/c/Users/$USERNAME/Desktop/Projects/automation/ansible/ansible"
  ans_alisas "/mnt/c/Users/$USERNAME/Desktop/git_me/automation/ansible/ansible" 1
fi
ans_timer_on() {
  # export ANSIBLE_CALLBACKS_ENABLED="timer, profile_tasks, profile_roles"
  export ANSIBLE_CALLBACKS_ENABLED=ansible.posix.timer,ansible.posix.profile_roles,ansible.posix.profile_tasks
}
ans_timer_off() {
  unset ANSIBLE_CALLBACKS_ENABLED
}
