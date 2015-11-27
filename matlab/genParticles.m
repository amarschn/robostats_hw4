function [ Particles ] = genParticles( map, num_particles, initial_theta )
    %genParticles generates particles in random positions in the map
    
    Particles = cell(num_particles,1);
    
    % Create particle starting points on the map at allowed locations for the
    % initial scan
    p = 0;
    while p < num_particles
        T = rand(1,2) * length(map.grid) * map.res;
        A = rand * 2 * pi; % The angle of the particle odometry frame to the world frame
        
        occ = map.getMapOcc(T(1), T(2));
        
        if occ > 0.9
            p = p + 1;
            P = struct();
            P.weight = 1;
            
            P.A = A;
            % The initial robot pose is the translation of the odometry frame
            % to the world frame and the initial robot theta
            P.robot_pose = [T(1), T(2), initial_theta + P.A];
            % This is the rotation transform of the particle's odometry frame
            % from the world frame
            P.R = [cos(A), -sin(A);
                sin(A), cos(A)];
            % This is the sigma of the two sensor modalities
            P.odom_sigma = 1;
            P.laser_sigma = 0.5;
            
            Particles{p} = P;
        end
    end
end

