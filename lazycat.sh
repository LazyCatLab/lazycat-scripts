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
  echo "██╗      ██████╗ ███████╗██╗   ██╗ █████╔███████╗████████╗"
  echo "██║     ██╔╔╔╔██║╚══██╔ ██║██║     ██╔╔╔╔██║╚═══██══╝"
  echo "██║     ███████║  ╚══██║  ╚███████║   ██║   "
  echo "██║     ██╔╔╔╔██║ ╚══██╔    ╚██╔  ██║     ██║   "
  echo "██████╗██║  ██║██████╗   ██║   ╚██████╗██║  ██║   ██║   "
  echo "╚═════╝╚══╝  ╚══╚═════╝   ╚══    ╚═════╝╚══  ╚══   ╚══   🐾🐾"
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
  echo "------------------------"
  echo "0. 退出脚本"
  echo "------------------------"
}

# 系统信息查询 (略)
# 系统更新 (略)
# 系统清理 (略)
# 测试脚本合集 (略)

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
      0)
        echo "👋 已退出懒猫脚本"
        exit 0 ;;
      *)
        echo "❌ 无效输入，请输入 0-4 之间的数字"
        sleep 1 ;;
    esac
  done
}

main
