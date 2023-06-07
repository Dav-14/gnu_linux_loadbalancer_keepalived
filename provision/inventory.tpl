[master]
${master_hostname} ansible_host=${master_host_ip} ansible_user=ansible ansible_ssh_private_key=${master_ssh_private_key}

[node]
%{ for server in jsondecode(other_servers) ~}
${server.hostname} ansible_host=${server.ip} ansible_user=ansible ansible_ssh_private_key=${master_ssh_private_key}
%{ endfor ~}
