function [SMA SSA SSemA Sig_idx BarSig] = Get_SdfMeanAll_SigIDX_JCfun(pre, post, psth_trig_evt, psth_trial_type)

ncell=0;
SMA = []; SSA = [] ; SSemA = []; BarSig = []; Sig_idx=[]; 

cd('D:\JC_Analysis');
SessList = dir(['*/*taskopto*']);
NSess= max(size(SessList));

for ns=1:NSess
    SessID= SessList(ns).name;   SessPath=SessList(ns).folder;     cd([SessPath '\' SessID]);
    load('info.mat');    MouseID = info.info_notes.MouseID;   Day=info.info_notes.Day;
    
    [trigtimes] = Get_trigtimes(psth_trig_evt, psth_trial_type); % trigtimes in sec
    ntrial = size(trigtimes,2)
    
    clust_file = dir('times_*S*Ch*_sub.mat');   ncluf=max(size(clust_file));
    for nchan = 1:ncluf %  channel loop
        load(clust_file(nchan).name);  Nclust = max(cluster_class(:,1));
        for CLUST= 1:Nclust %Cluster loop within each channel
            ncell=ncell+1
            idx_spk = find(cluster_class(:,1)==CLUST);
            spxtimes = cluster_class(idx_spk,2)/10^3; % convert time to sec
            
            [sdf_alltrial] = Get_SDF_alltrials_JCfun(spxtimes, trigtimes, pre, post, ntrial);
            sdf_mean = mean(sdf_alltrial)         ;   sdf_std = std(sdf_alltrial)        ;  sdf_sem =  sdf_std/sqrt(ntrial);
            
            SMA = [SMA; sdf_mean]; SSA = [SSA; sdf_std] ; SSemA = [SSemA; sdf_sem];
            [Sig_idx, BarSig] = Select_sigCell_1std_JCfun_v2(sdf_mean, sdf_std, Sig_idx, BarSig, pre, post, ncell) ;       
        end;
    end
end


