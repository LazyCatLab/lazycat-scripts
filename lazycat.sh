#!/bin/bash

# 设置颜色
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"

# 标题部分
show_header() {
  clear
  echo -e "${BLUE}${BOLD}"
  echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗"
  echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
  echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
  echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
  echo "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   "
  echo -e "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   🐾${RESET}"
  echo
  echo "         懒猫实验室 · 一键部署脚本 v1.0"
  echo "         支持系统：Debian / Ubuntu"
  echo
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

# 测试脚本菜单
show_test_menu() {
  clear
  echo "测试脚本合集"
  echo "------------------------"
  echo "1. 流媒体解锁测试（简化版）"
  echo "2. 三网回程测试"
  echo "3. 网络质量测试"
  echo "4. 系统性能测试（YABS）"
  echo "0. 返回主菜单"
  echo "------------------------"
}

# 系统信息查询
sys_info() {
  clear
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2)"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^ //')"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(lscpu | awk '/MHz/ {printf "%.1f GHz", $2/1000; exit}')"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')"
  echo "系统负载:       $(uptime | awk -F'load average:' '{print $2}')"
  echo "TCP|UDP连接数:  $(ss -t | wc -l)|$(ss -u | wc -l)"
  echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%0.2f/%0.2fM (%.2f%%)", $3, $2, $3*100/$2}')"
  echo "虚拟内存:       $(free -m | awk '/Swap:/ {if ($2==0) print "0M/0M (0%)"; else printf "%0.2f/%0.2fM (%.2f%%)", $3, $2, $3*100/$2}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2{print $3"/"$2" ("$5")"}')"
  echo "-------------"
  echo "总接收:         $(ifconfig 2>/dev/null | grep 'RX packets' | head -1 | awk '{print $5}')"
  echo "总发送:         $(ifconfig 2>/dev/null | grep 'TX packets' | head -1 | awk '{print $5}')"
  echo "-------------"
  echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')"
  echo "-------------"
  echo "运营商:         $(curl -s ipinfo.io/org)"
  echo "IPv4地址:       $(curl -s ip.sb)"
  echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -1)"
  echo "地理位置:       $(curl -s ipinfo.io/city), $(curl -s ipinfo.io/country)"
  echo "系统时间:       $(TZ='Asia/Shanghai' date '+Asia/Shanghai %Y-%m-%d %I:%M %p')"
  echo "-------------"
  echo "运行时长:       $(uptime -p | sed 's/up //')"
  echo "-------------"
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 系统更新
sys_update() {
  clear
  echo "🔄 正在更新系统..."
  apt update && apt upgrade -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 系统清理
sys_clean() {
  clear
  echo "🧹 正在清理系统..."
  apt autoremove -y && apt autoclean -y
  echo
  read -n 1 -s -r -p "操作完成，按任意键返回主菜单..."
}

# 测试脚本合集
run_test_script() {
  while true; do
    show_test_menu
    echo -n "请输入你的选择: "
    read test_choice
    case "$test_choice" in
      1)
        clear
        echo "🧪 正在进行流媒体解锁测试（简化版）..."
        bash <(curl -Ls https://github.com/lmc999/RegionRestrictionCheck/raw/main/check.sh)
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      2)
        clear
        echo "🧪 正在进行三网回程测试..."
        bash <(curl -Ls https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh)
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      3)
        clear
        echo "🧪 正在进行网络质量测试..."
        bash <(curl -Ls https://raw.githubusercontent.com/sjlleo/net-quality/main/netquality.sh)
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      4)
        clear
        echo "🧪 正在进行系统性能测试（YABS）..."
        curl -sL yabs.sh | bash
        read -n 1 -s -r -p "按任意键返回测试菜单..."
        ;;
      0)
        break
        ;;
      *)
        echo "❌ 无效输入，请输入 0-4 之间的数字"
        ;;
    esac
  done
}

# X-UI 安装
install_xui() {
  clear
  echo "⚙️ 正在安装 X-UI..."
  bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
  echo
  read -n 1 -s -r -p "安装完成，按任意键返回主菜单..."
}

# 主流程
main() {
  while true; do
    show_header
    show_menu
    echo -n "请输入你的选择: "
    read choice
    case "$choice" in
      1)
        sys_info
        ;;
      2)
        sys_update
        ;;
      3)
        sys_clean
        ;;
      4)
        run_test_script
        ;;
      5)
        install_xui
        ;;
      0)
        echo "👋 已退出懒猫脚本"
        exit 0
        ;;
      *)
        echo "❌ 无效输入，请输入 0-5 之间的数字"
        ;;
    esac
  done
}

main
