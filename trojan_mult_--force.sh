#!/bin/bash
#
#Author: atrandys
#
#
function blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
function green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
function red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
function version_lt(){
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; 
}
#copy from 秋水逸冰 ss scripts
if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
fi
systempwd="/etc/systemd/system/"

#install & config trojan
function install_trojan(){
$systemPackage install -y nginx
systemctl stop nginx
sleep 5
cat > /etc/nginx/nginx.conf <<-EOF
user  root;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  120;
    client_max_body_size 20m;
    #gzip  on;
    server {
        listen  127.0.0.1:80;
        server_name  $your_domain;
        root /usr/share/nginx/html;
        index index.php index.html index.htm;
    }
    server {
        listen  0.0.0.0:80;
        listen  [::]:80;
        server_name  _;
        return  301 https://$your_domain\$request_uri;
    }
}
EOF
	#設置偽裝站
	rm -rf /usr/share/nginx/html/*
	cd /usr/share/nginx/html/
	wget https://github.com/atrandys/v2ray-ws-tls/raw/master/web.zip >/dev/null 2>&1
    	unzip web.zip >/dev/null 2>&1
	sleep 5
	#申請https證書
	if [ ! -d "/usr/src" ]; then
	    mkdir /usr/src
	fi
	mkdir /usr/src/trojan-cert /usr/src/trojan-temp
	curl https://get.acme.sh | sh
	~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone
	if test -s /root/.acme.sh/$your_domain/fullchain.cer; then
	systemctl start nginx
        cd /usr/src
	#wget https://github.com/trojan-gfw/trojan/releases/download/v1.13.0/trojan-1.13.0-linux-amd64.tar.xz
	wget https://api.github.com/repos/trojan-gfw/trojan/releases/latest >/dev/null 2>&1
	latest_version=`grep tag_name latest| awk -F '[:,"v]' '{print $6}'`
	rm -f latest
	wget https://github.com/trojan-gfw/trojan/releases/download/v${latest_version}/trojan-${latest_version}-linux-amd64.tar.xz >/dev/null 2>&1
	tar xf trojan-${latest_version}-linux-amd64.tar.xz >/dev/null 2>&1
	#下載trojan客戶端
	wget https://github.com/atrandys/trojan/raw/master/trojan-cli.zip >/dev/null 2>&1
	wget -P /usr/src/trojan-temp https://github.com/trojan-gfw/trojan/releases/download/v${latest_version}/trojan-${latest_version}-win.zip >/dev/null 2>&1
	unzip trojan-cli.zip >/dev/null 2>&1
	unzip /usr/src/trojan-temp/trojan-${latest_version}-win.zip -d /usr/src/trojan-temp/ >/dev/null 2>&1
	mv -f /usr/src/trojan-temp/trojan/trojan.exe /usr/src/trojan-cli/ 
	trojan_passwd=$(cat /dev/urandom | head -1 | md5sum | head -c 8)
	cat > /usr/src/trojan-cli/config.json <<-EOF
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "$your_domain",
    "remote_port": 443,
    "password": [
        "$trojan_passwd"
    ],
    "log_level": 1,
    "ssl": {
        "verify": true,
        "verify_hostname": true,
        "cert": "",
        "cipher_tls13":"TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
	"sni": "",
        "alpn": [
            "h2",
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "curves": ""
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "fast_open": false,
        "fast_open_qlen": 20
    }
}
EOF
	rm -rf /usr/src/trojan/server.conf
	cat > /usr/src/trojan/server.conf <<-EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$trojan_passwd"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/usr/src/trojan-cert/fullchain.cer",
        "key": "/usr/src/trojan-cert/private.key",
        "key_password": "",
        "cipher_tls13":"TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
	"prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": ""
    }
}
EOF
	cd /usr/src/trojan-cli/
	zip -q -r trojan-cli.zip /usr/src/trojan-cli/
	trojan_path=$(cat /dev/urandom | head -1 | md5sum | head -c 16)
	mkdir /usr/share/nginx/html/${trojan_path}
	mv /usr/src/trojan-cli/trojan-cli.zip /usr/share/nginx/html/${trojan_path}/
	#增加啟動腳本
	
cat > ${systempwd}trojan.service <<-EOF
[Unit]  
Description=trojan  
After=network.target  
   
[Service]  
Type=simple  
PIDFile=/usr/src/trojan/trojan/trojan.pid
ExecStart=/usr/src/trojan/trojan -c "/usr/src/trojan/server.conf"  
ExecReload=/bin/kill -HUP \$MAINPID
Restart=on-failure
RestartSec=1s
   
[Install]  
WantedBy=multi-user.target
EOF

	chmod +x ${systempwd}trojan.service
	systemctl enable trojan.service
	cd /root
	~/.acme.sh/acme.sh  --installcert  -d  $your_domain --force \
        --key-file   /usr/src/trojan-cert/private.key \
        --fullchain-file  /usr/src/trojan-cert/fullchain.cer \
	--reloadcmd  "systemctl restart trojan"	
	green "======================================================================"
	green "Trojan已安裝完成，請使用以下鏈接下載trojan客戶端，此客戶端已配置好所有參數"
	green "1、複製下面的鏈接，在瀏覽器打開，下載客戶端，注意此下載鏈接將在1個小時後失效"
	blue "http://${your_domain}/$trojan_path/trojan-cli.zip"
	green "2、將下載的壓縮包解壓，打開文件夾，打開start.bat即打開並運行Trojan客戶端"
	green "3、打開stop.bat即關閉Trojan客戶端"
	green "4、Trojan客戶端需要搭配瀏覽器插件使用，例如switchyomega等"
	green "======================================================================"
	else
        red "==================================="
	red "https證書沒有申請成果，自動安裝失敗"
	green "不要擔心，你可以手動修復證書申請"
	green "1. 重啟VPS"
	green "2. 重新執行腳本，使用修復證書功能"
	red "==================================="
	fi
}
function preinstall_check(){

nginx_status=`ps -aux | grep "nginx: worker" |grep -v "grep"`
if [ -n "$nginx_status" ]; then
    systemctl stop nginx
fi
$systemPackage -y install net-tools socat
Port80=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80`
Port443=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 443`
if [ -n "$Port80" ]; then
    process80=`netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}'`
    red "==========================================================="
    red "檢測到80端口被佔用，佔用進程為：${process80}，本次安裝結束"
    red "==========================================================="
    exit 1
fi
if [ -n "$Port443" ]; then
    process443=`netstat -tlpn | awk -F '[: ]+' '$5=="443"{print $9}'`
    red "============================================================="
    red "檢測到443端口被佔用，佔用進程為：${process443}，本次安裝結束"
    red "============================================================="
    exit 1
fi
if [ -f "/etc/selinux/config" ]; then
    CHECK=$(grep SELINUX= /etc/selinux/config | grep -v "#")
    if [ "$CHECK" != "SELINUX=disabled" ]; then
        green "檢測到SELinux開啟狀態，添加放行80/443端口規則"
        yum install -y policycoreutils-python >/dev/null 2>&1
        semanage port -m -t http_port_t -p tcp 80
        semanage port -m -t http_port_t -p tcp 443
    fi
fi
if [ "$release" == "centos" ]; then
    if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
    red "==============="
    red "當前系統不受支持"
    red "==============="
    exit
    fi
    if  [ -n "$(grep ' 5\.' /etc/redhat-release)" ] ;then
    red "==============="
    red "當前系統不受支持"
    red "==============="
    exit
    fi
    firewall_status=`systemctl status firewalld | grep "Active: active"`
    if [ -n "$firewall_status" ]; then
        green "檢測到firewalld開啟狀態，添加放行80/443端口規則"
        firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --zone=public --add-port=443/tcp --permanent
	firewall-cmd --reload
    fi
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
elif [ "$release" == "ubuntu" ]; then
    if  [ -n "$(grep ' 14\.' /etc/os-release)" ] ;then
    red "==============="
    red "當前系統不受支持"
    red "==============="
    exit
    fi
    if  [ -n "$(grep ' 12\.' /etc/os-release)" ] ;then
    red "==============="
    red "當前系統不受支持"
    red "==============="
    exit
    fi
    ufw_status=`systemctl status ufw | grep "Active: active"`
    if [ -n "$ufw_status" ]; then
        ufw allow 80/tcp
        ufw allow 443/tcp
    fi
    apt-get update
elif [ "$release" == "debian" ]; then
    ufw_status=`systemctl status ufw | grep "Active: active"`
    if [ -n "$ufw_status" ]; then
        ufw allow 80/tcp
        ufw allow 443/tcp
    fi
    apt-get update
fi
$systemPackage -y install  wget unzip zip curl tar >/dev/null 2>&1
green "======================="
blue "請輸入綁定到本VPS的域名"
green "======================="
read your_domain
real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
local_addr=`curl ipv4.icanhazip.com`
if [ $real_addr == $local_addr ] ; then
	green "=========================================="
	green "       域名解析正常，開始安裝trojan"
	green "=========================================="
	sleep 1s
        install_trojan
	
else
        red "===================================="
	red "域名解析地址與本VPS IP地址不一致"
	red "若你確認解析成功你可強制腳本繼續運行"
	red "===================================="
	read -p "是否強制運行 ?請輸入 [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
            green "強制繼續運行腳本"
	    sleep 1s
	    install_trojan
	else
	    exit 1
	fi
fi
}

function repair_cert(){
systemctl stop nginx
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
Port80=`netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80`
if [ -n "$Port80" ]; then
    process80=`netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}'`
    red "==========================================================="
    red "檢測到80端口被佔用，佔用進程為：${process80}，本次安裝結束"
    red "==========================================================="
    exit 1
fi
green "======================="
blue "請輸入綁定到本VPS的域名"
blue "務必與之前失敗使用的域名一致"
green "======================="
read your_domain
real_addr=`ping ${your_domain} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
local_addr=`curl ipv4.icanhazip.com`
if [ $real_addr == $local_addr ] ; then
    ~/.acme.sh/acme.sh  --issue  -d $your_domain  --standalone --force
    ~/.acme.sh/acme.sh  --installcert  -d  $your_domain --force \
        --key-file   /usr/src/trojan-cert/private.key \
        --fullchain-file /usr/src/trojan-cert/fullchain.cer \
	--reloadcmd  "systemctl restart trojan"
    if test -s /usr/src/trojan-cert/fullchain.cer; then
        green "證書申請成功"
	green "請將/usr/src/trojan-cert/下的fullchain.cer下載放到客戶端trojan-cli文件夾"
	systemctl restart trojan
	systemctl start nginx
    else
    	red "申請證書失敗"
    fi
else
    red "================================"
    red "域名解析地址與本VPS IP地址不一致"
    red "本次安裝失敗，請確保域名解析正常"
    red "================================"
fi	
}

function remove_trojan(){
    red "================================"
    red "即將卸載trojan"
    red "同時卸載安裝的nginx"
    red "================================"
    systemctl stop trojan
    systemctl disable trojan
    rm -f ${systempwd}trojan.service
    if [ "$release" == "centos" ]; then
        yum remove -y nginx
    else
        apt autoremove -y nginx
    fi
    rm -rf /usr/src/trojan*
    rm -rf /usr/share/nginx/html/*
    rm -rf /root/.acme.sh/
    green "=============="
    green "trojan刪除完畢"
    green "=============="
}

function update_trojan(){
    /usr/src/trojan/trojan -v 2>trojan.tmp
    curr_version=`cat trojan.tmp | grep "trojan" | awk '{print $4}'`
    wget https://api.github.com/repos/trojan-gfw/trojan/releases/latest >/dev/null 2>&1
    latest_version=`grep tag_name latest| awk -F '[:,"v]' '{print $6}'`
    rm -f latest
    rm -f trojan.tmp
    if version_lt "$curr_version" "$latest_version"; then
        green "當前版本$curr_version,最新版本$latest_version,開始升級……"
        mkdir trojan_update_temp && cd trojan_update_temp
        wget https://github.com/trojan-gfw/trojan/releases/download/v${latest_version}/trojan-${latest_version}-linux-amd64.tar.xz >/dev/null 2>&1
        tar xf trojan-${latest_version}-linux-amd64.tar.xz >/dev/null 2>&1
        mv ./trojan/trojan /usr/src/trojan/
        cd .. && rm -rf trojan_update_temp
        systemctl restart trojan
	/usr/src/trojan/trojan -v 2>trojan.tmp
	green "trojan升級完成，當前版本：`cat trojan.tmp | grep "trojan" | awk '{print $4}'`"
	rm -f trojan.tmp
    else
        green "當前版本$curr_version,最新版本$latest_version,無需升級"
    fi
   
   
}

start_menu(){
    clear
    green " ======================================="
    green " 介紹：一鍵安裝trojan      "
    green " 系統：centos7+/debian9+/ubuntu16.04+"
    green " 網站：www.atrandys.com              "
    green " Youtube：Randy's 堡壘                "
    blue " 聲明："
    red " *請不要在任何生產環境使用此腳本"
    red " *請不要有其他程序佔用80和443端口"
    red " *若是第二次使用腳本，請先執行卸載trojan"
    green " ======================================="
    echo
    green " 1. 安裝trojan"
    red " 2. 卸載trojan"
    green " 3. 升級trojan"
    green " 4. 修復證書"
    blue " 0. 退出腳本"
    echo
    read -p "請輸入數字 :" num
    case "$num" in
    1)
    preinstall_check
    ;;
    2)
    remove_trojan 
    ;;
    3)
    update_trojan 
    ;;
    4)
    repair_cert 
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "請輸入正確數字"
    sleep 1s
    start_menu
    ;;
    esac
}

start_menu
