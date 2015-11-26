function [ P, weight ] = updateParticle( P, D, map )
    %updateParticle updates a single particle according to the
    %probabilities of the map occupancy and the noise given by odom sigma
    %and the laser sigma. Also updates the particle pose by the odom data
    
    P = updateParticlePose(P, D);
    P = updateParticleWeight(P, D, map);
    weight = P.weight;
    
end

