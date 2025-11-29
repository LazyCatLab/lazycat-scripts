#!/bin/bash

# 样式定义
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"

# 标题部分
show_header() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗"
  echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
  echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
  echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
  echo "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   "
  echo "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   🐾🐾"
  echo
  echo "         懒猫实验室 · 一键部署脚本 v1.0"
  echo "         支持系统：Debian / Ubuntu"
  echo -e "${RESET}"
}

# 主菜单展示
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

# 系统信息展示（增强版）
system_info() {
  clear
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(lsb_release -ds 2>/dev/null || grep PRETTY /etc/os-release | cut -d= -f2 | tr -d '"')"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(lscpu | grep 'Model name' | cut -d ':' -f2 | xargs)"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(lscpu | grep 'MHz' | awk '{print $3/1000" GHz"}' | head -1)"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}')%"
  echo "系统负载:       $(uptime | awk -F'load average:' '{print $2}' | xargs)"
  echo "TCP|UDP连接数:  $(ss -t | wc -l)|$(ss -u | wc -l)"
  echo "物理内存:       $(free -m | awk '/Mem/ {printf "%0.2f/%dMB (%.2f%%)", $3, $2, $3/$2*100}')"
  echo "虚拟内存:       $(free -m | awk '/Swap/ {printf "%dMB/%dMB (%0.2f%%)", $3, $2, ($2==0)?0:($3/$2*100)}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2{print $3"/"$2" ("$5")"}')"
  echo "-------------"
  echo "总接收:         $(ifconfig 2>/dev/null | grep 'RX packets' | head -1 | awk '{print $5}')"
  echo "总发送:         $(ifconfig 2>/dev/null | grep 'TX packets' | head -1 | awk '{print $5}')"
  echo "-------------"
  echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk -F= '{print $2}')"
  echo "-------------"
  echo "运营商:         $(curl -s ipinfo.io/org)"
  echo "IPv4地址:       $(curl -s ipv4.ip.sb)"
  echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')"
  echo "地理位置:       $(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)"
  echo "系统时间:       $(TZ=Asia/Shanghai date)"
  echo "-------------"
  echo "运行时长:       $(uptime -p | cut -d ' ' -f2-)"
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
  main
}

# 系统更新
system_update() {
  clear
  echo "🔄 正在更新系统..."
  apt update && apt upgrade -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
  main
}

# 系统清理
system_clean() {
  clear
  echo "🧹 正在清理系统..."
  apt autoremove -y && apt autoclean -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
  main
}

# 测试合集
run_tests() {
  while true; do
    clear
    echo "测试脚本合集"
    echo "------------------------"
    echo "1. 流媒体解锁测试（简版）"
    echo "2. 三网回程测试（besttrace）"
    echo "3. 网络质量测速（speedtest）"
    echo "4. 系统性能测试（yabs）"
    echo "------------------------"
    echo "0. 返回主菜单"
    echo "------------------------"
    read -p "请输入你的选择: " test_choice
    case "$test_choice" in
      1)
        clear
        echo "🧪 正在运行流媒体解锁测试..."
        bash <(curl -Ls https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh)
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      2)
        clear
        echo "🧪 正在执行三网回程测试..."
        bash <(curl -sL https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh)
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      3)
        clear
        echo "🧪 正在运行网络质量测试..."
        apt install -y speedtest-cli && speedtest-cli
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      4)
        clear
        echo "🧪 正在运行系统性能测试..."
        bash <(curl -sL yabs.sh) || curl -sL yabs.sh | bash
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      0)
        main ;;
      *)
        echo "❌ 无效输入，请输入 0-4 之间的数字"
        sleep 1 ;;
    esac
  done
}

# X-UI 安装
install_xui() {
  bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
  exit 0
}

# 主流程
main() {
  show_header
  while true; do
    show_menu
    read -p "请输入你的选择: " choice
    case "$choice" in
      1) system_info ;;
      2) system_update ;;
      3) system_clean ;;
      4) run_tests ;;
      5) install_xui ;;
      0)
        echo "👋 已退出懒猫脚本"
        exit 0 ;;
      *)
        echo "❌ 无效输入，请输入 0-5 之间的数字"
        sleep 1 ;;
    esac
  done
}

main
