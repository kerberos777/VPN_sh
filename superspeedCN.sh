#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE="\033[0;35m"
CYAN='\033[0;36m'
PLAIN='\033[0m'

checkroot(){
	[[ $EUID -ne 0 ]] && echo -e "${RED}請使用 root 用戶運行本腳本！${PLAIN}" && exit 1
}

checksystem() {
	if [ -f /etc/redhat-release ]; then
	    release="centos"
	elif cat /etc/issue | grep -Eqi "debian"; then
	    release="debian"
	elif cat /etc/issue | grep -Eqi "ubuntu"; then
	    release="ubuntu"
	elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
	    release="centos"
	elif cat /proc/version | grep -Eqi "debian"; then
	    release="debian"
	elif cat /proc/version | grep -Eqi "ubuntu"; then
	    release="ubuntu"
	elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
	    release="centos"
	fi
}

checkpython() {
	if  [ ! -e '/usr/bin/python' ]; then
	        echo "正在安裝 Python"
	            if [ "${release}" == "centos" ]; then
	            		yum update > /dev/null 2>&1
	                    yum -y install python > /dev/null 2>&1
	                else
	                	apt-get update > /dev/null 2>&1
	                    apt-get -y install python > /dev/null 2>&1
	                fi
	        
	fi
}

checkcurl() {
	if  [ ! -e '/usr/bin/curl' ]; then
	        echo "正在安裝 Curl"
	            if [ "${release}" == "centos" ]; then
	                yum update > /dev/null 2>&1
	                yum -y install curl > /dev/null 2>&1
	            else
	                apt-get update > /dev/null 2>&1
	                apt-get -y install curl > /dev/null 2>&1
	            fi
	fi
}

checkwget() {
	if  [ ! -e '/usr/bin/wget' ]; then
	        echo "正在安裝 Wget"
	            if [ "${release}" == "centos" ]; then
	                yum update > /dev/null 2>&1
	                yum -y install wget > /dev/null 2>&1
	            else
	                apt-get update > /dev/null 2>&1
	                apt-get -y install wget > /dev/null 2>&1
	            fi
	fi
}

checkspeedtest() {
	if  [ ! -e './speedtest-cli/speedtest' ]; then
		echo "正在安裝 Speedtest-cli"
		wget --no-check-certificate -qO speedtest.tgz https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-$(uname -m)-linux.tgz > /dev/null 2>&1
	fi
	mkdir -p speedtest-cli && tar zxvf speedtest.tgz -C ./speedtest-cli/ > /dev/null 2>&1 && chmod a+rx ./speedtest-cli/speedtest
}

speed_test(){
	speedLog="./speedtest.log"
	true > $speedLog
		speedtest-cli/speedtest -p no -s $1 --accept-license > $speedLog 2>&1
		is_upload=$(cat $speedLog | grep 'Upload')
		if [[ ${is_upload} ]]; then
	        local REDownload=$(cat $speedLog | awk -F ' ' '/Download/{print $3}')
	        local reupload=$(cat $speedLog | awk -F ' ' '/Upload/{print $3}')
	        local relatency=$(cat $speedLog | awk -F ' ' '/Latency/{print $2}')
	        
			local nodeID=$1
			local nodeLocation=$2
			local nodeISP=$3
			
			strnodeLocation="${nodeLocation}　　　　　　"
			LANG=C
			#echo $LANG
			
			temp=$(echo "${REDownload}" | awk -F ' ' '{print $1}')
	        if [[ $(awk -v num1=${temp} -v num2=0 'BEGIN{print(num1>num2)?"1":"0"}') -eq 1 ]]; then
	        	printf "${RED}%-6s${YELLOW}%s%s${GREEN}%-24s${CYAN}%s%-10s${BLUE}%s%-10s${PURPLE}%-8s${PLAIN}\n" "${nodeID}"  "${nodeISP}" "|" "${strnodeLocation:0:24}" "↑ " "${reupload}" "↓ " "${REDownload}" "${relatency}" | tee -a $log
			fi
		else
	        local cerror="ERROR"
		fi
}

preinfo() {
	echo "———————————————————SuperSpeed 全面測速版——————————————————"
	echo "       bash <(curl -Lso- https://git.io/superspeed)"
	echo "       全部節點清單:  https://git.io/superspeedList"
	echo "       節點更新: 2020/04/09  | 腳本更新: 2020/04/09"
	echo "——————————————————————————————————————————————————————————"
}

selecttest() {
	echo -e "  測速類型:    ${GREEN}1.${PLAIN} 三網測速    ${GREEN}2.${PLAIN} 取消測速"
	echo -ne "               ${GREEN}3.${PLAIN} 電信節點    ${GREEN}4.${PLAIN} 聯通節點    ${GREEN}5.${PLAIN} 移動節點"
	while :; do echo
			read -p "  請輸入數位選擇測速類型: " selection
			if [[ ! $selection =~ ^[1-5]$ ]]; then
					echo -ne "  ${RED}輸入錯誤${PLAIN}, 請輸入正確的數字!"
			else
					break   
			fi
	done
}

runtest() {
	[[ ${selection} == 2 ]] && exit 1

	if [[ ${selection} == 1 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    測速伺服器資訊       上傳/Mbps   下載/Mbps   延遲/ms"
		start=$(date +%s) 

		 speed_test '3633' '上海' '電信'
		 speed_test '24012' '內蒙古呼和浩特' '電信'
		 speed_test '27377' '北京５Ｇ' '電信'
		 speed_test '29026' '四川成都' '電信'
		# speed_test '29071' '四川成都' '電信'
		 speed_test '17145' '安徽合肥５Ｇ' '電信'
		 speed_test '27594' '廣東廣州５Ｇ' '電信'
		# speed_test '27810' '廣西南寧' '電信'
		 speed_test '27575' '新疆烏魯木齊' '電信'
		# speed_test '26352' '江蘇南京５Ｇ' '電信'
		 speed_test '5396' '江蘇蘇州５Ｇ' '電信'
		# speed_test '5317' '江蘇連雲港５Ｇ' '電信'
		# speed_test '7509' '浙江杭州' '電信'
		 speed_test '23844' '湖北武漢' '電信'
		 speed_test '29353' '湖北武漢５Ｇ' '電信'
		 speed_test '28225' '湖南長沙５Ｇ' '電信'
		 speed_test '3973' '甘肅蘭州' '電信'
		# speed_test '19076' '重慶' '電信'
		#***
		# speed_test '21005' '上海' '聯通'
		 speed_test '24447' '上海５Ｇ' '聯通'
		# speed_test '5103' '雲南昆明' '聯通'
		 speed_test '5145' '北京' '聯通'
		# speed_test '5505' '北京' '聯通'
		# speed_test '9484' '吉林長春' '聯通'
		 speed_test '2461' '四川成都' '聯通'
		 speed_test '27154' '天津５Ｇ' '聯通'
		# speed_test '5509' '寧夏銀川' '聯通'
		# speed_test '5724' '安徽合肥' '聯通'
		# speed_test '5039' '山東濟南' '聯通'
		 speed_test '26180' '山東濟南５Ｇ' '聯通'
		 speed_test '26678' '廣東廣州５Ｇ' '聯通'
		# speed_test '16192' '廣東深圳' '聯通'
		# speed_test '6144' '新疆烏魯木齊' '聯通'
		 speed_test '13704' '江蘇南京' '聯通'
		 speed_test '5485' '湖北武漢' '聯通'
		# speed_test '26677' '湖南株洲' '聯通'
		 speed_test '4870' '湖南長沙' '聯通'
		# speed_test '4690' '甘肅蘭州' '聯通'
		# speed_test '4884' '福建福州' '聯通'
		# speed_test '31985' '重慶' '聯通'
		 speed_test '4863' '陝西西安' '聯通'
		#***
		# speed_test '30154' '上海' '移動'
		# speed_test '25637' '上海５Ｇ' '移動'
		# speed_test '26728' '雲南昆明' '移動'
		# speed_test '27019' '內蒙古呼和浩特' '移動'
		 speed_test '30232' '內蒙呼和浩特５Ｇ' '移動'
		# speed_test '30293' '內蒙古通遼５Ｇ' '移動'
		 speed_test '25858' '北京' '移動'
		 speed_test '16375' '吉林長春' '移動'
		# speed_test '24337' '四川成都' '移動'
		 speed_test '17184' '天津５Ｇ' '移動'
		# speed_test '26940' '寧夏銀川' '移動'
		# speed_test '31815' '寧夏銀川' '移動'
		# speed_test '26404' '安徽合肥５Ｇ' '移動'
		 speed_test '27151' '山東臨沂５Ｇ' '移動'
		# speed_test '25881' '山東濟南５Ｇ' '移動'
		# speed_test '27100' '山東青島５Ｇ' '移動'
		# speed_test '26501' '山西太原５Ｇ' '移動'
		 speed_test '31520' '廣東中山' '移動'
		# speed_test '6611' '廣東廣州' '移動'
		# speed_test '4515' '廣東深圳' '移動'
		# speed_test '15863' '廣西南寧' '移動'
		# speed_test '16858' '新疆烏魯木齊' '移動'
		 speed_test '26938' '新疆烏魯木齊５Ｇ' '移動'
		# speed_test '17227' '新疆和田' '移動'
		# speed_test '17245' '新疆喀什' '移動'
		# speed_test '17222' '新疆阿勒泰' '移動'
		# speed_test '27249' '江蘇南京５Ｇ' '移動'
		# speed_test '21845' '江蘇常州５Ｇ' '移動'
		# speed_test '26850' '江蘇無錫５Ｇ' '移動'
		# speed_test '17320' '江蘇鎮江５Ｇ' '移動'
		 speed_test '25883' '江西南昌５Ｇ' '移動'
		# speed_test '17223' '河北石家莊' '移動'
		# speed_test '26331' '河南鄭州５Ｇ' '移動'
		# speed_test '6715' '浙江寧波５Ｇ' '移動'
		# speed_test '4647' '浙江杭州' '移動'
		# speed_test '16503' '海南海口' '移動'
		# speed_test '28491' '湖南長沙５Ｇ' '移動'
		# speed_test '16145' '甘肅蘭州' '移動'
		 speed_test '16171' '福建福州' '移動'
		# speed_test '18444' '西藏拉薩' '移動'
		 speed_test '16398' '貴州貴陽' '移動'
		 speed_test '25728' '遼寧大連' '移動'
		# speed_test '16167' '遼寧瀋陽' '移動'
		# speed_test '17584' '重慶' '移動'
		# speed_test '26380' '陝西西安' '移動'
		# speed_test '29105' '陝西西安５Ｇ' '移動'
		# speed_test '29083' '青海西寧５Ｇ' '移動'
		# speed_test '26656' '黑龍江哈爾濱' '移動'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  測試完成, 本次測速耗時: ${min} 分 ${sec} 秒"
		else
			echo -ne "  測試完成, 本次測速耗時: ${time} 秒"
		fi
		echo -ne "\n  當前時間: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
		echo -e "  ${GREEN}# 三網測速中為避免節點數不均及測試過久，每部分未使用所${PLAIN}"
		echo -e "  ${GREEN}# 有節點，如果需要使用全部節點，可分別選擇三網節點檢測${PLAIN}"
	fi

	if [[ ${selection} == 3 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    測速伺服器資訊       上傳/Mbps   下載/Mbps   延遲/ms"
		start=$(date +%s) 

		 speed_test '3633' '上海' '電信'
		 speed_test '24012' '內蒙古呼和浩特' '電信'
		 speed_test '27377' '北京５Ｇ' '電信'
		 speed_test '29026' '四川成都' '電信'
		 speed_test '29071' '四川成都' '電信'
		 speed_test '17145' '安徽合肥５Ｇ' '電信'
		 speed_test '27594' '廣東廣州５Ｇ' '電信'
		 speed_test '27810' '廣西南寧' '電信'
		 speed_test '27575' '新疆烏魯木齊' '電信'
		 speed_test '26352' '江蘇南京５Ｇ' '電信'
		 speed_test '5396' '江蘇蘇州５Ｇ' '電信'
		 speed_test '5317' '江蘇連雲港５Ｇ' '電信'
		 speed_test '7509' '浙江杭州' '電信'
		 speed_test '23844' '湖北武漢' '電信'
		 speed_test '29353' '湖北武漢５Ｇ' '電信'
		 speed_test '28225' '湖南長沙５Ｇ' '電信'
		 speed_test '3973' '甘肅蘭州' '電信'
		 speed_test '19076' '重慶' '電信'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  測試完成, 本次測速耗時: ${min} 分 ${sec} 秒"
		else
			echo -ne "  測試完成, 本次測速耗時: ${time} 秒"
		fi
		echo -ne "\n  當前時間: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi

	if [[ ${selection} == 4 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    測速伺服器資訊       上傳/Mbps   下載/Mbps   延遲/ms"
		start=$(date +%s) 

		 speed_test '21005' '上海' '聯通'
		 speed_test '24447' '上海５Ｇ' '聯通'
		 speed_test '5103' '雲南昆明' '聯通'
		 speed_test '5145' '北京' '聯通'
		 speed_test '5505' '北京' '聯通'
		 speed_test '9484' '吉林長春' '聯通'
		 speed_test '2461' '四川成都' '聯通'
		 speed_test '27154' '天津５Ｇ' '聯通'
		 speed_test '5509' '寧夏銀川' '聯通'
		 speed_test '5724' '安徽合肥' '聯通'
		 speed_test '5039' '山東濟南' '聯通'
		 speed_test '26180' '山東濟南５Ｇ' '聯通'
		 speed_test '26678' '廣東廣州５Ｇ' '聯通'
		 speed_test '16192' '廣東深圳' '聯通'
		 speed_test '6144' '新疆烏魯木齊' '聯通'
		 speed_test '13704' '江蘇南京' '聯通'
		 speed_test '5485' '湖北武漢' '聯通'
		 speed_test '26677' '湖南株洲' '聯通'
		 speed_test '4870' '湖南長沙' '聯通'
		 speed_test '4690' '甘肅蘭州' '聯通'
		 speed_test '4884' '福建福州' '聯通'
		 speed_test '31985' '重慶' '聯通'
		 speed_test '4863' '陝西西安' '聯通'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  測試完成, 本次測速耗時: ${min} 分 ${sec} 秒"
		else
			echo -ne "  測試完成, 本次測速耗時: ${time} 秒"
		fi
		echo -ne "\n  當前時間: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi

	if [[ ${selection} == 5 ]]; then
		echo "——————————————————————————————————————————————————————————"
		echo "ID    測速伺服器資訊       上傳/Mbps   下載/Mbps   延遲/ms"
		start=$(date +%s) 

		 speed_test '30154' '上海' '移動'
		 speed_test '25637' '上海５Ｇ' '移動'
		 speed_test '26728' '雲南昆明' '移動'
		 speed_test '27019' '內蒙古呼和浩特' '移動'
		 speed_test '30232' '內蒙呼和浩特５Ｇ' '移動'
		 speed_test '30293' '內蒙古通遼５Ｇ' '移動'
		 speed_test '25858' '北京' '移動'
		 speed_test '16375' '吉林長春' '移動'
		 speed_test '24337' '四川成都' '移動'
		 speed_test '17184' '天津５Ｇ' '移動'
		 speed_test '26940' '寧夏銀川' '移動'
		 speed_test '31815' '寧夏銀川' '移動'
		 speed_test '26404' '安徽合肥５Ｇ' '移動'
		 speed_test '27151' '山東臨沂５Ｇ' '移動'
		 speed_test '25881' '山東濟南５Ｇ' '移動'
		 speed_test '27100' '山東青島５Ｇ' '移動'
		 speed_test '26501' '山西太原５Ｇ' '移動'
		 speed_test '31520' '廣東中山' '移動'
		 speed_test '6611' '廣東廣州' '移動'
		 speed_test '4515' '廣東深圳' '移動'
		 speed_test '15863' '廣西南寧' '移動'
		 speed_test '16858' '新疆烏魯木齊' '移動'
		 speed_test '26938' '新疆烏魯木齊５Ｇ' '移動'
		 speed_test '17227' '新疆和田' '移動'
		 speed_test '17245' '新疆喀什' '移動'
		 speed_test '17222' '新疆阿勒泰' '移動'
		 speed_test '27249' '江蘇南京５Ｇ' '移動'
		 speed_test '21845' '江蘇常州５Ｇ' '移動'
		 speed_test '26850' '江蘇無錫５Ｇ' '移動'
		 speed_test '17320' '江蘇鎮江５Ｇ' '移動'
		 speed_test '25883' '江西南昌５Ｇ' '移動'
		 speed_test '17223' '河北石家莊' '移動'
		 speed_test '26331' '河南鄭州５Ｇ' '移動'
		 speed_test '6715' '浙江寧波５Ｇ' '移動'
		 speed_test '4647' '浙江杭州' '移動'
		 speed_test '16503' '海南海口' '移動'
		 speed_test '28491' '湖南長沙５Ｇ' '移動'
		 speed_test '16145' '甘肅蘭州' '移動'
		 speed_test '16171' '福建福州' '移動'
		 speed_test '18444' '西藏拉薩' '移動'
		 speed_test '16398' '貴州貴陽' '移動'
		 speed_test '25728' '遼寧大連' '移動'
		 speed_test '16167' '遼寧瀋陽' '移動'
		 speed_test '17584' '重慶' '移動'
		 speed_test '26380' '陝西西安' '移動'
		 speed_test '29105' '陝西西安５Ｇ' '移動'
		 speed_test '29083' '青海西寧５Ｇ' '移動'
		 speed_test '26656' '黑龍江哈爾濱' '移動'

		end=$(date +%s)  
		rm -rf speedtest*
		echo "——————————————————————————————————————————————————————————"
		time=$(( $end - $start ))
		if [[ $time -gt 60 ]]; then
			min=$(expr $time / 60)
			sec=$(expr $time % 60)
			echo -ne "  測試完成, 本次測速耗時: ${min} 分 ${sec} 秒"
		else
			echo -ne "  測試完成, 本次測速耗時: ${time} 秒"
		fi
		echo -ne "\n  當前時間: "
		echo $(date +%Y-%m-%d" "%H:%M:%S)
	fi
}

runall() {
	checkroot;
	checksystem;
	checkpython;
	checkcurl;
	checkwget;
	checkspeedtest;
	clear
	speed_test;
	preinfo;
	selecttest;
	runtest;
	rm -rf speedtest*
}

runall
