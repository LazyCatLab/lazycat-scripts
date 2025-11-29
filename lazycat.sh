#!/bin/bash

# 标题部分
show_header() {
  RESET="\033[0m"
  BOLD="\033[1m"
  BLUE="\033[34m"

  echo -e "${BLUE}${BOLD}"
  echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗ 🐾🐾"
  echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
  echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
  echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
  echo "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   "
  echo "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   "
  echo
  echo "         懒猫实验室 · 一键部署脚本 v1.0"
  echo "         支持系统：Debian / Ubuntu"
  echo -e "${RESET}"
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

# 测试脚本子菜单
test_scripts_menu() {
  echo "测试脚本合集"
  echo "------------------------"
  echo "1. ChatGPT 解锁状态检测"
  echo "2. 流媒体解锁测试（Region）"
  echo "3. 三网回程测试（besttrace）"
  echo "4. 网络质量体检脚本（NetQuality）"
  echo "5. 性能测试（yabs）"
  echo "0. 返回主菜单"
  echo "------------------------"
}

# 测试脚本选择逻辑
handle_test_selection() {
  while true; do
    test_scripts_menu
    echo -n "请输入你的选择: "
    read sub_choice
    case "$sub_choice" in
      1)
        echo "🧪 ChatGPT 解锁状态检测中..."
        bash <(curl -Ls https://github.com/missuo/OpenAI-Checker/raw/main/openai.sh)
        read -n 1 -s -r -p "按任意键返回..."
        echo
        ;;
      2)
        echo "🧪 Region 流媒体解锁测试中..."
        bash <(curl -Ls https://raw.githubusercontent.com/lmc999/RegionRestrictionCheck/main/check.sh)
        read -n 1 -s -r -p "按任意键返回..."
        echo
        ;;
      3)
        echo "🧪 besttrace 三网回程测试中...（未实现）"
        read -n 1 -s -r -p "按任意键返回..."
        echo
        ;;
      4)
        echo "🧪 网络质量体检中...（未实现）"
        read -n 1 -s -r -p "按任意键返回..."
        echo
        ;;
      5)
        echo "🧪 性能测试中...（未实现）"
        read -n 1 -s -r -p "按任意键返回..."
        echo
        ;;
      0)
        break
        ;;
      *)
        echo "❌ 无效输入，请输入 0-5 之间的数字"
        ;;
    esac
  done
}

# 功能选择
handle_selection() {
  case "$1" in
    1)
      echo "系统信息查询中..."
      echo "-------------"
      echo "主机名:         $(hostname)"
      echo "系统版本:       $(source /etc/os-release && echo "$PRETTY_NAME")"
      echo "Linux版本:      $(uname -r)"
      echo "-------------"
      echo "CPU架构:        $(uname -m)"
      echo "CPU型号:        $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
      echo "CPU核心数:      $(nproc)"
      echo "CPU频率:        $(lscpu | grep 'CPU MHz' | awk -F: '{print $2}' | awk '{printf "%.2f GHz", $1/1000}')"
      echo "CPU占用:        $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%"
      echo "系统负载:       $(uptime | awk -F'load average:' '{print $2}' | xargs)"
      echo "TCP|UDP连接数:  $(ss -tuna | grep ESTAB | wc -l)|$(ss -u | wc -l)"
      echo "物理内存:       $(free -m | awk '/Mem:/ {printf "%.2f/%.2fM (%.2f%%)", $3, $2, $3*100/$2}')"
      echo "虚拟内存:       $(free -m | awk '/Swap:/ {if ($2 == 0) {print "0M/0M (0%)"} else {printf "%.2f/%.2fM (%.2f%%)", $3, $2, $3*100/$2}}')"
      echo "硬盘占用:       $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
      echo "-------------"
      RX=$(cat /proc/net/dev | grep eth0 | awk '{print $2}')
      TX=$(cat /proc/net/dev | grep eth0 | awk '{print $10}')
      echo "总接收:         $(echo "scale=2; $RX/1024/1024" | bc)M"
      echo "总发送:         $(echo "scale=2; $TX/1024/1024" | bc)M"
      echo "-------------"
      echo "网络算法:       $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')"
      echo "-------------"
      IP=$(curl -s ipv4.ip.sb)
      INFO=$(curl -s ipinfo.io)
      echo "IPv4地址:       $IP"
      echo "运营商:         $(echo $INFO | grep -oP '(?<=org":").*?(?=")')"
      echo "地理位置:       $(echo $INFO | grep -oP '(?<=city":").*?(?=")'), $(echo $INFO | grep -oP '(?<=region":").*?(?=")')"
      echo "DNS地址:        $(cat /etc/resolv.conf | grep nameserver | head -n1 | awk '{print $2}')"
      echo "系统时间:       $(timedatectl | grep 'Time zone' | awk -F':' '{print $2}' | xargs), $(date)"
      echo "-------------"
      echo "运行时长:       $(uptime -p | cut -d ' ' -f2-)"
      echo "操作完成"
      read -n 1 -s -r -p "按任意键返回主菜单..."
      echo
      read -n 1 -s -r -p "按任意键返回主菜单..."
      echo
      ;;
    2)
      echo "🔄 正在更新系统..."
      apt update && apt upgrade -y
      echo
      read -n 1 -s -r -p "按任意键返回主菜单..."
      echo
      ;;
    3)
      echo "🧹 正在清理系统..."
      apt autoremove -y && apt autoclean -y
      echo
      read -n 1 -s -r -p "按任意键返回主菜单..."
      echo
      ;;
    4)
      handle_test_selection
      ;;
    5)
      echo "⚙️ 正在安装 X-UI..."
      bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
      read -n 1 -s -r -p "按任意键返回主菜单..."
      echo
      ;;
    0)
      echo "👋 已退出懒猫脚本"
      exit 0
      ;;
    *)
      echo "❌ 无效输入，请输入 0-5 之间的数字"
      ;;
  esac
}

# 主流程
main() {
  clear
  show_header
  while true; do
    show_menu
    echo -n "请输入你的选择: "
    read choice
    handle_selection "$choice"
    echo
  done
}

main
