function speed = GetAvgSpeed(dist, time)
    dist = dist * 0.3048;
    speed = dist / time;
    speed = (speed * 18.0) / 5;
end