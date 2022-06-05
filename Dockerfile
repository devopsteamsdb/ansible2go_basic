FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python3-pip sshpass git openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
    
RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible-core ansible && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost ansible_connection=local' > /etc/ansible/hosts

RUN ansible-galaxy collection install ansible.netcommon && \
    ansible-galaxy collection install ansible.utils && \
    ansible-galaxy collection install ansible.windows && \
    ansible-galaxy collection install cisco.aci && \
    ansible-galaxy collection install cisco.ios && \
    ansible-galaxy collection install community.crypto && \
    ansible-galaxy collection install community.docker && \
    ansible-galaxy collection install community.general && \
    ansible-galaxy collection install community.vmware && \
    ansible-galaxy collection install community.windows && \
    ansible-galaxy collection install check_point.mgmt && \
    ansible-galaxy collection install netapp.ontap

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
