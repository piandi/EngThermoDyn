function [ dYdt ] = odefun1( t, Y )
dYdt = zeros(2, 1);
dYdt(1) = Y(2);
dYdt(2) = (43905649941839609375/(562949953421312*(Y(1) + 1)) - 8781129988367921875/562949953421312)/10;
end

