понимать принцип работы мостов и туннелей;
настраивать мосты и туннели в Linux;
поднять свой VPN-сервер;

| Назначение | Адрес сервера | Адрес клиента | Транспорт |
|---|---|---|---|
| Внутренняя сеть VirtualBox | `172.26.77.10` | `172.26.77.11` | Internal Network |
| OpenVPN TUN | `10.77.1.1` | `10.77.1.2` | UDP/1195 |
| OpenVPN TAP | `10.77.2.1` | `10.77.2.2` | UDP/1196 |
| OpenVPN RAS | `10.79.0.1` | Из пула `10.79.0.0/24` | UDP/11940 на хосте → UDP/1194 ВМ |


##  Поднять ВМ

На хосте Linux нужны Vagrant, VirtualBox, Ansible и OpenVPN-клиент для локальной проверки RAS. Все блоки выполняются в Bash из корня проекта.

```bash
root@nfsc:~/vpn-lab# vagrant validate &&
  ansible-playbook --syntax-check -i localhost, ansible/provision.yml &&
  vagrant up vpnServer --provider=virtualbox &&
  vagrant up vpnClient --provider=virtualbox &&
  vagrant status
Vagrantfile validated successfully.

playbook: ansible/provision.yml
Bringing machine 'vpnServer' up with 'virtualbox' provider...
==> vpnServer: Importing base box 'generic/ubuntu2004'...
==> vpnServer: Matching MAC address for NAT networking...
==> vpnServer: Setting the name of the VM: otus-vpn-lab-vpnServer
==> vpnServer: Clearing any previously set network interfaces...
==> vpnServer: Preparing network interfaces based on configuration...
    vpnServer: Adapter 1: nat
    vpnServer: Adapter 2: intnet
==> vpnServer: Forwarding ports...
    vpnServer: 1194 (guest) => 11940 (host) (adapter 1)
    vpnServer: 22 (guest) => 2222 (host) (adapter 1)
==> vpnServer: Running 'pre-boot' VM customizations...
==> vpnServer: Booting VM...
==> vpnServer: Waiting for machine to boot. This may take a few minutes...
    vpnServer: SSH address: 127.0.0.1:2222
    vpnServer: SSH username: vagrant
    vpnServer: SSH auth method: private key
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Remote connection disconnect. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer: Warning: Connection reset. Retrying...
    vpnServer:
    vpnServer: Vagrant insecure key detected. Vagrant will automatically replace
    vpnServer: this with a newly generated keypair for better security.
    vpnServer:
    vpnServer: Inserting generated public key within guest...
    vpnServer: Removing insecure key from the guest if it's present...
    vpnServer: Key inserted! Disconnecting and reconnecting using new SSH key...
==> vpnServer: Machine booted and ready!
==> vpnServer: Checking for guest additions in VM...
    vpnServer: The guest additions on this VM do not match the installed version of
    vpnServer: VirtualBox! In most cases this is fine, but in rare cases it can
    vpnServer: prevent things such as shared folders from working properly. If you see
    vpnServer: shared folder errors, please make sure the guest additions within the
    vpnServer: virtual machine match the version of VirtualBox you have installed on
    vpnServer: your host and reload your VM.
    vpnServer:
    vpnServer: Guest Additions Version: 6.1.38
    vpnServer: VirtualBox Version: 7.0
==> vpnServer: Setting hostname...
==> vpnServer: Configuring and enabling network interfaces...
==> vpnServer: Running provisioner: ansible...
    vpnServer: Running ansible-playbook...

PLAY [Развернуть лабораторию OpenVPN] ******************************************

TASK [Gathering Facts] *********************************************************
ok: [vpnServer]

TASK [Проверить наличие локального ключа для клиентской ВМ] ********************
skipping: [vpnServer]

TASK [Проверить порядок запуска] ***********************************************
skipping: [vpnServer]

TASK [Создать каталог настройки DNS] *******************************************
changed: [vpnServer]

TASK [Использовать DNS VirtualBox для установки пакетов] ***********************
changed: [vpnServer]

TASK [Применить настройку DNS] *************************************************
changed: [vpnServer]

TASK [Установить OpenVPN и iperf3] *********************************************
changed: [vpnServer]

TASK [Создать каталог конфигурации OpenVPN] ************************************
changed: [vpnServer]

TASK [Сгенерировать ключ на сервере] *******************************************
changed: [vpnServer]

TASK [Прочитать ключ для передачи клиентской ВМ] *******************************
ok: [vpnServer]

TASK [Сохранить ключ в локальном состоянии Vagrant] ****************************
changed: [vpnServer -> localhost]

TASK [Установить общий ключ на клиенте] ****************************************
skipping: [vpnServer]

TASK [Настроить туннели TUN и TAP] *********************************************
changed: [vpnServer] => (item={'mode': 'tun', 'port': 1195})
changed: [vpnServer] => (item={'mode': 'tap', 'port': 1196})

TASK [Установить службу OpenVPN] ***********************************************
changed: [vpnServer]

TASK [Запустить оба туннеля] ***************************************************
changed: [vpnServer] => (item={'mode': 'tun', 'port': 1195})
changed: [vpnServer] => (item={'mode': 'tap', 'port': 1196})

TASK [Установить службу iperf3] ************************************************
changed: [vpnServer]

TASK [Запустить iperf3] ********************************************************
changed: [vpnServer]

TASK [Создать PKI на сервере] **************************************************
changed: [vpnServer]

TASK [Сохранить конфигурацию RAS] **********************************************
changed: [vpnServer]

TASK [Запустить RAS] ***********************************************************
changed: [vpnServer]

TASK [Прочитать только сертификаты и ключи, нужные клиенту] ********************
ok: [vpnServer] => (item=None)
ok: [vpnServer] => (item=None)
ok: [vpnServer] => (item=None)
ok: [vpnServer] => (item=None)
ok: [vpnServer]

TASK [Сохранить клиентский профиль на хосте] ***********************************
changed: [vpnServer -> localhost]

PLAY RECAP *********************************************************************
vpnServer                  : ok=19   changed=16   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

Bringing machine 'vpnClient' up with 'virtualbox' provider...
==> vpnClient: Importing base box 'generic/ubuntu2004'...
==> vpnClient: Matching MAC address for NAT networking...
==> vpnClient: Setting the name of the VM: otus-vpn-lab-vpnClient
==> vpnClient: Fixed port collision for 22 => 2222. Now on port 2200.
==> vpnClient: Clearing any previously set network interfaces...
==> vpnClient: Preparing network interfaces based on configuration...
    vpnClient: Adapter 1: nat
    vpnClient: Adapter 2: intnet
==> vpnClient: Forwarding ports...
    vpnClient: 22 (guest) => 2200 (host) (adapter 1)
==> vpnClient: Running 'pre-boot' VM customizations...
==> vpnClient: Booting VM...
==> vpnClient: Waiting for machine to boot. This may take a few minutes...
    vpnClient: SSH address: 127.0.0.1:2200
    vpnClient: SSH username: vagrant
    vpnClient: SSH auth method: private key
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient: Warning: Connection reset. Retrying...
    vpnClient:
    vpnClient: Vagrant insecure key detected. Vagrant will automatically replace
    vpnClient: this with a newly generated keypair for better security.
    vpnClient:
    vpnClient: Inserting generated public key within guest...
    vpnClient: Removing insecure key from the guest if it's present...
    vpnClient: Key inserted! Disconnecting and reconnecting using new SSH key...
==> vpnClient: Machine booted and ready!
==> vpnClient: Checking for guest additions in VM...
    vpnClient: The guest additions on this VM do not match the installed version of
    vpnClient: VirtualBox! In most cases this is fine, but in rare cases it can
    vpnClient: prevent things such as shared folders from working properly. If you see
    vpnClient: shared folder errors, please make sure the guest additions within the
    vpnClient: virtual machine match the version of VirtualBox you have installed on
    vpnClient: your host and reload your VM.
    vpnClient:
    vpnClient: Guest Additions Version: 6.1.38
    vpnClient: VirtualBox Version: 7.0
==> vpnClient: Setting hostname...
==> vpnClient: Configuring and enabling network interfaces...
==> vpnClient: Running provisioner: ansible...
    vpnClient: Running ansible-playbook...

PLAY [Развернуть лабораторию OpenVPN] ******************************************

TASK [Gathering Facts] *********************************************************
ok: [vpnClient]

TASK [Проверить наличие локального ключа для клиентской ВМ] ********************
ok: [vpnClient -> localhost]

TASK [Проверить порядок запуска] ***********************************************
ok: [vpnClient] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Создать каталог настройки DNS] *******************************************
changed: [vpnClient]

TASK [Использовать DNS VirtualBox для установки пакетов] ***********************
changed: [vpnClient]

TASK [Применить настройку DNS] *************************************************
changed: [vpnClient]

TASK [Установить OpenVPN и iperf3] *********************************************
changed: [vpnClient]

TASK [Создать каталог конфигурации OpenVPN] ************************************
changed: [vpnClient]

TASK [Сгенерировать ключ на сервере] *******************************************
skipping: [vpnClient]

TASK [Прочитать ключ для передачи клиентской ВМ] *******************************
skipping: [vpnClient]

TASK [Сохранить ключ в локальном состоянии Vagrant] ****************************
skipping: [vpnClient]

TASK [Установить общий ключ на клиенте] ****************************************
changed: [vpnClient]

TASK [Настроить туннели TUN и TAP] *********************************************
changed: [vpnClient] => (item={'mode': 'tun', 'port': 1195})
changed: [vpnClient] => (item={'mode': 'tap', 'port': 1196})

TASK [Установить службу OpenVPN] ***********************************************
changed: [vpnClient]

TASK [Запустить оба туннеля] ***************************************************
changed: [vpnClient] => (item={'mode': 'tun', 'port': 1195})
changed: [vpnClient] => (item={'mode': 'tap', 'port': 1196})

TASK [Установить службу iperf3] ************************************************
skipping: [vpnClient]

TASK [Запустить iperf3] ********************************************************
skipping: [vpnClient]

TASK [Создать PKI на сервере] **************************************************
skipping: [vpnClient]

TASK [Сохранить конфигурацию RAS] **********************************************
skipping: [vpnClient]

TASK [Запустить RAS] ***********************************************************
skipping: [vpnClient]

TASK [Прочитать только сертификаты и ключи, нужные клиенту] ********************
skipping: [vpnClient] => (item=None)
skipping: [vpnClient] => (item=None)
skipping: [vpnClient] => (item=None)
skipping: [vpnClient] => (item=None)
skipping: [vpnClient]

TASK [Сохранить клиентский профиль на хосте] ***********************************
skipping: [vpnClient]

PLAY RECAP *********************************************************************
vpnClient                  : ok=12   changed=9    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0

Current machine states:

vpnServer                 running (virtualbox)
vpnClient                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
root@nfsc:~/vpn-lab#

```



##  Проверить туннели

```bash
root@nfsc:~/vpn-lab# vagrant ssh vpnClient -c '
  systemctl is-active otus-openvpn@tun otus-openvpn@tap &&
  ip -br -4 addr show tunbench &&
  ip -br -4 addr show tapbench &&
  ip -4 route get 10.77.1.1 &&
  ip -4 route get 10.77.2.1 &&
  ping -c 2 -W 2 10.77.1.1 &&
  ping -c 2 -W 2 10.77.2.1
'
active
active
tunbench         UNKNOWN        10.77.1.2 peer 10.77.1.1/32
tapbench         UNKNOWN        10.77.2.2/24
10.77.1.1 dev tunbench src 10.77.1.2 uid 1000
    cache
10.77.2.1 dev tapbench src 10.77.2.2 uid 1000
    cache
PING 10.77.1.1 (10.77.1.1) 56(84) bytes of data.
64 bytes from 10.77.1.1: icmp_seq=1 ttl=64 time=6.10 ms
64 bytes from 10.77.1.1: icmp_seq=2 ttl=64 time=6.59 ms

--- 10.77.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 6.099/6.343/6.587/0.244 ms
PING 10.77.2.1 (10.77.2.1) 56(84) bytes of data.
64 bytes from 10.77.2.1: icmp_seq=1 ttl=64 time=12.8 ms
64 bytes from 10.77.2.1: icmp_seq=2 ttl=64 time=6.48 ms

--- 10.77.2.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 6.484/9.624/12.765/3.140 ms
root@nfsc:~/vpn-lab#

```

Ожидаются маршруты к адресам сервера через `tunbench` и `tapbench` 

```bash
root@nfsc:~/vpn-lab# vagrant ssh vpnClient -c 'sudo journalctl -b -u otus-openvpn@tun -u otus-openvpn@tap -n 50 --no-pager'
-- Logs begin at Tue 2026-11-10 08:12:09 UTC, end at Tue 2026-11-10 08:39:19 UTC. --
Nov 10 08:22:06 vpnclient systemd[1]: Started OTUS OpenVPN instance tun.
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 disabling NCP mode (--ncp-disable) because not in P2MP client or server mode
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 OpenVPN 2.4.12 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Jun 27 2024
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 library versions: OpenSSL 1.1.1f  31 Mar 2020, LZO 2.10
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 Outgoing Static Key Encryption: Cipher 'AES-256-CBC' initialized with 256 bit key
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 Outgoing Static Key Encryption: Using 256 bit message hash 'SHA256' for HMAC authentication
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 Incoming Static Key Encryption: Cipher 'AES-256-CBC' initialized with 256 bit key
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 Incoming Static Key Encryption: Using 256 bit message hash 'SHA256' for HMAC authentication
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 WARNING: normally if you use --mssfix and/or --fragment, you should also set --tun-mtu 1500 (currently it is 1400)
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 TUN/TAP device tunbench opened
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 TUN/TAP TX queue length set to 100
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 /sbin/ip link set dev tunbench up mtu 1400
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 /sbin/ip addr add dev tunbench local 10.77.1.2 peer 10.77.1.1
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 TCP/UDP: Preserving recently used remote address: [AF_INET]172.26.77.10:1195
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 Socket Buffers: R=[212992->212992] S=[212992->212992]
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 UDPv4 link local (bound): [AF_INET]172.26.77.11:1195
Nov 10 08:22:06 vpnclient openvpn[3996]: Tue Nov 10 08:22:06 2026 UDPv4 link remote: [AF_INET]172.26.77.10:1195
Nov 10 08:22:12 vpnclient systemd[1]: Started OTUS OpenVPN instance tap.
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 disabling NCP mode (--ncp-disable) because not in P2MP client or server mode
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 OpenVPN 2.4.12 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Jun 27 2024
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 library versions: OpenSSL 1.1.1f  31 Mar 2020, LZO 2.10
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 Outgoing Static Key Encryption: Cipher 'AES-256-CBC' initialized with 256 bit key
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 Outgoing Static Key Encryption: Using 256 bit message hash 'SHA256' for HMAC authentication
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 Incoming Static Key Encryption: Cipher 'AES-256-CBC' initialized with 256 bit key
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 Incoming Static Key Encryption: Using 256 bit message hash 'SHA256' for HMAC authentication
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:12 2026 WARNING: normally if you use --mssfix and/or --fragment, you should also set --tun-mtu 1500 (currently it is 1400)
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 TUN/TAP device tapbench opened
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 TUN/TAP TX queue length set to 100
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 /sbin/ip link set dev tapbench up mtu 1400
Nov 10 08:22:13 vpnclient openvpn[3996]: Tue Nov 10 08:22:13 2026 Peer Connection Initiated with [AF_INET]172.26.77.10:1195
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 /sbin/ip addr add dev tapbench 10.77.2.2/24 broadcast 10.77.2.255
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 TCP/UDP: Preserving recently used remote address: [AF_INET]172.26.77.10:1196
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 Socket Buffers: R=[212992->212992] S=[212992->212992]
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 UDPv4 link local (bound): [AF_INET]172.26.77.11:1196
Nov 10 08:22:13 vpnclient openvpn[4098]: Tue Nov 10 08:22:13 2026 UDPv4 link remote: [AF_INET]172.26.77.10:1196
Nov 10 08:22:14 vpnclient openvpn[3996]: Tue Nov 10 08:22:14 2026 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Nov 10 08:22:14 vpnclient openvpn[3996]: Tue Nov 10 08:22:14 2026 Initialization Sequence Completed
Nov 10 08:22:24 vpnclient openvpn[4098]: Tue Nov 10 08:22:24 2026 Peer Connection Initiated with [AF_INET]172.26.77.10:1196
Nov 10 08:22:25 vpnclient openvpn[4098]: Tue Nov 10 08:22:25 2026 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Nov 10 08:22:25 vpnclient openvpn[4098]: Tue Nov 10 08:22:25 2026 Initialization Sequence Completed
root@nfsc:~/vpn-lab#

```

##  Измерить скорость

Команды выполняют три последовательных прогона по 40 секунд в каждом режиме. Между прогонами чередуются TUN и TAP. Результаты сохраняются в `results/`. Сравни `receiver` в Мбит/с, используя одинаковый показатель для обоих режимов.

```bash
root@nfsc:~/vpn-lab# mkdir -p results
for run in 1 2 3; do
  vagrant ssh vpnClient -c 'iperf3 -c 10.77.1.1 -P 1 -t 40 -i 5' > "results/tun-${run}.txt" &&
    vagrant ssh vpnClient -c 'iperf3 -c 10.77.2.1 -P 1 -t 40 -i 5' > "results/tap-${run}.txt" ||
    break
done
grep -H 'receiver' results/*.txt
results/tap-1.txt:[  5]   0.00-40.26  sec  27.4 MBytes  5.70 Mbits/sec                  receiver
results/tap-2.txt:[  5]   0.00-40.18  sec  21.4 MBytes  4.46 Mbits/sec                  receiver
results/tap-3.txt:[  5]   0.00-40.02  sec  21.8 MBytes  4.57 Mbits/sec                  receiver
results/tun-1.txt:[  5]   0.00-40.30  sec  28.4 MBytes  5.91 Mbits/sec                  receiver
results/tun-2.txt:[  5]   0.00-40.09  sec  21.9 MBytes  4.58 Mbits/sec                  receiver
results/tun-3.txt:[  5]   0.00-41.03  sec  22.1 MBytes  4.52 Mbits/sec                  receiver
root@nfsc:~/vpn-lab#

```

## Подключить RAS с хоста


```bash
vagrant ssh vpnServer -c '"'"'systemctl is-active otus-openvpn@ras; ip -br -4 addr show tunras'"'"'
test -s .vagrant/vpn-ras.ovpn && ls -l .vagrant/vpn-ras.ovpn
root@nfsc:~/vpn-lab# cd ~/vpn-lab
openvpn --config .vagrant/vpn-ras.ovpn
2026-11-10 09:37:20 Note: --cipher is not set. OpenVPN versions before 2.5 defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
2026-11-10 09:37:20 Note: Kernel support for ovpn-dco missing, disabling data channel offload.
2026-11-10 09:37:20 OpenVPN 2.6.19 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] [DCO]
2026-11-10 09:37:20 library versions: OpenSSL 3.0.13 30 Jan 2024, LZO 2.10
2026-11-10 09:37:20 DCO version: N/A
2026-11-10 09:37:20 TCP/UDP: Preserving recently used remote address: [AF_INET]127.0.0.1:11940
2026-11-10 09:37:20 Socket Buffers: R=[212992->212992] S=[212992->212992]
2026-11-10 09:37:20 UDPv4 link local: (not bound)
2026-11-10 09:37:20 UDPv4 link remote: [AF_INET]127.0.0.1:11940
2026-11-10 09:37:20 TLS: Initial packet from [AF_INET]127.0.0.1:11940, sid=ef46aae5 e0bc7d08
2026-11-10 09:37:20 VERIFY OK: depth=1, CN=OTUS-VPN-Lab
2026-11-10 09:37:20 VERIFY KU OK
2026-11-10 09:37:20 Validating certificate extended key usage
2026-11-10 09:37:20 ++ Certificate has EKU (str) TLS Web Server Authentication, expects TLS Web Server Authentication
2026-11-10 09:37:20 VERIFY EKU OK
2026-11-10 09:37:20 VERIFY X509NAME OK: CN=ras-server
2026-11-10 09:37:20 VERIFY OK: depth=0, CN=ras-server
2026-11-10 09:37:20 Control Channel: TLSv1.3, cipher TLSv1.3 TLS_AES_256_GCM_SHA384, peer certificate: 2048 bits RSA, signature: RSA-SHA256, peer temporary key: 253 bits X25519
2026-11-10 09:37:20 [ras-server] Peer Connection Initiated with [AF_INET]127.0.0.1:11940
2026-11-10 09:37:20 TLS: move_session: dest=TM_ACTIVE src=TM_INITIAL reinit_src=1
2026-11-10 09:37:20 TLS: tls_multi_process: initial untrusted session promoted to trusted
2026-11-10 09:37:21 SENT CONTROL [ras-server]: 'PUSH_REQUEST' (status=1)
2026-11-10 09:37:21 PUSH: Received control message: 'PUSH_REPLY,route-gateway 10.79.0.1,topology subnet,ping 10,ping-restart 60,ifconfig 10.79.0.2 255.255.255.0,peer-id 0,cipher AES-256-GCM'
2026-11-10 09:37:21 OPTIONS IMPORT: --ifconfig/up options modified
2026-11-10 09:37:21 OPTIONS IMPORT: route-related options modified
2026-11-10 09:37:21 TUN/TAP device tun0 opened
2026-11-10 09:37:21 net_iface_mtu_set: mtu 1500 for tun0
2026-11-10 09:37:21 net_iface_up: set tun0 up
2026-11-10 09:37:21 net_addr_v4_add: 10.79.0.2/24 dev tun0
2026-11-10 09:37:21 Initialization Sequence Completed
2026-11-10 09:37:21 Data Channel: cipher 'AES-256-GCM', peer-id: 0
2026-11-10 09:37:21 Timers: ping 10, ping-restart 60

```

```bash

skomov@nfsc:~$ ip -4 route get 10.79.0.1
ping -c 3 -W 2 10.79.0.1
10.79.0.1 dev tun0 src 10.79.0.2 uid 1000
    cache
PING 10.79.0.1 (10.79.0.1) 56(84) bytes of data.
64 bytes from 10.79.0.1: icmp_seq=1 ttl=64 time=3.62 ms
64 bytes from 10.79.0.1: icmp_seq=2 ttl=64 time=3.62 ms
64 bytes from 10.79.0.1: icmp_seq=3 ttl=64 time=3.67 ms

--- 10.79.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 3.619/3.636/3.669/0.023 ms
skomov@nfsc:~$ ^C

```
