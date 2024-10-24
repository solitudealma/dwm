#! /usr/bin/env bash

_thisdir=$(cd $(dirname $0);pwd)

settings() {
    [ $1 ] && sleep $1
    xset -b                                   # 关闭蜂鸣器
    syndaemon -i 1 -t -K -R -d                # 设置使用键盘时触控板短暂失效
    $_thisdir/set_screen.sh one               # 设置显示器
}

daemons() {
    [ $1 ] && sleep $1
    $_thisdir/statusbar/statusbar.sh cron &   # 开启状态栏定时更新
    xss-lock -- $_thisdir/blurlock.sh &       # 开启自动锁屏程序
    fcitx5 -d --replace &                                  # 开启输入法
    #lemonade server &                         # 开启lemonade 远程剪切板支持
    clash-verge &
	flameshot &                               # 截图要跑一个程序在后台 不然无法将截图保存到剪贴板
    dunst -conf ~/.config/dunst/dunstrc & # 开启通知server
    picom --experimental-backends --config ~/.config/picom/picom.conf >> /dev/null 2>&1 & # 开启picom
}

cron() {
    [ $1 ] && sleep $1
    let i=10
    while true; do
        [ $((i % 10)) -eq 0 ] && $_thisdir/set_screen.sh check # 每10秒检查显示器状态 以此自动设置显示器
        [ $((i % 300)) -eq 0 ] && feh --randomize --bg-fill ~/Pictures/Wallpapers/*.png # 每300秒更新壁纸
        sleep 10; let i+=10
    done
}

settings 1 &                                  # 初始化设置项
daemons 3 &                                   # 后台程序项
cron 5 &                                      # 定时任务项
