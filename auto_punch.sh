#!/bin/sh

#上班打卡时间
punch_in_time="8:40"
#随机时间(分钟)（实际打卡时间为：$punch_in_time ~ ($punch_in_time+$random_minute)之间）
random_minute="15"
#工作时长(分钟)
working_minute="$((60*9))"
#是否开启debug信息
debug_log=1
#截图保存目录
screen_shot_dir="/sdcard/Pictures/DingTalkAutoPunch"

#每天产生的随机时间
_random=$(($RANDOM % ${random_minute}))
if [ "$debug_log" = 1 ]; then
    echo "random=$_random"
fi
#是否已经打开的flag
_is_punch_in=0
#截取上班打卡时间的hour
_punch_in_hour="${punch_in_time%:*}"
#截取上班打卡时间的minute
_punch_in_minute="${punch_in_time#*:}"
#计算上班班的时分
_punch_in="$((${_punch_in_hour} * 60 + ${_punch_in_minute}))"
#计算下班的时分
_punch_out="$((${_punch_in} + ${working_minute}))"

_screen_shot() {
    if ! [ -d "$screen_shot_dir" ]; then mkdir -p "$screen_shot_dir"; fi
    screencap "$screen_shot_dir/$(date '+%Y%m%d%H%M%S').png"
}

_punch() {
    #重复5次，防止意外
    for i in $(seq 1 4); do
        #启动DingTalk
        am start -n com.alibaba.android.rimet/com.alibaba.android.rimet.biz.LaunchHomeActivity
        #等待5秒
        sleep 5
        #返回主界面
        input keyevent KEYCODE_HOME
        #10秒后重试
        sleep 10
        if [ "$debug_log" = 1 ]; then
            _screen_shot
        fi
    done
}

while true; do
    sleep 60
    _now_hour="$(date '+%H')"
    _now_minute="$(date '+%M')"
    _now="$((${_now_hour} * 60 + ${_now_minute}))"
    if [ $_is_punch_in = 0 ]; then
        if [ "$((${_now} + ${random_minute}))" -ge "$_punch_out" ]; then
            #如果当前时间+随机最大分钟已经超过下班时间，则不处理
            continue
        fi
        if [ "$_now" -lt "$((${_punch_in} + ${_random}))" ]; then
            #如果还没到上班时间，则不处理
            continue
        fi
        echo "punch in now."
        _punch
        _is_punch_in=1
    else
        if [ "$_now" -lt "$((${_punch_out} + ${_random}))" ]; then
            #如果还没到下班时间，则不处理
            continue
        fi
        echo "punch out now."
        _punch
        _is_punch_in=0
        _random=$(($RANDOM % ${random_minute}))
        if [ "$debug_log" = 1 ]; then
            echo "random=$_random"
        fi
    fi
done
