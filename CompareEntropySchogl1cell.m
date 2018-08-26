% Compares entropy of Schogl model with relative zip file size of time-series

thetas = [-0.2:0.05:0.3];
% thetas = -0.1;
% thetas = 0;
nc = 100;

% nReplicates = 1;
nReplicates = 1;

ShannonS = zeros(length(thetas),nReplicates);
ZipS = zeros(length(thetas),nReplicates);

Ising = struct;

for rr=1:nReplicates
    multiWaitbar('Relicates',(rr-1)/nReplicates);
    for th=1:length(thetas)
        % Choose Ising variables,
        multiWaitbar('Theta',(th-1)/length(thetas));
        disp(['Theta ' num2str(thetas(th)) ' ; nc ' num2str(nc)]);
        Ising.nc = nc;
        Ising.theta = thetas(th);
        Ising.h = 0;
        Ising.g = 0;
        Ising.tspan = [0, 200000];  % Actual time
        Ising.n0    = [Ising.nc];    % Initial copy number
        
        Schlogl = SchloglFromIsing(Ising);
        
        %         Schlogl = struct;
        %         Schlogl.s = 3*(Ising.nc-1);
        %         Schlogl.K = sqrt(3*Ising.theta*Ising.nc^2 + 3*(Ising.nc-1)*(Ising.nc-2)+1);
        %         Schlogl.a = ((3*Ising.theta+3*Ising.h+1)*Ising.nc^3 - 6*(Ising.nc-1))/(Schlogl.K^2);
        %         Schlogl.g = Ising.g;
        
        [Pn,t,n] = SimulateSchlogl1cell_mex(Ising.tspan, Ising.n0, Schlogl,5E8,1E6);
        
        
        f = find(Pn);
        ShannonS(th,rr) = -sum(Pn(f).*log(Pn(f)));
        
%         len = length(n);
%         if(len>2E7)
%             smalln = n((len-2E7):end);
%         else
%             smalln = n;
%         end
        
        % Resample:
        df = diff(t);
        f = find(df==0);
        if(~isempty(f))
            t(f) = t(f)+1E-10;
        end 
        % Works:
        smalln = round(interp1(t,n,[1:200:Ising.tspan(2)]));
        
        % Doesn't work:
%         df = diff(t);
%         smalln = round(interp1(t(1:end-1),df,[1:10:Ising.tspan(2)]));
        
        w = whos('smalln');
        Zsmalln = dzip(smalln);
        Zw = whos('Zsmalln');
        ZipS(th,rr) = Zw.size / w.size;
        
        
        %     diffs = round((diff(n)+1)/2);
        %     mex_WriteMatrix('temp.txt',diffs,'%.0f','','w+');
        
        %     mex_WriteMatrix('temp.txt',n','%03.0f','','w+');
        %     finfo = dir('temp.txt');
        %     textfilesize = finfo.bytes;
        %     gzip('temp.txt');
        %     finfo = dir('temp.txt.gz');
        %     zipfilesize = finfo.bytes;
        %     ZipS(th) = zipfilesize / textfilesize;
        
        %     tempstruct = struct;
        %     tempstruct.Pn = Pn;
        %     tempstruct.t = t;
        %     tempstruct.n = n;
        %     distr{th} = tempstruct;
        %     save('onceDistr','distr','-v7.3');
    end
    multiWaitbar('Theta','Close');
end
multiWaitbar('Relicates','Close');

%% Plot
figure;

tmap = colormap(parula(length(thetas)));

subplot(1,3,1);
hold on
for rr=1:nReplicates
    for th=1:length(thetas)
        plot(ShannonS(th,rr),ZipS(th,rr),'*','Color',tmap(th,:),'DisplayName',['\theta = ' num2str(thetas(th))]);
    end
end
xlabel('Shannon');
ylabel('Zip');

subplot(1,3,2);
hold on
for rr=1:nReplicates
    plot(thetas,ShannonS(:,rr)/max(ShannonS(:,rr)),'.-r','DisplayName','Shannon');
    plot(thetas,ZipS(:,rr)/max(ZipS(:,rr)),'.-b','DisplayName','Zip');
end
legend('show');

subplot(1,3,3);
% plot(log(ShannonS),log(ZipS));
hold on
for rr=1:nReplicates
    % plot(ShannonS,ShannonS./ZipS,'.-');
%     plot(ShannonS(:,rr),ShannonS(:,rr)./ZipS(:,rr),'.-');
    plot(thetas,ShannonS(:,rr)./ZipS(:,rr)/max(ShannonS(:,rr))*max(ZipS(:,rr)),'.-');

end

xlabel('\theta');
ylabel('Shannon/Zip');


%%


% %% Calculate entropies
% ShannonS = zeros(length(thetas),1);
% ZipS = zeros(length(thetas),1);
% 
% for th=1:length(thetas)
%     multiWaitbar('Theta',(th-1)/length(thetas));
%     f = find(distr{th}.Pn);
%     ShannonS(th) = -sum(distr{th}.Pn(f).*log(distr{th}.Pn(f)));
%     
%     % Save events to ascii file
%     n = distr{th}.n;
%     
%     diffs = diff(n)+1;
%     
%     save('temp.txt','diffs','-ascii');
%     finfo = dir('temp.txt');
%     textfilesize = finfo.bytes; 
%     gzip('temp.txt');
%     finfo = dir('temp.txt.gz');
%     zipfilesize = finfo.bytes; 
%     ZipS(th) = zipfilesize / textfilesize;
% end
% multiWaitbar('Theta','Close');

