if [ -e sss ]
then
    echo "installing..."
    purge-old-kernels
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control

    local="# max open files
    fs.file-max = 51200
    # max read buffer
    net.core.rmem_max = 67108864
    # max write buffer
    net.core.wmem_max = 67108864
    # default read buffer
    net.core.rmem_default = 65536
    # default write buffer
    net.core.wmem_default = 65536
    # max processor input queue
    net.core.netdev_max_backlog = 4096
    # max backlog
    net.core.somaxconn = 4096

    # resist SYN flood attacks
    net.ipv4.tcp_syncookies = 1
    # reuse timewait sockets when safe
    net.ipv4.tcp_tw_reuse = 1
    # turn off fast timewait sockets recycling
    net.ipv4.tcp_tw_recycle = 0
    # short FIN timeout
    net.ipv4.tcp_fin_timeout = 30
    # short keepalive time
    net.ipv4.tcp_keepalive_time = 1200
    # outbound port range
    net.ipv4.ip_local_port_range = 10000 65000
    # max SYN backlog
    net.ipv4.tcp_max_syn_backlog = 4096
    # max timewait sockets held by system simultaneously
    net.ipv4.tcp_max_tw_buckets = 5000
    # turn on TCP Fast Open on both client and server side
    net.ipv4.tcp_fastopen = 3
    # TCP receive buffer
    net.ipv4.tcp_rmem = 4096 87380 67108864
    # TCP write buffer
    net.ipv4.tcp_wmem = 4096 65536 67108864
    # turn on path MTU discovery
    net.ipv4.tcp_mtu_probing = 1

    net.ipv4.tcp_congestion_control = bbr"
    echo "$local" > /etc/sysctl.d/local.conf

    apt install -y python3-pip
    pip3 install setuptools
    pip3 install https://github.com/shadowsocks/shadowsocks/archive/master.zip
    read -p "please input your password: " mypassword
    config="{
        \"server\":\"::\",
        \"server_port\":23333,
        \"local_address\": \"127.0.0.1\",
        \"local_port\":1080,
        \"password\":\"$mypassword\",
        \"timeout\":300,
        \"method\":\"aes-256-cfb\",
        \"fast_open\": true
    }"
    mkdir /etc/shadowsocks
    echo "$config" > /etc/shadowsocks/config.json

    service="[Unit]
    Description=Shadowsocks Server
    After=network.target

    [Service]
    ExecStartPre=/bin/sh -c 'ulimit -n 51200'
    ExecStart=/usr/local/bin/ssserver -c /etc/shadowsocks/config.json
    Restart=on-abort

    [Install]
    WantedBy=multi-user.target"
    echo "$service" > /etc/systemd/system/shadowsocks-server.service

    systemctl start shadowsocks-server
    systemctl enable shadowsocks-server

    echo "now you can test your configure, pls don't run this script again."
    ifconfig
    rm sss
    read -p "press enter to continue..." _
else
    echo "optimizing..."
    apt update
    apt -y install linux-image-4.15.0-50-generic
    touch sss
    reboot
fi