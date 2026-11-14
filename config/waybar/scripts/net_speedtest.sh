#!/usr/bin/env bash

STATE_FILE="/tmp/waybar_speedtest_state"
RESULT_FILE="/tmp/waybar_speedtest_result"
PID_FILE="/tmp/waybar_speedtest_pid"
SPEEDTEST_SCRIPT="$HOME/.config/waybar/scripts/speedtest_cli.py"

if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$1" == "click" ]; then
    if [ "$STATE" == "0" ]; then
        echo "1" > "$STATE_FILE"
        pkill -SIGRTMIN+8 waybar
        (
            # Скачиваем скрипт только один раз
            if [ ! -f "$SPEEDTEST_SCRIPT" ]; then
                curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py > "$SPEEDTEST_SCRIPT"
            fi
            
            res=$(python3 "$SPEEDTEST_SCRIPT" --simple 2>/dev/null | awk '/Download/ {print int($2)}')
            
            # Проверяем, не отменил ли юзер тест за это время
            if [ "$(cat "$STATE_FILE")" == "1" ]; then
                if [ -z "$res" ]; then res="Err"; fi
                echo "$res" > "$RESULT_FILE"
                echo "2" > "$STATE_FILE"
                pkill -SIGRTMIN+8 waybar
            fi
        ) &
        # Записываем PID сабшелла для возможной отмены
        echo $! > "$PID_FILE"
    elif [ "$STATE" == "1" ]; then
        # Отмена тестирования
        echo "0" > "$STATE_FILE"
        if [ -f "$PID_FILE" ]; then
            # Убиваем дочерние процессы (python3/awk) и сам сабшелл
            pkill -P $(cat "$PID_FILE") 2>/dev/null
            kill $(cat "$PID_FILE") 2>/dev/null
        fi
        pkill -SIGRTMIN+8 waybar
    elif [ "$STATE" == "2" ]; then
        # Закрыть результат и вернуть иконку
        echo "0" > "$STATE_FILE"
        pkill -SIGRTMIN+8 waybar
    fi
    exit 0
fi

if [ "$1" == "reset" ]; then
    echo "0" > "$STATE_FILE"
    if [ -f "$PID_FILE" ]; then
        pkill -P $(cat "$PID_FILE") 2>/dev/null
        kill $(cat "$PID_FILE") 2>/dev/null
    fi
    pkill -SIGRTMIN+8 waybar
    exit 0
fi

# Проверка интернета по наличию маршрута во внешку (надежнее чем ip link)
if ip route get 1.1.1.1 &>/dev/null; then
    ICON="󰈀"
else
    ICON="󰈂"
fi

if [ "$STATE" == "0" ]; then
    echo '{"text": "'"$ICON"'"}'
elif [ "$STATE" == "1" ]; then
    echo '{"text": "..."}'
elif [ "$STATE" == "2" ]; then
    if [ -f "$RESULT_FILE" ]; then
        res=$(cat "$RESULT_FILE")
    else
        res="Err"
    fi
    echo '{"text": "'"$res"'\nMb"}'
fi
