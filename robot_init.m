clear all;
clc;
global rosmsg_handles
masterHost = 'localhost';
n1_robot = robotics.ros.Node('n1_robot', masterHost); %Create n1_robot node
n2_controller = robotics.ros.Node('n2_controller', masterHost); %Create n2_controller node

rosmsg_handles.robotPosePub = robotics.ros.Publisher(n1_robot,'/robot_pose','geometry_msgs/Vector3'); %Make n1_robot publisher...
%that publishes geometry_msgs/Vector3 type messages into /robot_pose topic
rosmsg_handles.robotPosePubmsg = rosmessage(rosmsg_handles.robotPosePub);

rosmsg_handles.robotControllerPub = robotics.ros.Publisher(n2_controller, '/cmd_vel', 'geometry_msgs/Vector3'); %Make n2_controller publisher...
%that publishes geometry_msgs/Vector3 type messages into /cmd_vel topic
rosmsg_handles.robotControllermsg = rosmessage(rosmsg_handles.robotControllerPub);

rosmsg_handles.goal = [-3, -5, pi/8; %Create waypoints
                        2 15 pi/4;
                        -5 -5 0];

n1_sub = robotics.ros.Subscriber(n1_robot, '/cmd_vel', @robotPosePublisher); %Make n1_robot node subscriber...
%that subscribes to /cmd_vel topic
n2_sub = robotics.ros.Subscriber(n2_controller, '/robot_pose', @robot_controller); %Make n2_controller node subscriber...
%that subscribes to /robot_pose topic
%So both nodes are subscriber, they are subscribed to each other
robotPosePublisher; %Then, I call robotPublisher to initiate my robot