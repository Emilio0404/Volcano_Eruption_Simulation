%% Volcanic Eruption Simulation
% José Emilio Alvear Cantú

%% INITIALIZE VECTORS AND VARIABLES

% Clear figure 1
clf('reset')

% Gravity
g = 9.81;

% Ask for number of projectiles
projectile_count = input('\nHow many projectiles will there be? ');

% Ask for Volcano height
yo = input('\nWhat is the height of the volcano? (1000 meters recommended) ');

% Ask for the diamater of the crater
diameter = input('\nHow big is the diameter of the crater (100 meters recommended) ');

% Time
h = 0.08;
t = 0:h:50;
delay = zeros(projectile_count,1); %Initialize vector for the delay of each projectile

% Initialize vectors for magnitude and direction of each projectile
magnitude = zeros(projectile_count,1);
direction = zeros(projectile_count,1);

% Initialize vectors for the veolcity components
vx = zeros(projectile_count,length(t));
vy = zeros(projectile_count,length(t));

% Initialize vectors for positions
x = zeros(projectile_count,length(t));
y = zeros(projectile_count,length(t));

% Initialize vectors for masses, accelerations, and friction coefficients
b = zeros(projectile_count,1);
mass = zeros(projectile_count, 1);
axf = zeros(projectile_count,length(t));
ayf = zeros(projectile_count,length(t));

% Initialize vectos for the color of each projectile
color = zeros(projectile_count,3);

disp([' ']);

%% FILLING INITIAL VALUES OF THE VECTORS

for i = 1:projectile_count
    
    %Displays information of current projectile
    disp(['Tiro ' num2str((i))]);
    
    %Projectile magnitud
    magnitude(i) = randi([100 160]);
    disp(['Magnitude: ' num2str(magnitude(i))]);
    
    %Direction
    random_direction = randi([20 160]);
    disp(['Direction: ' num2str(random_direction)]);
    direction(i) = random_direction*pi/180; %convert to radians
    
    %Calculate initial velocities
    vx(i,1) = magnitude(i)*cos(direction(i)); %vo
    vy(i,1) = magnitude(i)*sin(direction(i));  %yo
    
    %Generate random initial position within the crater
    x(i,1) = randi([round(-diameter/2) round(diameter/2)]);  % xo
    disp(['Initial xo position: ' num2str(x(i,1))]);
    
    y(i,1) = yo;
    
    %Generate random mass and friction coefficient for each projectile
    b(i) = randi([1 5]);
    mass(i) = randi([10 60]);
    disp(['Mass: ' num2str(mass(i))]);
    disp(['Friction coefficient: ' num2str(b(i))]);
        
    % Generate random color for each projectile
    color(i,1) = rand(1,1);
    color(i,2) = rand(1,1);
    color(i,3) = rand(1,1);
    
    %Generate random delay for each projectile
    delay(i) =  randi(round(length(t)/2));
    
    disp([' ']);
    
end
pause(2)

%% DRAWING THE VOLCANO

hold on;

%Graph a poligon for the volcano shape
pgonx = [-(diameter+200) round(-diameter/2) round(diameter/2) diameter+200];
pgony = [0 yo yo 0];
patch(pgonx,pgony, [0.6350 0.0780 0.1840]);

%Prepare Figure 1
grid on 
title('Volcanic Eruption'); 
xlabel('Distance (in meters)'); 
ylabel('Height (in meters)');
axis([-(diameter+300)*2 (diameter+300)*2 0 yo*2])

%For each time jump
for i = 2:length(t)
    
    %Graph all particles from that time
    for j = 1:projectile_count
            
            %Calculate previous acceleration with euler method
            axf(j,i-1) = (-b(j)*vx(j, i-1))/mass(j);
            ayf(j,i-1) = -g-(b(j)*vy(j,i-1))/mass(j);
            
            %Calculate velocity with euler method
            vx(j,i) = vx(j,i-1) + axf(j,i-1)*h;
            vy(j,i) = vy(j,i-1) + ayf(j,i-1)*h;
        
            %Calculate the position of previous velocities
            x(j,i) = x(j,i-1) + vx(j,i-1)*h;
            y(j,i) = y(j,i-1) + vy(j,i-1)*h;

        % If current time is more than the delay
        % If height is more than zero
        if i > delay(j) && y(j,i-delay(j)) > -1
            
            %Graphs the particles
            plot(x(j,i-delay(j)), y(j,i-delay(j)),'.', 'color',color(j,1:3),'MarkerSize',round(mass(j)/4));
            
        end 
    end
    
    pause(0.000000000000000000001)
    
end
