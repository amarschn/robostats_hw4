Cos = [];
Sin = [];

R = linspace(0,180,180);
for r = 1:numel(R)
    Cos(r) = cosd(r);
    Sin(r) = sind(r);
end

save('../data/trig.mat', 'Cos', 'Sin');