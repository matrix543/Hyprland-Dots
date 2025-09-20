#!/bin/bash
timer=$((60*10)) ##10 min timer between each try
hour="06" ## restart mpvpaper after 6 hours

get_timer() {
command=$(ps -eo comm,etime | grep "mpvpaper")
echo $command | cut -d ' ' -f2
}

start_mpvpaper() {
    mpvpaper '*' -o "load-scripts=no panscan=1 no-audio --loop" "$HOME/.config/hypr/wallpaper_effects/.current" > /dev/null 2>&1 &
}

kill_mpvpaper() {
    pkill mpvpaper
}

while true; do
    t=$(get_timer);


    IFS=":" read -r -a array <<< "${t}";
   
    if [[ "${array[2]}" ]]; then
        #echo "${array[2]}";
       # echo 'no extra zero need';
       t="${t}"
    else
        t="00:${t}"
    fi
    
    timer_func=$(date -d $t '+%T');
    #echo $timer_func;

    ##if mpvpaper been run longer when 6 hour restart mpvpaper
    if [[ $timer_func > $(date -d "${hour}:00:00" '+%T') ]]; then
        echo "greater then ${hour} hour"
        
        if pgrep -x "mpvpaper" > /dev/null; then
            kill_mpvpaper
        fi
        start_mpvpaper

    #else
    #    echo "less then ${hour} hour"
    fi
    
    sleep $timer
done
