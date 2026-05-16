# ansible_main Project

```bash

apt install python3-passlib

ansible-vault encrypt --encrypt-vault-id default --vault-password-file ~/.ssh/.ansible_key ./group_vars/all/all__sifre.yml
ansible-vault decrypt --vault-password-file ~/.ssh/.ansible_key ./group_vars/all/all__sifre.yml

ansible-playbook local.yml -l oz -t backup1,backuplocal
ansible-playbook local.yml -l oz -t apps_pkgs
ansible-playbook local.yml -l oz -t apps_yml
ansible-playbook local.yml -l oz -t apps_yml
tags: backup backup1 backup2 backuplocal
      system,update,upgrade security,ssh_port
      apps apps_pcks apps_yml apps_pipx
      users,users_add,users_files,users_clean
ansible-playbook local.yml -l localhost -t apps_yml  -e '{"__e_apps": ["eza"]}'
ansible-playbook local.yml -l localhost -t dc_-cp_force  -e '{"__e_dc_1": ["dockpeek"]}'
ansible-playbook local.yml -l pvevm1 -t pve -e '{"__e_pve": ["pve_proxmenux"]}'
ansible-playbook local.yml -l oza4 -t all,vm_del,vm_crt,vm_snap,backup,backuplocal,backupfilelist
```