# SaltStack state for bastion/jump host configuration.

bastion_packages:
  pkg.installed:
    - pkgs:
      - awscli
      - git
      - htop
      - jq

bastion_user:
  user.present:
    - name: bastionadmin
    - shell: /bin/bash
    - createhome: True

ssh_hardening:
  file.managed:
    - name: /etc/ssh/sshd_config.d/99-hardening.conf
    - contents: |
        PasswordAuthentication no
        PermitRootLogin no
        MaxAuthTries 3
    - require:
      - pkg: bastion_packages

sshd_service:
  service.running:
    - name: sshd
    - watch:
      - file: ssh_hardening
