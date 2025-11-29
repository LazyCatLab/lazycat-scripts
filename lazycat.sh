#!/bin/bash

# 配色与标题
RESET="\033[0m"
BOLD="\033[1m"
BLUE="\033[34m"

# 显示主标题
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

# 显示菜单
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

# 显示测试脚本菜单
show_test_menu() {
  clear
  echo "测试脚本合集"
  echo "------------------------"
  echo "1. 流媒体解锁测试（Region）"
  echo "2. 三网回程 + 路由追踪（backtrace）"
  echo "3. 网络带宽/质量测试（Speedtest CLI）"
  echo "4. 系统性能综合测试（YABS）"
  echo "0. 返回主菜单"
  echo "------------------------"
}

# 子菜单返回提示
press_return() {
  echo
  read -n 1 -s -r -p "按任意键返回主菜单..."
}

# 系统信息
system_info() {
  clear
  echo "系统信息查询"
  echo "-------------"
  echo "主机名:         $(hostname)"
  echo "系统版本:       $(lsb_release -ds 2>/dev/null || grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')"
  echo "Linux版本:      $(uname -r)"
  echo "-------------"
  echo "CPU架构:        $(uname -m)"
  echo "CPU型号:        $(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^ //')"
  echo "CPU核心数:      $(nproc)"
  echo "CPU频率:        $(lscpu | awk '/MHz/ {printf "%.1f GHz", $2/1000}')"
  echo "-------------"
  echo "CPU占用:        $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%"
  echo "系统负载:       $(uptime | awk -F'load average:' '{ print $2 }')"
  echo "TCP|UDP连接数:  $(ss -t | wc -l)|$(ss -u | wc -l)"
  echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%0.2f/%0.2fM (%.2f%%)", $3, $2, $3*100/$2}')"
  echo "虚拟内存:       $(free -m | awk '/Swap:/ {printf "%0.2f/%0.2fM (%.2f%%)", $3, $2, ($2>0)?$3*100/$2:0}')"
  echo "硬盘占用:       $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')"
  echo "-------------"
  echo "总接收:         $(cat /proc/net/dev | awk '/eth0|ens|eno/ {rx+=$2} END {printf "%.2fM", rx/1024/1024}')"
  echo "总发送:         $(cat /proc/net/dev | awk '/eth0|ens|eno/ {tx+=$10} END {printf "%.2fM", tx/1024/1024}')"
  echo "-------------"
  echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')"
  echo "-------------"
  echo "运营商:         $(curl -s https://ipinfo.io/org)"
  echo "IPv4地址:       $(curl -s https://ipv4.ip.sb)"
  echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | head -n1 | awk '{print $2}')"
  echo "地理位置:       $(curl -s https://ipinfo.io/city), $(curl -s https://ipinfo.io/country)"
  echo "系统时间:       $(TZ='Asia/Shanghai' date '+Asia/Shanghai %F %I:%M %p')"
  echo "-------------"
  echo "运行时长:       $(uptime -p | cut -d ' ' -f2-)"
  press_return
}

# 流媒体检测
test_streaming() {
  clear
  echo "🧪 正在运行流媒体解锁测试..."
  bash <(curl -Ls https://github.com/lmc999/RegionRestrictionCheck/raw/main/check.sh)
  press_return
}

# 三网回程测试
test_backtrace() {
  clear
  echo "🧪 正在运行回程路由追踪测试..."
  bash <(curl -Ls https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh)
  press_return
}

# 网络测速测试
test_speed() {
  clear
  echo "🧪 正在运行 Speedtest 网络测速..."
  if ! command -v speedtest &>/dev/null; then
    echo "未检测到 speedtest，正在安装..."
    apt install -y speedtest-cli || yum install -y speedtest-cli
  fi
  speedtest
  press_return
}

# 系统性能测试
test_yabs() {
  clear
  echo "🧪 正在运行 YABS 性能测试..."
  curl -sL yabs.sh | bash
  press_return
}

# 测试脚本合集逻辑
handle_test_scripts() {
  while true; do
    show_test_menu
    read -p "请输入你的选择: " tsel
    case "$tsel" in
      1) test_streaming ;;
      2) test_backtrace ;;
      3) test_speed ;;
      4) test_yabs ;;
      0) break ;;
      *) echo "❌ 无效输入，请输入 0-4 之间的数字" ;;
    esac
  done
}

# 主流程逻辑
main() {
  while true; do
    show_header
    show_menu
    read -p "请输入你的选择: " choice
    case "$choice" in
      1) system_info ;;
      2) apt update && apt upgrade -y ; press_return ;;
      3) apt autoremove -y && apt autoclean -y ; press_return ;;
      4) handle_test_scripts ;;
      5) bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh) ; press_return ;;
      0) echo "👋 已退出懒猫脚本" ; exit 0 ;;
      *) echo "❌ 无效输入，请输入 0-5 之间的数字" ;;
    esac
  done
}

main
