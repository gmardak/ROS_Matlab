function robot_controller(~, rosmsg_handles)
disp('robot_controller is run');
global rosmsg_handles;

disp(rosmsg_handles.goal)

x = rosmsg_handles.robotPosePubmsg.X
y = rosmsg_handles.robotPosePubmsg.Y
theta = rosmsg_handles.robotPosePubmsg.Z

goal_x = rosmsg_handles.goal(1,1);
goal_y = rosmsg_handles.goal(1,2);
goal_theta = rosmsg_handles.goal(1,3);

delta_x = round(goal_x - x, 3)
delta_y = round(goal_y - y, 3)


if height(rosmsg_handles.goal) > 0
    if ~(delta_x == 0 || delta_y == 0) ||...
   ~(rosmsg_handles.robotPosePubmsg.Z > rosmsg_handles.goal(1,3)-0.1 && rosmsg_handles.robotPosePubmsg.Z < rosmsg_handles.goal(1,3)+0.1)
        disp('entered')
        disp(height(rosmsg_handles.goal))
        goal_x = rosmsg_handles.goal(1,1);
        goal_y = rosmsg_handles.goal(1,2);
        goal_theta = rosmsg_handles.goal(1,3);

    else
        if height(rosmsg_handles.goal) > 1
            rosmsg_handles.goal(1,:) = [];

            goal_x = rosmsg_handles.goal(1,1);
            goal_y = rosmsg_handles.goal(1,2);
            goal_theta = rosmsg_handles.goal(1,3);

        else
            goal_x = rosmsg_handles.goal(1,1);
            goal_y = rosmsg_handles.goal(1,2);
            goal_theta = rosmsg_handles.goal(1,3);
           rosmsg_handles.goal(1,:) = []; 
        end

    end

end


delta_x = round(goal_x - x, 3);
delta_y = round(goal_y - y, 3);

disp(goal_x);
disp(goal_y);
disp(goal_theta);

disp(atan2(delta_y, delta_x));
disp(goal_theta);
disp(theta);

rosmsg_handles.robotControllermsg.X = 0;
rosmsg_handles.robotControllermsg.Y = 0;
rosmsg_handles.robotControllermsg.Z = 0;

% assuming delta_x ~= 0

if ~(theta > atan2(delta_y, delta_x)-0.1 && theta < atan2(delta_y, delta_x) + 0.1) && (delta_x ~= 0 && delta_y ~= 0)
    disp('entered heading section');

    if atan2(delta_y, delta_x) > theta
        rosmsg_handles.robotControllermsg.Z = 0.1;
    elseif atan2(delta_y, delta_x) < theta
        rosmsg_handles.robotControllermsg.Z = -0.1;
    end

elseif(delta_y ~= 0 && delta_x ~= 0)     %(y ~= goal_y && x ~= goal_x)
    disp('entered x -y section');

%     if goal_x > 0
%         disp('x > 0');
%         rosmsg_handles.robotControllermsg.X = 0.2;
%         rosmsg_handles.robotControllermsg.Y = goal_y/goal_x * 0.2;
    if delta_x > 0
        disp('x > 0');
        rosmsg_handles.robotControllermsg.X = 0.2;
        rosmsg_handles.robotControllermsg.Y = delta_y/delta_x * 0.2;
%     elseif goal_x < 0
%         disp('x < 0');
%         rosmsg_handles.robotControllermsg.X = -0.2;
%         rosmsg_handles.robotControllermsg.Y = goal_y/goal_x * -0.2;
    elseif delta_x < 0
        disp('x < 0');
        rosmsg_handles.robotControllermsg.X = -0.2;
        rosmsg_handles.robotControllermsg.Y = delta_y/delta_x * -0.2;
    else
        disp('x = 0');
        rosmsg_handles.robotControllermsg.Y = 0.2;
    end

elseif(delta_x == 0 || delta_y == 0)

    disp('entered goal theta section');
    if theta > goal_theta
        rosmsg_handles.robotControllermsg.Z = -0.1;
    else
        rosmsg_handles.robotControllermsg.Z = 0.1;
    end
end

if ((~(delta_x == 0 || delta_y == 0) || ~(theta > goal_theta-0.1 && theta < goal_theta+0.1)) && height(rosmsg_handles.goal) > 0)
    disp('send');
    send(rosmsg_handles.robotControllerPub,rosmsg_handles.robotControllermsg);
end
end