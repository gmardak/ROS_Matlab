function robotPosePublisher(~, ~, rosmsg_handles)

disp('robotPosePublisher is run');

global rosmsg_handles
    
    if isvalid(rosmsg_handles.robotPosePub)

        rosmsg_handles.robotPosePubmsg.X = rosmsg_handles.robotPosePubmsg.X + rosmsg_handles.robotControllermsg.X;
        %I access global handle and add the x value sent from the robot
        %controller. Here I am over simplifying my controller, because I
        %didn't want to deal with integration.
        disp(rosmsg_handles.robotPosePubmsg.X);
        rosmsg_handles.robotPosePubmsg.Y = rosmsg_handles.robotPosePubmsg.Y + rosmsg_handles.robotControllermsg.Y;
        disp(rosmsg_handles.robotPosePubmsg.Y);
        rosmsg_handles.robotPosePubmsg.Z = rosmsg_handles.robotPosePubmsg.Z + rosmsg_handles.robotControllermsg.Z;
        disp(rosmsg_handles.robotPosePubmsg.Z);
        
        if rosmsg_handles.robotPosePubmsg.X ~= rosmsg_handles.goal(1,1) || rosmsg_handles.robotPosePubmsg.Y ~= rosmsg_handles.goal(1,2) || rosmsg_handles.robotPosePubmsg.Z ~= rosmsg_handles.goal(1,3)
            %In order to stop infinitly calling each other, I inserted send
            %into an if statement: if it reached the final goal, then don't
            %send
            send(rosmsg_handles.robotPosePub,rosmsg_handles.robotPosePubmsg);
        end
    end
%% Plot position and orientation
persistent h_quiver % to delete the arrow each time before replotting, while keeping a trace of previous positions. 
figure(1)
hold on
r = 0.2; % length of arrow to plot
u = r * cos(rosmsg_handles.robotPosePubmsg.Z); % convert polar (theta,r) to cartesian
v = r * sin(rosmsg_handles.robotPosePubmsg.Z);
plot(rosmsg_handles.robotPosePubmsg.X,rosmsg_handles.robotPosePubmsg.Y,'r.');
delete(h_quiver)
h_quiver = quiver(rosmsg_handles.robotPosePubmsg.X,rosmsg_handles.robotPosePubmsg.Y,u,v,'LineWidth',2,'MaxHeadSize',2, ...
    'AutoScale','off','Color',[0 0 1]);

end