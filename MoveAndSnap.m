function [img, flag] = MoveAndSnap(mode, my_tello, img_in, displace, offset, my_camera)
    global my_camera;
    move_vector = [0, 0.2*((displace > offset) - (displace < - offset))];
    if (norm(move_vector)>0)
        if (mode>0)
        % real mode일 때
            move(my_tello, move_vector, 'WaitUntilDone', true); % move_vector 벡터 방향으로 드론 이동
            img = snapshot(my_camera); % 드론 카메라 스크린샷
        else
        % simulation mode일 때
            vector_string = sprintf('%.1f, ', move_vector); % 소수점 첫째자리까지 move_vector를 문자열로 변경
            disp(['drone move to ' vector_string(1:end-2)]);
            trans_vector = -move_vector(2:3).*[1000, 1000];
            % move_vector에서 x와 y 값을 가져오기
            % 각각 .* -1000
            img = imtranslate(img_in, trans_vector);
            % trans_vecter의 x와 y 값 만큼 img_in를 이동한 img 생성
        end
        flag = true; % 반복
    else
    % 드론이 target vector에 도착하면
        disp('done');
        img = img_in; % 기존 이미지 입력
        flag = false; % 중지
    end