% Temporary generate
all_theta_f = [];
all_theta_i = [];
all_h_f = [];
all_h_i = [];

range=0.1;

%theta_is = [-range,0,range];
%h_is = [-range,0,range];
theta_is = [-0.1,0.1];
h_is = [-0.1,0.1];

fullrange = [-range:0.01:range]';

for tt=1:length(theta_is)
    for hh=1:length(h_is)
        theta_i = theta_is(tt)*ones(length(fullrange),1);
        h_i = h_is(hh)*ones(length(fullrange),1);

        % theta only
        all_theta_i = [all_theta_i ; theta_i(:)];
        all_theta_f = [all_theta_f ; fullrange];
        all_h_i = [all_h_i ; h_i(:)];
        all_h_f = [all_h_f ; h_i(:)];
        
        % h only
        all_theta_i = [all_theta_i ; theta_i(:)];
        all_theta_f = [all_theta_f ; theta_i(:)];
        all_h_i = [all_h_i ; h_i(:)];
        all_h_f = [all_h_f ; fullrange];
        
        % theta and h in order
        all_theta_i = [all_theta_i ; theta_i(:)];
        all_theta_f = [all_theta_f ; fullrange];
        all_h_i = [all_h_i ; h_i(:)];
        all_h_f = [all_h_f ; fullrange];
        
        % theta and h, reverse h
        all_theta_i = [all_theta_i ; theta_i(:)];
        all_theta_f = [all_theta_f ; fullrange];
        all_h_i = [all_h_i ; h_i(:)];
        all_h_f = [all_h_f ; fullrange(end:-1:1)];
    end
end

% ---------------------------

for ii=1:length(all_theta_f)
    disp([num2str(all_theta_i(ii)) ' ' num2str(all_theta_f(ii)) ' ' ...
          num2str(all_h_i(ii)) ' ' num2str(all_h_f(ii)) ])          
end
