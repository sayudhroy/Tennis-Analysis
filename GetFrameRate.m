function rate = GetFrameRate(file)
videoObj = VideoReader(file);
info = get(videoObj);
rate = info.FrameRate;
end
