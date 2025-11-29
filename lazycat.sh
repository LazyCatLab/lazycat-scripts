#!/bin/bash

# 样式定义
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"

# 标题部分
show_header() {
  echo -e "${BLUE}${BOLD}"
  echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗"
  echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
  echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
  echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
  echo "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   "
  echo -e "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   🐾🐾${RESET}"
  echo
  echo "         懒猫实验室 · 一键部署脚本 v1.0"
  echo "         支持系统：Debian / Ubuntu"
}

# 菜单展示
show_menu() {
  echo "------------------------"
  echo "1. 系统信息查询"
  echo "2. 系统更新"
  echo "3. 系统清理"
  echo "4. 测试脚本合集"
  echo "5. X-UI 安装"
  echo "------------------------"
  echo "0. 退出脚本"
  echo "------------------------"
}

# 系统信息展示
show_sysinfo() {
  clear
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(lsb_release -ds 2>/dev/null || grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(lscpu | grep 'Model name:' | sed 's/Model name:\s*//')"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(lscpu | awk '/CPU MHz:/ {printf "%.1f GHz\n", $3 / 1000}')"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}')%"
  echo "系统负载:       $(uptime | awk -F'load average:' '{ print $2 }' | xargs)"
  echo "TCP|UDP连接数:  $(ss -tun | grep -c tcp)|$(ss -tun | grep -c udp)"
  echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%.2f/%.2fM (%.2f%%)", $3, $2, $3/$2*100}')"
  echo "虚拟内存:       $(free -m | awk '/Swap:/ {printf "%.2f/%.2fM (%.2f%%)", $3, $2, ($2>0)?$3/$2*100:0}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
  echo "-------------"
  RX=$(cat /sys/class/net/*/statistics/rx_bytes | paste -sd+ | bc)
  TX=$(cat /sys/class/net/*/statistics/tx_bytes | paste -sd+ | bc)
  echo "总接收:         $(echo "scale=2; $RX / 1024 / 1024" | bc)M"
  echo "总发送:         $(echo "scale=2; $TX / 1024 / 1024" | bc)M"
  echo "-------------"
  echo "网络算法:       $(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null)"
  echo "-------------"
  echo "运营商:         $(curl -s https://ipinfo.io/org)"
  echo "IPv4地址:       $(curl -s https://ipv4.icanhazip.com)"
  echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | head -n1 | awk '{print $2}')"
  echo "地理位置:       $(curl -s https://ipinfo.io/loc)"
  echo "系统时间:       $(date)"
  echo "-------------"
  echo "运行时长:       $(uptime -p | cut -d ' ' -f2-)"
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 系统更新
update_system() {
  clear
  echo "🔄 正在更新系统..."
  apt update && apt upgrade -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 系统清理
clean_system() {
  clear
  echo "🧹 正在清理系统..."
  apt autoremove -y && apt autoclean -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 功能选择
handle_selection() {
  case "$1" in
    1) show_sysinfo ;;
    2) update_system ;;
    3) clean_system ;;
    4) echo "🧪 测试脚本合集：功能暂未实现。" ;;
    5) bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh) ;;
    0) echo "👋 已退出懒猫脚本"; exit 0 ;;
    *) echo "❌ 无效输入，请输入 0-5 之间的数字" ;;
  esac
}

# 主流程
main() {
  while true; do
    clear
    show_header
    show_menu
    echo -n "请输入你的选择: "
    read choice
    handle_selection "$choice"
  done
}

main
