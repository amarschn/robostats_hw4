function [ Particles ] = resetParticles( Particles )
    %resetParticleWeights resamples all particles according to their weights 
    %and sets all particle weights to a value of 1
    
    % Find an array containing all weights (this is the L1 norm)
    weights = cellfun(@getParticleWeight, Particles);
    weights = weights/sum(weights);
    
    % Select indices of new particles according to particle weights
    choices = mnrnd(1, weights, numel(Particles));
    
    % Find the actual index values
    [~, idx] = find(choices);
    
    Particles = Particles(idx);
end

