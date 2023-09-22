# tello_imageprocessing.mlx code
.mlx 파일 형식이 github에서 보이지 않기 때문에, 해당 코드를 markdown 형식으로 작성합니다.


초기화
```matlab
clc;
clear variables; 
clear all;

mode = 1; % 0: simulation mode / 1: real mode
```

텔로 이륙하기
```matlab
if (mode > 0)
    my_tello = ryze();
    takeoff(my_tello);
    pause(3); % wait for stability, 안정화 후 사진 촬영을 위함
else
    my_tello = 0;
end
```

영상 가져오기
```matlab
if(mode > 0)
    global my_camera;
    my_camera = camera(my_tello); % 카메라 불러옴
    img = snapshot(my_camera); % 이미지 받음
    
    % imwrite(img, 'snapshot.png');
    % 시뮬레이션을 돌릴 때 사용할 사진 촬영 코드
else
    img = imread('snapshot.png');
end
imshow(img)
```

붉은색 공 추적하기 - 공이 화면 중앙에 오도록 제어하기
```matlab
[height, width, channels] = size(img);
center = [width/2, height/2]; % 중앙
offset = [round(width/12), round(height/12)]; % 중앙 언저리

flag = true; % 제어 시작 flag

ball_pos = zeros();
ball_radius = zeros();

while(flag)
    [ball_pos, ball_radius] = FindRedBall(img);
    if ball_radius == 0
        % 옆으로 0.2m
        moveright(my_tello, 'Distance', 0.2, 'WaitUntilDone', false);
        pause(1);
        img = snapshot(my_camera);
    else
        displace = (ball_pos - center);
        [img, flag] = MoveAndSnap(mode, my_tello, img, displace, offset)
        drawrectangle('Position', [center - offset, offset * 2], 'Color', [0 1 0]);
        % a = input('press enter'); %Enter 눌러 드론 이동
    end
end
```

초록색 공 추적하기 - 공이 화면 중앙에 오도록 제어하기
```matlab
[height, width, channels] = size(img);
center = [width/2, height/2]; % 중앙
offset = [round(width/12), round(height/12)]; % 중앙 언저리

flag = true; % 제어 시작 flag

while(flag)
    [ball_pos, ball_radius] = FindGreenBall(img);
    if ball_radius == 0
        moveup(my_tello, 'Distance', 0.2, 'WaitUntilDone', false);
        pause(0.4);
        img = snapshot(my_camera);
    else
        displace = (ball_pos - center);
        [img, flag] = MoveAndSnap(mode, my_tello, img, displace, offset)
        drawrectangle('Position', [center - offset, offset * 2], 'Color', [0 1 0]);
        % a = input('press enter'); %Enter 눌러 드론 이동
    end
end
```

파란색 공 추적하기 - 공이 화면 중앙에 오도록 제어하기
```matlab
[height, width, channels] = size(img);
center = [width/2, height/2]; % 중앙
offset = [round(width/12), round(height/12)]; % 중앙 언저리

flag = true; % 제어 시작 flag


while(flag)
    [ball_pos, ball_radius] = FindBlueBall(img);
    if ball_radius == 0
        moveright(my_tello, 'Distance', 0.2, 'WaitUntilDone', false);
        pause(1);
        img = snapshot(my_camera);
    else
        displace = (ball_pos - center);
        [img, flag] = MoveAndSnap(mode, my_tello, img, displace, offset)
        drawrectangle('Position', [center - offset, offset * 2], 'Color', [0 1 0]);
        % a = input('press enter'); %Enter 눌러 드론 이동
    end
end
```

텔로 착륙하기
```matlab
if (mode>0)
    land(my_tello);
end
clear variables;
```



