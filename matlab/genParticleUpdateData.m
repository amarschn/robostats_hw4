function [ update_data ] = genParticleUpdateData( Data )
    %genParticleUpdateData will create a cell array that contains the
    %odometry and laser data "update" from the previous pose/data
    
    update_data = cell(size(Data));
    
    load '../data/trig.mat';
    
    for d = 1:numel(Data)
        
        D = Data{d};
        U = struct();
        U.type = D.c;
        
        if d == 1
            xd = D.x;
            yd = D.y;
            thd = D.th;
        end
        
        dx = D.x - xd;
        dy = D.y - yd;
        dth = D.th - thd;
        
        % pose change
        U.dp = [dx, dy, dth];
        
        if D.c == 'L'
            
            % Store the laser change in position as just the change in position from
            % the center of the robot
            U.dp_l = ([D.x_l, D.y_l, D.th_l] - [D.x, D.y, D.th]);
            
            
            
            laser_points = [D.r' .* Cos', D.r' .* Sin'];
            
            % Rotate the laser points by -90 deg so that they are centered
            % about the x+ axis
            rot = [cos(-pi/2), -sin(-pi/2);sin(-pi/2), cos(-pi/2)];
            laser_points = (rot * laser_points')';
            
            
            % Store the laser points
            U.lp = laser_points;
        end
        
        update_data{d} = U;
        
        xd = D.x;
        yd = D.y;
        thd = D.th;
    end
    
    
end

