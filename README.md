# DingTalkAutoPunch
## 介绍

这是钉钉自动punch脚本

## 原理

原理来说很简单，就是定时的打开与关闭DingTalk，自动punch功能由DingTalk的quick punch提供。

## 前提条件

* Android
* 设置好punch必备条件，比如地点，网络等
* 设置好DingTalk的Quick Punch功能
* 插着电源
* 在开发者模式中开启充电时保持屏幕常亮功能
* 最好带Root

 ## 使用方法

1. 打开`auto_punch.sh`，将变量`punch_in_time`、`random_minute`、`working_minute`改成你的实际情况
2. 将修改后的`auto_punch.sh`脚本放入到手机储存中的任意位置，比如：/sdcard/auto_punch.sh
3. 使`auto_punch.sh`后台执行就行

## 后台执行的几个方法

1. 通过adb，执行`adb shell`进入shell模式，然后用过nohup后台执行：`cd /sdcard; nohup sh auto_punch.sh >auto_punch.log 2>&1 &`，然后断开即可。
2. 下载安装一个安卓的终端模拟器，打开终端模拟器执行：`cd /sdcard; sh auto_punch.sh`，保持终端模拟器进程在后台运行着即可。

## 坑

第一次执行的话，务必监视下Log，因为在用am启动DingTalk的时候，有可能拉不起来，原因未知。如果是这种情况的话，考虑换种后台执行方式，或者使用root执行。
