function [ new_particles ] = particleSieve( Particles, num_particles )
    %particleSieve returns a subset of the highest-weighted particles
    
    weights = cellfun(@getParticleWeight, Particles);
    [~,idx] = sort(weights,'descend');
    new_particles = Particles(idx);
    new_particles = new_particles(1:num_particles);
end

