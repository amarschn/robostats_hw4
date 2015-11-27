function [ ] = particleFilterParallel( map, data, num_particles_initial, num_particles_final, range, resample_thresh, o_std, l_std )
    %particleFilter runs a particle filter and creates a gif of the
    %particle visualization
    % map : class structure of the map to be used
    % data : string name of the log file to be used
    % num_particles : the number of particles to use in the particle filter
    % range : range of acceptable x and y coordinates for starting
    %         locations of the particles
    % resample_thresh : the weight ratio threshold of resampling the
    %                   particles
    % o_std : the standard deviation of the odometry sensor model
    % l_std : the standard devation of the laser sensor model
    
    switch data
        case 'robotdata1.log'
            load '../../data/log/Data1.mat';
        case 'robotdata2.log'
            load '../../data/log/Data2.mat';
        case 'robotdata3.log'
            load '../../data/log/Data3.mat';
        case 'robotdata4.log'
            load '../../data/log/Data4.mat';
        case 'robotdata5.log'
            load '../../data/log/Data5.mat';
        otherwise
            data = 'robotdata1.log';
            load '../../data/log/Data1.mat';
    end
    
    % Generate the update data
    D = genParticleUpdateData(Data);
    
    % Generate the initial particles, all with the initial theta given by
    % the dataset
    Particles = genParticles(map, num_particles_initial, Data{1}.th);
    
    
    i = 1;
    
    for d = 1:numel(D)
        
        % Update the particle positions and weights
        [Particles, weight_ratio] = updateParticles(Particles, D{d}, map, resample_thresh);
        
        
        if mod(d,10) == 0 || d == 1
            d
            images(:,:,i) = map.visualizeParticles(Particles, 0);
            i = i + 1;
        end
        
        % Change the number of particles to something more reasonable
        if d == 1
            [Particles] = particleSieve(Particles, num_particles_final);
        end
    end
    
    
    
    %% This saves a gif file and adds to the csv file listing all attributes of the visualizations
    
    % file name
    vis_file_name = strcat(data, '_', num2str(num_particles_initial),...
                           datestr(now,30));
    file = strcat('../visualization/', vis_file_name, '.gif');
    
    % Video creation
    fh = figure(1);
    for i = 1:size(images,3)
        imagesc(images(:,:,i));
        drawnow;
        frame = getframe(fh);
        im = frame2im(frame);
        [A,map] = rgb2ind(im,256);
        if i == 1
            imwrite(A,map,file, 'gif','LoopCount',Inf,'DelayTime',1);
        else
            imwrite(A,map,file,'gif','WriteMode','append','DelayTime',1);
        end
        
    end
    
    
%     fid = fopen('../visualization/file_info.csv');
%     
%     
%     fclose(fid);
    
    fprintf('Data log: %s\n', data);
    fprintf('Number of initial particles: %d\n', num_particles_initial);
    fprintf('Number of final particles: %d\n', num_particles_initial);
    fprintf('Range of acceptable values: %d - %d\n', min(range), max(range));
    fprintf('Re-sampling weight ratio threshold: %d\n', resample_thresh);
    fprintf('Odometry sensor model standard deviation: %.3f\n', o_std);
    fprintf('Laser sensor model standard deviation: %.3f\n', l_std);
end

