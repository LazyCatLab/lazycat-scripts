#!/bin/bash

# 颜色定义
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"

# 显示主标题
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

# 主菜单
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

pause_and_return() {
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
  clear
}

# 系统信息
system_info() {
  clear
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(awk -F: '/cpu MHz/ {print $2; exit}' /proc/cpuinfo | awk '{printf "%.1f GHz", $1 / 1000}')"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%"
  echo "系统负载:       $(uptime | awk -F'load average:' '{print $2}' | xargs)"
  echo "TCP|UDP连接数:  $(ss -tun | grep tcp | wc -l)|$(ss -tun | grep udp | wc -l)"
  echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%.2f/%.2fM (%.2f%%)", $3, $2, $3/$2*100}')"
  echo "虚拟内存:       $(free -m | awk '/Swap:/ {printf "%.0fM/%.0fM (%.0f%%)", $3, $2, ($2==0)?0:$3/$2*100}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')"
  echo "-------------"
  echo "总接收:         $(cat /proc/net/dev | awk '/eth0|ens|eno/ {rx+=$2} END {printf "%.2fM", rx/1024/1024}')"
  echo "总发送:         $(cat /proc/net/dev | awk '/eth0|ens|eno/ {tx+=$10} END {printf "%.2fM", tx/1024/1024}')"
  echo "-------------"
  echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')"
  echo "-------------"
  echo "运营商:         $(curl -s https://ipinfo.io/org)"
  echo "IPv4地址:       $(curl -s https://ipinfo.io/ip)"
  echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | head -n 1 | awk '{print $2}')"
  echo "地理位置:       $(curl -s https://ipinfo.io/city), $(curl -s https://ipinfo.io/region)"
  echo "系统时间:       $(date +'%Z %F %r')"
  echo "-------------"
  echo "运行时长:       $(uptime -p | cut -d' ' -f2-)"
  pause_and_return
}

# 测试脚本合集菜单
show_tests_menu() {
  clear
  echo "测试脚本合集"
  echo "------------------------"
  echo "1. 流媒体解锁测试（简版）"
  echo "2. 三网回程测试（backtrace）"
  echo "3. 网络质量测试（speedtest）"
  echo "4. 系统性能测试（yabs）"
  echo "0. 返回主菜单"
  echo "------------------------"
}

handle_tests_menu() {
  while true; do
    show_tests_menu
    echo -n "请输入你的选择: "
    read sub_choice
    case "$sub_choice" in
      1)
        clear
        echo "🧪 流媒体解锁测试（简版）中..."
        bash <(curl -Ls https://raw.githubusercontent.com/peasoft/MediaUnlock_Test/master/check.sh)
        pause_and_return
        ;;
      2)
        clear
        echo "🧪 三网回程测试中（backtrace）..."
        bash <(curl -Ls https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh)
        pause_and_return
        ;;
      3)
        clear
        echo "🧪 网络质量测试中（speedtest-cli）..."
        curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
        pause_and_return
        ;;
      4)
        clear
        echo "🧪 系统性能测试中（yabs）..."
        curl -sL yabs.sh | bash
        pause_and_return
        ;;
      0) break ;;
      *) echo "❌ 无效输入，请输入 0-4 之间的数字" ;;
    esac
  done
}

# 功能选择处理
handle_selection() {
  case "$1" in
    1) system_info ;;
    2) clear; echo "🔄 正在更新系统..."; apt update && apt upgrade -y; pause_and_return ;;
    3) clear; echo "🧹 正在清理系统..."; apt autoremove -y && apt autoclean -y; pause_and_return ;;
    4) handle_tests_menu ;;
    5) clear; echo "⚙️ 正在安装 X-UI..."; bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh); pause_and_return ;;
    0) echo "👋 已退出懒猫脚本"; exit 0 ;;
    *) echo "❌ 无效输入，请输入 0-5 之间的数字" ;;
  esac
}

# 主函数
main() {
  clear
  show_header
  while true; do
    show_menu
    echo -n "请输入你的选择: "
    read choice
    handle_selection "$choice"
  done
}

main
