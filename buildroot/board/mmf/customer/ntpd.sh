#!/bin/sh

PID_FILE="/var/run/ntpd.pid"
NTP_SERVER="pool.ntp.org"

start() {
    echo "Starting ntpd..."
    mkdir -p $(dirname "$PID_FILE")

    ntpd -n -p $NTP_SERVER -S "hwclock -w" &
    echo $! > "$PID_FILE"
}

stop() {
    if [ -f "$PID_FILE" ]; then
        echo "Stopping ntpd..."
        PID=$(cat "$PID_FILE")
        kill $PID 2>/dev/null
        rm -f "$PID_FILE"
    else
        echo "ntpd is not running."
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 1
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0