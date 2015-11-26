function [ Particles, weight_ratio ] = updateParticles(Particles, Data, map)
    %updateParticleWeights : updates all particle weights according to the
    %Data point
    
    weights = ones(numel(Particles),1);
    parfor p = 1:numel(Particles)
        [P, W] = updateParticle(Particles{p}, Data, map);
        weights(p) = W;
        Particles{p} = P;
    end
    
    weight_ratio = max(weights) / min(weights);
    
    if weight_ratio > 10000
        Particles = resetParticles(Particles);
    end
    
end

