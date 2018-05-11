function acc = GetAccelaration(v1, v2, t)
    deltaV = v2 - v1;
    acc = deltaV / t;
end