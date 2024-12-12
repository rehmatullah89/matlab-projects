%it reads avi video
avivideo = aviread('myvideo.avi');

video = {avivideo.cdata};

%it calls function of motion detection
MotionDetection(video);
