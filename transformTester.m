p1 = [-1; 1; 1];
p2 = [0; 1; 1];
origin = [1; 0; 1];
p4 = [0; -1; 1];
p5 = [-1; -1; 1];
shape = [p1 p2 origin p4 p5];


axis([-5,5,-5,5]);

% Set up the transformation matrices, including the terms necessary for
% multiplying with the point vectors
A = [1 0 4; 0 1 0; 0 0 1];
theta = pi/4;
B = [cos(theta), -sin(theta), 0;
    sin(theta), cos(theta), 0;
    0, 0, 1];

aPose = B * shape;
plot(aPose(1,:), aPose(2,:));
axis([-5,5,-5,5]);