function t=formatTime(secs);
if secs == 0
    t=sprintf('(no time available)');
    return
elseif secs < 1
    t=sprintf('<1s');
    return
else
    hours = 0;
    minutes = 0;
    seconds = 0;
    minutes = floor(secs / 60);
    seconds = rem(secs, 60);
    if minutes > 60
        hours = floor(minutes / 60);
        minutes = minutes - (hours*60);
    end
    t=sprintf('%ih%im%.0fs',hours,minutes,seconds);
    return
end
end