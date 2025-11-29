#!/bin/bash

# 定义颜色
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"

# 标题显示
show_header() {
  echo -e "${BLUE}${BOLD}"
  echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗"
  echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
  echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
  echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
  echo -e "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   🐾🐾"
  echo "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   "
  echo
  echo "         懒猫实验室 · 一键部署脚本 v1.0"
  echo "         支持系统：Debian / Ubuntu"
  echo -e "${RESET}"
}

# 系统信息
system_info() {
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(source /etc/os-release && echo $PRETTY_NAME)"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(awk -F: '/cpu MHz/ {printf "%.1f GHz\n", $2/1000; exit}' /proc/cpuinfo | xargs)"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}' | xargs printf "%.0f%%\n")"
  echo "系统负载:       $(uptime | awk -F'load average:' '{ print $2 }' | xargs)"
  echo "TCP|UDP连接数:  $(ss -tun | grep -c ESTAB)|$(ss -u | grep -c UNCONN)"
  echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%.2f/%.2fM (%.2f%%)", $3, $2, $3*100/$2}')"
  echo "虚拟内存:       $(free -m | awk '/Swap:/ {if ($2 > 0) printf "%.0f/%.0fM (%.0f%%)", $3, $2, $3*100/$2; else print "0M/0M (0%)"}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
  echo "-------------"
  RX=$(cat /proc/net/dev | grep -w eth0 | awk '{print $2}')
  TX=$(cat /proc/net/dev | grep -w eth0 | awk '{print $10}')
  echo "总接收:         $(echo $RX | awk '{printf "%.2fM", $1/1024/1024}')"
  echo "总发送:         $(echo $TX | awk '{printf "%.2fM", $1/1024/1024}')"
  echo "-------------"
  echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk -F= '{print $2}' | xargs) $(lsmod | grep -o 'fq' | uniq)"
  echo "-------------"
  ISP=$(curl -s ipinfo.io/org)
  IP=$(curl -s ipv4.ip.sb)
  DNS=$(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')
  LOC=$(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)
  echo "运营商:         $ISP"
  echo "IPv4地址:       $IP"
  echo "DNS地址:        $DNS"
  echo "地理位置:       $LOC"
  echo "系统时间:       $(timedatectl | grep 'Local time' | awk -F: '{print $2":"$3":"$4}' | xargs)"
  echo "-------------"
  uptime_info=$(uptime -p)
  echo "运行时长:       ${uptime_info#up }"
  echo
  echo "操作完成"
  read -n 1 -s -r -p "按任意键返回主菜单..."
}

# 主菜单
main_menu() {
  while true; do
    clear
    show_header
    echo "------------------------"
    echo "1. 系统信息查询"
    echo "2. 系统更新"
    echo "3. 系统清理"
    echo "4. 测试脚本合集"
    echo "5. X-UI 安装"
    echo "------------------------"
    echo "0. 退出脚本"
    echo "------------------------"
    read -p "请输入你的选择: " choice
    case "$choice" in
      1) system_info ;;
      0) echo "已退出"; exit ;;
      *) echo "无效选项"; sleep 1 ;;
    esac
  done
}

main_menu
