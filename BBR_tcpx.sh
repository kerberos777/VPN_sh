#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6/7/8,Debian 8/9/10,ubuntu 16/18/19
#	Description: BBR+BBRplus+Lotserver
#	Version: 1.3.2.37
#	Author: 千影,cx9208,YLX
#	更新內容及回饋:  https://blog.ylx.me/archives/783.html
#=================================================

sh_ver="1.3.2.37"
github="github.000060000.xyz"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[錯誤]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#安裝BBR內核
installbbr(){
	kernel_version="5.6.15"
	bit=`uname -m`
	rm -rf bbr
	mkdir bbr && cd bbr
	
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "6" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-headers-c6.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EUCmObDQnMZEmKnhxS67sJkBG8kjbx0bjNF-XwTtzvgtAA?download=1
				wget -N -O kernel-c6.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EeC72joP3HVNmrIbjlPg_coBs7kj29Md4f9psAjZOuqOdg?download=1
			
				yum install -y kernel-c6.rpm
				yum install -y kernel-headers-c6.rpm
			
				#kernel_version="5.5.5"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		
		elif [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-headers-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/Ef9KvmYkbsZJjGYw6073m-EB2WIGQg9IhPI9hVR4V3Y0Gw?download=1
				wget -N -O kernel-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EV0JLwNBMZtOt023wkul_CkBTzaSToHH8KIgguawAa-WFg?download=1

				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
			
				kernel_version="5.7.4"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi	
			
		elif [[ ${version} = "8" ]]; then
			wget -N -O kernel-c8.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ETadaTIeeQJCgxEXKlOFiCEBsBa-Y15QbDkv-HQGo2EHSQ?download=1
			wget -N -O kernel-headers-c8.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EZEZyLBjDplMgSqDzyaqkvYBW06OOKDCcIQq27381fa5-A?download=1

			yum install -y kernel-c8.rpm
			yum install -y kernel-headers-c8.rpm
			
			#kernel_version="5.5.5"
		fi
	
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		if [[ "${release}" == "debian" ]]; then
			if [[ ${version} = "8" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-d8.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EeNpacEol0ZDk5S5ARJ1G7wBI6hF0q-C--Nonxq31lO1iw?download=1
					wget -N -O linux-headers-d8.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EWmAacwLpdJPhs56m6KhxsEBnnZyqOPJggf-2XXHMfxCtw?download=1
				
					dpkg -i linux-image-d8.deb
					dpkg -i linux-headers-d8.deb
				
					#kernel_version="5.5.5"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
		
			elif [[ ${version} = "9" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-d9.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EWrsOGQzcqJOrLzeaqXBh0sBbs9Np7anhs5JULwFAliGBg?download=1
					wget -N -O linux-headers-d9.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EbAGliMxbpZAtaqvjhcaexkB3owfi2PddFenWUEwMNkiXw?download=1
				
					dpkg -i linux-image-d9.deb
					dpkg -i linux-headers-d9.deb
				
					#kernel_version="5.5.5"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
			elif [[ ${version} = "10" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ET2PkFkQeSFMtpiIhK58xaoB01aH51XFPcMTv-OGCP92gA?download=1
					wget -N -O linux-headers-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/Ec-uNmSW0iBOmUKbu-w2iS0BspktPBqgRjPMIqXcConmmA?download=1
				
					dpkg -i linux-image-d10.deb
					dpkg -i linux-headers-d10.deb
				
					#kernel_version="5.6.12"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
			fi
		elif [[ "${release}" == "ubuntu" ]]; then
			if [[ ${version} = "16" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-u16.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ERyDAcgbNptBjPGywtyy4zwB1S14VXAHEraobteVekwcNQ?download=1
					wget -N -O linux-headers-u16.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/Eeka3lp7WAFOugowSi1F_eYBUXXdnx1dp1rI_aTg9XYtww?download=1
				
					dpkg -i linux-image-u16.deb
					dpkg -i linux-headers-u16.deb
				
					#kernel_version="5.4.14"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
		
			elif [[ ${version} = "18" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-u18.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ERvqNJiLLrpKnLO9z3vCdZIB-GwZr2AKXO7t6dpTbEotmQ?download=1
					wget -N -O linux-headers-u18.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EWZdQsfxE5lAvL3xTHxS9H4BjYijqpxP-TokL1hLag7PIw?download=1
				
					dpkg -i linux-image-u18.deb
					dpkg -i linux-headers-u18.deb
				
					#kernel_version="5.4.14"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
			elif [[ ${version} = "19" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-u19.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ESEgC1nVDmRFmQeJnSWujz4BYy-tnZa64EgX60dIQJjW9Q?download=1
					wget -N -O linux-headers-u19.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EcsC0aEv8KBHhG3jwRaF8r4BLqvFwBLK5JGy83dfhdV-zQ?download=1
				
					dpkg -i linux-image-u19.deb
					dpkg -i linux-headers-u19.deb
				
					#kernel_version="5.4.14"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
			elif [[ ${version} = "20" ]]; then
				if [[ ${bit} = "x86_64" ]]; then
					wget -N -O linux-image-u20.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EYqsZWWiss1JvRW5gsfGxckBQhV1IiQgOqzlFmzUJAAdpg?download=1
					wget -N -O linux-headers-u20.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ESJMvds9OwRKlSPEoHYeMPcB4CIbP9rO3hcdGmzAsJqCVQ?download=1
					dpkg -i linux-image-u20.deb
					dpkg -i linux-headers-u20.deb
					#kernel_version="5.4.14"
				else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
				fi
			fi				
			
		#else	
		#	wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb
		#	wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/linux-headers-${kernel_version}-all.deb
		#	wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/${bit}/linux-headers-${kernel_version}.deb
		#	wget -N --no-check-certificate http://${github}/bbr/debian-ubuntu/${bit}/linux-image-${kernel_version}.deb
	
		#	dpkg -i libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb
		#	dpkg -i linux-headers-${kernel_version}-all.deb
		#	dpkg -i linux-headers-${kernel_version}.deb
		#	dpkg -i linux-image-${kernel_version}.deb
		fi
	fi
	
	cd .. && rm -rf bbr	
	
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBR${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBR，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝BBRplus內核 4.14.129
installbbrplus(){
	kernel_version="4.14.160-bbrplus"
	bit=`uname -m`
	rm -rf bbrplus
	mkdir bbrplus && cd bbrplus
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-headers-c7.rpm https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/centos/7/kernel-headers-4.14.129-bbrplus.rpm
				wget -N -O kernel-c7.rpm https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/centos/7/kernel-4.14.129-bbrplus.rpm
				
				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
				
				kernel_version="4.14.129_bbrplus"
			else
					echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		fi	
		
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		wget -N -O linux-headers.deb https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/debian-ubuntu/x64/linux-headers-4.14.129-bbrplus.deb
		wget -N -O linux-image.deb https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/debian-ubuntu/x64/linux-image-4.14.129-bbrplus.deb
		
		dpkg -i linux-image.deb
		dpkg -i linux-headers.deb
			
		kernel_version="4.14.129-bbrplus"
	fi
	
	cd .. && rm -rf bbrplus
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBRplus${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBRplus，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝Lotserver內核
installlot(){
	if [[ "${release}" == "centos" ]]; then
		rpm --import http://${github}/lotserver/${release}/RPM-GPG-KEY-elrepo.org
		yum remove -y kernel-firmware
		yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-firmware-${kernel_version}.rpm
		yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-${kernel_version}.rpm
		yum remove -y kernel-headers
		yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-headers-${kernel_version}.rpm
		yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-devel-${kernel_version}.rpm
	elif [[ "${release}" == "ubuntu" ]]; then
		bash <(wget -qO- "https://${github}/Debian_Kernel.sh")
	elif [[ "${release}" == "debian" ]]; then
		bash <(wget -qO- "https://${github}/Debian_Kernel.sh")
	fi
	
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}Lotserver${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟Lotserver，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝xanmod內核  from xanmod.org
installxanmod(){
	kernel_version="5.5.1-xanmod1"
	bit=`uname -m`
	rm -rf xanmod
	mkdir xanmod && cd xanmod
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ERAo-0e2nVxIkiS-3ESibQkBtqPutKafMhuPJcPPjxezNg?download=1
				wget -N -O kernel-headers-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EcFRGLkSHl5DtelqaAaSpE0BoA4Ypg0paEjjpolaORQKMw?download=1
				
				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
			
				kernel_version="5.7.4_xanmod1"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		elif [[ ${version} = "8" ]]; then
				wget -N -O kernel-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.5.1xanmod/kernel-5.5.1_xanmod1-1-c8.x86_64.rpm
				wget -N -O kernel-headers-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.5.1xanmod/kernel-headers-5.5.1_xanmod1-1-c8.x86_64.rpm
				
				yum install -y kernel-c8.rpm
				yum install -y kernel-headers-c8.rpm
			
				kernel_version="5.5.1_xanmod1"
		fi
		
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
			wget -N -O linux-headers-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/Ebi4DrPpYchIuPBcw8iJ0FwBFRHCL4UeTdHEFtIOYwN36g?download=1
			wget -N -O linux-image-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EUinaAfrdBVCisX1TMtnsX4BAmZII3FQss_dW0VEtG5fbg?download=1
				
			dpkg -i linux-image-d10.deb
			dpkg -i linux-headers-d10.deb
				
			kernel_version="5.7.4-xanmod1"
		else
			echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1	
		fi		
	fi
	
	cd .. && rm -rf xanmod
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBR${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBR，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝bbr2內核
installbbr2(){
	kernel_version="5.4.0-rc6"
	bit=`uname -m`
	rm -rf bbr2
	mkdir bbr2 && cd bbr2
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-c7.rpm https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/kernel-5.4.0_rc6-1-bbr2-c7.x86_64.rpm
				wget -N -O kernel-headers-c7.rpm https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/kernel-headers-5.4.0_rc6-1-bbr2-c7.x86_64.rpm
				
				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
			
				kernel_version="5.4.0_rc6"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		elif [[ ${version} = "8" ]]; then
				wget -N -O kernel-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/kernel-5.4.0_rc6-1-bbr2-c8.x86_64.rpm
				wget -N -O kernel-headers-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/kernel-headers-5.4.0_rc6-1-bbr2-c8.x86_64.rpm
				
				yum install -y kernel-c8.rpm
				yum install -y kernel-headers-c8.rpm
			
				kernel_version="5.4.0_rc6"
		fi
		
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "9" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O linux-image-d9.deb https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/linux-image-5.4.0-rc6_5.4.0-rc6-1-bbr2-d9_amd64.deb
				wget -N -O linux-headers-d9.deb https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/linux-headers-5.4.0-rc6_5.4.0-rc6-1-bbr2-d9_amd64.deb
				
				dpkg -i linux-image-d9.deb
				dpkg -i linux-headers-d9.deb
				
				#kernel_version="4.14.168-bbrplus"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi	
		elif [[ ${version} = "10" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O linux-headers-d10.deb https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/linux-headers-5.4.0-rc6_5.4.0-rc6-1-bbr2-d10_amd64.deb
				wget -N -O linux-image-d10.deb https://github.com/ylx2016/kernel/releases/download/5.4.0r6bbr2/linux-image-5.4.0-rc6_5.4.0-rc6-1-bbr2-d10_amd64.deb
					
				dpkg -i linux-image-d10.deb
				dpkg -i linux-headers-d10.deb
				
				#kernel_version="4.14.168-bbrplus"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi		
		fi			
	fi
	
	cd .. && rm -rf bbr2
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBR2${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBR2，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝Zen內核
installzen(){
	kernel_version="5.5.2-zen"
	bit=`uname -m`
	rm -rf zen
	mkdir zen && cd zen
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EfQb4N8c2bxDlF3mj3SBVHIBGFSg_d1uR4LFzzT0Ii5FWA?download=1
				wget -N -O kernel-headers-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EfKgMa8vsZBOt0zwXM_lHcUBOYlyH1CyRHrYSRJ5r6a0EQ?download=1
				
				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
			
				kernel_version="5.5.10_zen"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		elif [[ ${version} = "8" ]]; then
				wget -N -O kernel-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.5.2zen/kernel-5.5.2_zen-1-c8.x86_64.rpm
				wget -N -O kernel-headers-c8.rpm https://github.com/ylx2016/kernel/releases/download/5.5.2zen/kernel-headers-5.5.2_zen-1-c8.x86_64.rpm
				
				yum install -y kernel-c8.rpm
				yum install -y kernel-headers-c8.rpm
			
				kernel_version="5.5.2_zen"
		fi
		
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "9" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O linux-headers-d9.deb https://github.com/ylx2016/kernel/releases/download/5.5.2zen/linux-headers-5.5.2-zen_5.5.2-zen-1-d9_amd64.deb
				wget -N -O linux-image-d9.deb https://github.com/ylx2016/kernel/releases/download/5.5.2zen/linux-image-5.5.2-zen_5.5.2-zen-1-d9_amd64.deb
				
				dpkg -i linux-image-d9.deb 
				dpkg -i linux-headers-d9.deb
				
				#kernel_version="4.14.168-bbrplus"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi	
		elif [[ ${version} = "10" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O linux-headers-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EShzFq8Jlv1PthbYlNNvLjIB2-hktrkPXxwd9mqcXgmcyg?download=1
				wget -N -O linux-image-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/ERXzOc-2BzJInOxBgKo62OkBgcI9-O-fw0M8U2B4NazuLg?download=1
					
				dpkg -i linux-image-d10.deb
				dpkg -i linux-headers-d10.deb
				
				kernel_version="5.5.10-zen"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi		
		fi			
	fi
	
	cd .. && rm -rf zen
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBR${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBR，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"
}

#安裝bbrplus 新內核
installbbrplusnew(){
	kernel_version="4.14.182-bbrplus"
	bit=`uname -m`
	rm -rf bbrplusnew
	mkdir bbrplusnew && cd bbrplusnew
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O kernel-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EWtxHt1RiAlHgqERl5bvYzcBUrkKa_n1mWQ-uM2-Na7gmQ?download=1
				wget -N -O kernel-headers-c7.rpm https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EYkNoi17pKJBi7KnhUGRqEIBEK_26-bzkCL-fuQYZmrHWA?download=1
				
				yum install -y kernel-c7.rpm
				yum install -y kernel-headers-c7.rpm
			
				kernel_version="4.14.182_bbrplus"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "10" ]]; then
			if [[ ${bit} = "x86_64" ]]; then
				wget -N -O linux-headers-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/Ef9pJn1wp-pBk4FIPxT1qBoBqpWhTVCawoKzEB0_vpiMRw?download=1
				wget -N -O linux-image-d10.deb https://chinagz2018-my.sharepoint.com/:u:/g/personal/ylx_chinagz2018_onmicrosoft_com/EaFJshr8za9Bq9FGjEBLds0B4ZfrYThLH8E35xe9-qWX_Q?download=1
					
				dpkg -i linux-image-d10.deb
				dpkg -i linux-headers-d10.deb
				
				kernel_version="4.14.182-bbrplus"
			else
				echo -e "${Error} 還在用32位內核，別再見了 !" && exit 1
			fi		
		fi			
	fi

	cd .. && rm -rf bbrplusnew
	#detele_kernel
	BBR_grub
	#echo -e "${Tip} ${Red_font_prefix}請檢查上面是否有內核資訊，無內核千萬別重啟${Font_color_suffix}"
	#echo -e "${Tip} ${Red_font_prefix}rescue不是正常內核，要排除這個${Font_color_suffix}"
	#echo -e "${Tip} 重啟VPS後，請重新運行腳本開啟${Red_font_prefix}BBRplus${Font_color_suffix}"
	#stty erase '^H' && read -p "需要重啟VPS後，才能開啟BBRplus，是否現在重啟 ? [Y/n] :" yn
	#[ -z "${yn}" ] && yn="y"
	#if [[ $yn == [Yy] ]]; then
	#	echo -e "${Info} VPS 重啟中..."
	#	reboot
	#fi
	echo -e "${Tip} 內核安裝完畢，請參考上面的資訊檢查是否安裝成功及手動調整內核啟動順序"

}

#啟用BBR+fq
startbbrfq(){
	remove_all
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR+FQ修改成功，重啟生效！"
}

#啟用BBR+cake
startbbrcake(){
	remove_all
	echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR+cake修改成功，重啟生效！"
}

#啟用BBRplus
startbbrplus(){
	remove_all
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbrplus" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBRplus修改成功，重啟生效！"
}

#啟用Lotserver
startlotserver(){
	remove_all
	if [[ "${release}" == "centos" ]]; then
		yum install ethtool
	else
		apt-get update
		apt-get install ethtool
	fi
	#bash <(wget -qO- https://git.io/lotServerInstall.sh) install
	bash <(wget --no-check-certificate -qO- https://github.com/xidcn/LotServer_Vicer/raw/master/Install.sh) install
	sed -i '/advinacc/d' /appex/etc/config
	sed -i '/maxmode/d' /appex/etc/config
	echo -e "advinacc=\"1\"
maxmode=\"1\"">>/appex/etc/config
	/appex/bin/lotServer.sh restart
	start_menu
}

#啟用BBR2+FQ
startbbr2fq(){
	remove_all
	echo "net.ipv4.tcp_ecn=0" >> /etc/sysctl.conf
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr2" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR2修改成功，重啟生效！"
}

#啟用BBR2+CAKE
startbbr2cake(){
	remove_all
	echo "net.ipv4.tcp_ecn=0" >> /etc/sysctl.conf
	echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr2" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR2修改成功，重啟生效！"
}

#啟用BBR2+FQ+ecn
startbbr2fqecn(){
	remove_all
	echo "net.ipv4.tcp_ecn=1" >> /etc/sysctl.conf
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr2" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR2修改成功，重啟生效！"
}

#啟用BBR2+CAKE+ecn
startbbr2cakeecn(){
	remove_all
	echo "net.ipv4.tcp_ecn=1" >> /etc/sysctl.conf
	echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr2" >> /etc/sysctl.conf
	sysctl -p
	echo -e "${Info}BBR2修改成功，重啟生效！"
}


#卸載全部加速
remove_all(){
	rm -rf bbrmod
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
	sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	if [[ -e /appex/bin/lotServer.sh ]]; then
		bash <(wget -qO- https://git.io/lotServerInstall.sh) uninstall
	fi
	clear
	echo -e "${Info}:清除加速完成。"
	sleep 1s
}

#優化系統組態
optimizing_system(){
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	echo "net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1">>/etc/sysctl.conf
	sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "需要重啟VPS後，才能生效系統優化配置，是否現在重啟 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重啟中..."
		reboot
	fi
}
#更新腳本
Update_Shell(){
	echo -e "當前版本為 [ ${sh_ver} ]，開始檢測最新版本..."
	sh_new_ver=$(wget -qO- "https://${github}/tcpx.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 檢測最新版本失敗 !" && start_menu
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "發現新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默認: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N "https://${github}/tcpx.sh" && chmod +x tcp.sh
			echo -e "腳本已更新為最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "當前已是最新版本[ ${sh_new_ver} ] !"
		sleep 5s
	fi
}

#切換到卸載內核版本
gototcp(){
	clear
	wget -N "https://github.000060000.xyz/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}

#切換到秋水逸冰BBR安裝腳本
gototeddysun_bbr(){
	clear
	wget https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

#開始菜單
start_menu(){
clear
echo && echo -e " TCP加速 一鍵安裝管理腳本 不卸載內核版本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
 更新內容及回饋:  https://blog.ylx.me/archives/783.html 運行./tcpx.sh再次調用本腳本 母雞慎用
 
 ${Green_font_prefix}0.${Font_color_suffix} 升級腳本
 ${Green_font_prefix}9.${Font_color_suffix} 切換到卸載內核版本
 ${Green_font_prefix}8.${Font_color_suffix} 切換到秋水逸冰BBR安裝腳本
————————————內核管理————————————
 ${Green_font_prefix}1.${Font_color_suffix} 安裝 BBR原版內核 - 5.6.15/5.7.4
 ${Green_font_prefix}2.${Font_color_suffix} 安裝 BBRplus版內核 - 4.14.129
 ${Green_font_prefix}3.${Font_color_suffix} 安裝 Lotserver(銳速)內核 - 多種
 ${Green_font_prefix}4.${Font_color_suffix} 安裝 xanmod版內核 - 5.5.1/5.7.4
 ${Green_font_prefix}5.${Font_color_suffix} 安裝 BBR2測試版內核 - 5.4.0
 ${Green_font_prefix}6.${Font_color_suffix} 安裝 Zen版內核 - 5.5.2/5.5.10
 ${Green_font_prefix}7.${Font_color_suffix} 安裝 BBRplus新版內核 - 4.14.182
————————————加速管理————————————
 ${Green_font_prefix}11.${Font_color_suffix} 使用BBR+FQ加速
 ${Green_font_prefix}12.${Font_color_suffix} 使用BBR+CAKE加速 
 ${Green_font_prefix}13.${Font_color_suffix} 使用BBRplus+FQ版加速
 ${Green_font_prefix}14.${Font_color_suffix} 使用Lotserver(銳速)加速
 ${Green_font_prefix}15.${Font_color_suffix} 使用BBR2+FQ加速
 ${Green_font_prefix}16.${Font_color_suffix} 使用BBR2+CAKE加速
 ${Green_font_prefix}17.${Font_color_suffix} 使用BBR2+FQ+ECN加速
 ${Green_font_prefix}18.${Font_color_suffix} 使用BBR2+CAKE+ECN加速 
————————————雜項管理————————————
 ${Green_font_prefix}21.${Font_color_suffix} 卸載全部加速
 ${Green_font_prefix}22.${Font_color_suffix} 系統組態優化
 ${Green_font_prefix}23.${Font_color_suffix} 退出腳本
————————————————————————————————" && echo

	check_status
	echo -e " 當前內核為：${Font_color_suffix}${kernel_version_r}${Font_color_suffix}"
	if [[ ${kernel_status} == "noinstall" ]]; then
		echo -e " 當前狀態: ${Green_font_prefix}未安裝${Font_color_suffix} 加速內核 ${Red_font_prefix}請先安裝內核${Font_color_suffix}"
	else
		echo -e " 當前狀態: ${Green_font_prefix}已安裝${Font_color_suffix} ${_font_prefix}${kernel_status}${Font_color_suffix} 加速內核 , ${Green_font_prefix}${run_status}${Font_color_suffix}"
		
	fi
	echo -e " 當前擁塞控制演算法為: ${Green_font_prefix}${net_congestion_control}${Font_color_suffix} 當前佇列演算法為: ${Green_font_prefix}${net_qdisc}${Font_color_suffix} "
	
echo
read -p " 請輸入數位 :" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	check_sys_bbr
	;;
	2)
	check_sys_bbrplus
	;;
	3)
	check_sys_Lotsever
	;;
	4)
	check_sys_xanmod
	;;
	5)
	check_sys_bbr2
	;;
	6)
	check_sys_zen
	;;
	7)
	check_sys_bbrplusnew	
	;;
	8)
	gototeddysun_bbr
	;;
	9)
	gototcp
	;;
	11)
	startbbrfq
	;;
	12)
	startbbrcake
	;;
	13)
	startbbrplus
	;;
	14)
	startlotserver
	;;
	15)
	startbbr2fq
	;;
	16)
	startbbr2cake
	;;
	17)
	startbbr2fqecn
	;;
	18)
	startbbr2cakeecn
	;;
	21)
	remove_all
	;;
	22)
	optimizing_system
	;;
	23)
	exit 1
	;;
	*)
	clear
	echo -e "${Error}:請輸入正確數字 [0-23]"
	sleep 5s
	start_menu
	;;
esac
}
#############內核管理組件#############

#刪除多餘內核
detele_kernel(){
	if [[ "${release}" == "centos" ]]; then
		rpm_total=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | wc -l`
		if [ "${rpm_total}" > "1" ]; then
			echo -e "檢測到 ${rpm_total} 個其餘內核，開始卸載..."
			for((integer = 1; integer <= ${rpm_total}; integer++)); do
				rpm_del=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer}`
				echo -e "開始卸載 ${rpm_del} 內核..."
				rpm --nodeps -e ${rpm_del}
				echo -e "卸載 ${rpm_del} 內核卸載完成，繼續..."
			done
			echo --nodeps -e "內核卸載完畢，繼續..."
		else
			echo -e " 檢測到 內核 數量不正確，請檢查 !" && exit 1
		fi
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		deb_total=`dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l`
		if [ "${deb_total}" > "1" ]; then
			echo -e "檢測到 ${deb_total} 個其餘內核，開始卸載..."
			for((integer = 1; integer <= ${deb_total}; integer++)); do
				deb_del=`dpkg -l|grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer}`
				echo -e "開始卸載 ${deb_del} 內核..."
				apt-get purge -y ${deb_del}
				echo -e "卸載 ${deb_del} 內核卸載完成，繼續..."
			done
			echo -e "內核卸載完畢，繼續..."
		else
			echo -e " 檢測到 內核 數量不正確，請檢查 !" && exit 1
		fi
	fi
}

#更新引導
BBR_grub(){
	if [[ "${release}" == "centos" ]]; then
        if [[ ${version} = "6" ]]; then
            if [ ! -f "/boot/grub/grub.conf" ]; then
                echo -e "${Error} /boot/grub/grub.conf 找不到，請檢查."
                exit 1
            fi
            sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
        elif [[ ${version} = "7" ]]; then
            if [ -f "/boot/grub2/grub.cfg" ]; then
				grub2-mkconfig  -o   /boot/grub2/grub.cfg
				grub2-set-default 0
	    exit 1
			elif [ -f "/boot/efi/EFI/centos/grub.cfg" ]; then
				grub2-mkconfig  -o   /boot/efi/EFI/centos/grub.cfg
				grub2-set-default 0
				exit 1
			else
				echo -e "${Error} grub.cfg 找不到，請檢查."
            fi
			#grub2-mkconfig  -o   /boot/grub2/grub.cfg
			#grub2-set-default 0
		
		elif [[ ${version} = "8" ]]; then
			grub2-mkconfig  -o   /boot/grub2/grub.cfg
			grubby --info=ALL|awk -F= '$1=="kernel" {print i++ " : " $2}'
        fi
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        /usr/sbin/update-grub
		#exit 1
    fi
}

#############內核管理組件#############



#############系統檢測元件#############

#檢查系統
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	
#處理ca證書
	if [[ "${release}" == "centos" ]]; then
		yum install ca-certificates -y
		update-ca-trust force-enable
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		apt-get install ca-certificates -y
		update-ca-certificates
	fi	
}

#檢查Linux版本
check_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}

#檢查安裝bbr的系統要求
check_sys_bbr(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "6" || ${version} = "7" || ${version} = "8" ]]; then
			installbbr
		else
			echo -e "${Error} BBR內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "8" || ${version} = "9" || ${version} = "10" ]]; then
			installbbr
		else
			echo -e "${Error} BBR內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
		if [[ ${version} = "16" || ${version} = "18" || ${version} = "19" || ${version} = "20" ]]; then
			installbbr
		else
			echo -e "${Error} BBR內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	else
		echo -e "${Error} BBR內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

check_sys_bbrplus(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "8" || ${version} = "9" || ${version} = "10" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
		if [[ ${version} = "16" || ${version} = "18" || ${version} = "19" ]]; then
			installbbrplus
		else
			echo -e "${Error} BBRplus內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	else
		echo -e "${Error} BBRplus內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

check_sys_bbrplusnew(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" ]]; then
			installbbrplusnew
		else
			echo -e "${Error} BBRplusNew內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "10" ]]; then
			installbbrplusnew
		else
			echo -e "${Error} BBRplusNew內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	else
		echo -e "${Error} BBRplusNew內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

check_sys_xanmod(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" || ${version} = "8" ]]; then
			installxanmod
		else
			echo -e "${Error} xanmod內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		if [[ ${version} = "8" || ${version} = "9" || ${version} = "10" || ${version} = "16" || ${version} = "18" || ${version} = "19" || ${version} = "20" ]]; then
			installxanmod
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
			echo -e "${Error} xanmod內核不支援當前系統 ${release} ${version} ${bit} ,去xanmod.org 官網安裝吧!" && exit 1
	else
		echo -e "${Error} xanmod內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

check_sys_bbr2(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" || ${version} = "8" ]]; then
			installbbr2
		else
			echo -e "${Error} bbr2內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "9" || ${version} = "10" ]]; then
			installbbr2
		else
			echo -e "${Error} bbr2內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
			echo -e "${Error} bbr2內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	else
		echo -e "${Error} bbr2內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}


check_sys_zen(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} = "7" || ${version} = "8" ]]; then
			installzen
		else
			echo -e "${Error} zen內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "9" || ${version} = "10" ]]; then
			installzen
		else
			echo -e "${Error} zen內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
			echo -e "${Error} zen內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	else
		echo -e "${Error} zen內核不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

#檢查安裝Lotsever的系統要求
check_sys_Lotsever(){
	check_version
	if [[ "${release}" == "centos" ]]; then
		if [[ ${version} == "6" ]]; then
			kernel_version="2.6.32-504"
			installlot
		elif [[ ${version} == "7" ]]; then
			yum -y install net-tools
			kernel_version="4.11.2-1"
			installlot
		else
			echo -e "${Error} Lotsever不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "debian" ]]; then
		if [[ ${version} = "7" || ${version} = "8" ]]; then
			if [[ ${bit} == "x64" ]]; then
				kernel_version="3.16.0-4"
				installlot
			elif [[ ${bit} == "x32" ]]; then
				kernel_version="3.2.0-4"
				installlot
			fi
		elif [[ ${version} = "9" ]]; then
			if [[ ${bit} == "x64" ]]; then
				kernel_version="4.9.0-4"
				installlot
			fi
		else
			echo -e "${Error} Lotsever不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	elif [[ "${release}" == "ubuntu" ]]; then
		if [[ ${version} -ge "12" ]]; then
			if [[ ${bit} == "x64" ]]; then
				kernel_version="4.4.0-47"
				installlot
			elif [[ ${bit} == "x32" ]]; then
				kernel_version="3.13.0-29"
				installlot
			fi
		else
			echo -e "${Error} Lotsever不支援當前系統 ${release} ${version} ${bit} !" && exit 1
		fi
	else
		echo -e "${Error} Lotsever不支援當前系統 ${release} ${version} ${bit} !" && exit 1
	fi
}

check_status(){
	kernel_version=`uname -r | awk -F "-" '{print $1}'`
	kernel_version_full=`uname -r`
	net_congestion_control=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
	net_qdisc=`cat /proc/sys/net/core/default_qdisc | awk '{print $1}'`
	kernel_version_r=`uname -r | awk '{print $1}'`
	if [[ ${kernel_version_full} = "4.14.182-bbrplus" || ${kernel_version_full} = "4.14.168-bbrplus" || ${kernel_version_full} = "4.14.98-bbrplus" || ${kernel_version_full} = "4.14.129-bbrplus" || ${kernel_version_full} = "4.14.160-bbrplus" || ${kernel_version_full} = "4.14.166-bbrplus" || ${kernel_version_full} = "4.14.161-bbrplus" ]]; then
		kernel_status="BBRplus"
	elif [[ ${kernel_version} = "3.10.0" || ${kernel_version} = "3.16.0" || ${kernel_version} = "3.2.0" || ${kernel_version} = "4.4.0" || ${kernel_version} = "3.13.0"  || ${kernel_version} = "2.6.32" || ${kernel_version} = "4.9.0" || ${kernel_version} = "4.11.2" ]]; then
		kernel_status="Lotserver"
	elif [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` == "4" ]] && [[ `echo ${kernel_version} | awk -F'.' '{print $2}'` -ge 9 ]] || [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` == "5" ]]; then
		kernel_status="BBR"
	else 
		kernel_status="noinstall"
	fi
	

	if [[ ${kernel_status} == "BBR" ]]; then
		run_status=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
		if [[ ${run_status} == "bbr" ]]; then
			run_status=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
			if [[ ${run_status} == "bbr" ]]; then
				run_status="BBR啟動成功"
			else 
				run_status="BBR啟動失敗"
			fi
		elif [[ ${run_status} == "bbr2" ]]; then
			run_status=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
			if [[ ${run_status} == "bbr2" ]]; then
				run_status="BBR2啟動成功"
			else 
				run_status="BBR2啟動失敗"
			fi	
		elif [[ ${run_status} == "tsunami" ]]; then
			run_status=`lsmod | grep "tsunami" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_tsunami" ]]; then
				run_status="BBR魔改版啟動成功"
			else 
				run_status="BBR魔改版啟動失敗"
			fi
		elif [[ ${run_status} == "nanqinlang" ]]; then
			run_status=`lsmod | grep "nanqinlang" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_nanqinlang" ]]; then
				run_status="暴力BBR魔改版啟動成功"
			else 
				run_status="暴力BBR魔改版啟動失敗"
			fi
		else 
			run_status="未安裝加速模組"
		fi
		
	elif [[ ${kernel_status} == "Lotserver" ]]; then
		if [[ -e /appex/bin/lotServer.sh ]]; then
			run_status=`bash /appex/bin/lotServer.sh status | grep "LotServer" | awk  '{print $3}'`
			if [[ ${run_status} = "running!" ]]; then
				run_status="啟動成功"
			else 
				run_status="啟動失敗"
			fi
		else 
			run_status="未安裝加速模組"
		fi	
	elif [[ ${kernel_status} == "BBRplus" ]]; then
		run_status=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
		if [[ ${run_status} == "bbrplus" ]]; then
			run_status=`cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}'`
			if [[ ${run_status} == "bbrplus" ]]; then
				run_status="BBRplus啟動成功"
			else 
				run_status="BBRplus啟動失敗"
			fi
		else 
			run_status="未安裝加速模組"
		fi
	fi
}

#############系統檢測元件#############
check_sys
check_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本腳本不支援當前系統 ${release} !" && exit 1
start_menu
