% function [psth trialspx] = SDF_Raster_PSTH_LvRvO_mlibJC_fun(psth_center_evtID, Other_trial_type)
% function [psth trialspx] = SDF_Raster_PSTH_LvRvO_mlibJC_fun(psth_center_evtID, Other_trial_type)
% Plot a SDF and Raster blue ('cCR' = correct Choice Right), red ('cCL' = correct Choice Left)
% and grey (Other: Define by INPUT argument.
% INPUT1 : evt_center =
% 'Delay'; 'APuff'; 'GoCue'; 'Licks'; 'Valve'
% INPUT2 : Other_trial_type =
% 'iCR' = impulse Choice Right (or Left: 'iCL')
% 'oCR' = opto correct Choice Right (or Left: 'oCL')
% 'ocC' = opto correct Choices (L+R)
% 'oNO' = opto Not Licked.
% 'ePL' = error Puff Left (lick R instead of L)
% This function use the mlib toolbox for mraster, mpsth and msdf.
% Written by Julien Catanese, 10/03/2018, in JaegerLab.
% Last Updated: 10/08/2018
psth_center_evtID = 'GoCue'
% Other_trial_type = []
clearvars -except  psth_center_evtID Other_trial_type
close all,

%% Define PSTH parameter

% if nargin==0;
%         display('NOT ENOUGH INPUT ARGUMENTS: min=1')
% elseif nargin==1;
disp(['psth Center = ' psth_center_evtID]);
disp('NO Other trial type, plotting LvR only');
trial_type_list = {'cCL', 'cCR'};
Special_trial= 'x';
% elseif nargin==2;
%      display(['Other trial type = ' Other_trial_type]);
%      trial_type_list = {'cCL', 'cCR', Other_trial_type};
%      Special_trial= Other_trial_type;
% elseif nargin>2;
%     display('TOO MANY INPUT ARGUMENTS: max=1');
% end

psth_trig_evt =  psth_center_evtID; % 'Delay', % 'APuff' % 'GoCue' % 'Valve' %'Licks'
NbTtrialType = max(size(trial_type_list));
%% load data
load('info.mat');
load('evt.mat');
load('time.mat');
load('Ntrial_type.mat');
sr=info.info_freq_parameters.board_dig_in_sample_rate;

%% GET trigtimes : times of the psth_trig_evt is sec   (1 vector of times)
% define trial idx
trig_end = find(diff(evt_trial)<0);
trig_st = find(diff(evt_trial)>0);

idx_trial_start = trig_end(1:end-1); %-(1*sr);
idx_trial_end = trig_st(2:end) ;     %-(1*sr);

Ntrials= max(size(idx_trial_start)); if Ntrials==trial.Ntrial; disp('good Ntrial'); else forcestop; end ;

% define common events
evt_valve = evt_rwd_L + evt_rwd_R;
evt_lick = evt_lick_L + evt_lick_R;
evt_puff =evt_puff_L + evt_puff_R;
evt_prelick = evt_delay + evt_puff;


trigtimes=[];
for tr=1:Ntrials
    time_tr = time(idx_trial_start(tr):idx_trial_end(tr));
    if psth_trig_evt=='APuff'
        puff_tr=  evt_puff(idx_trial_start(tr):idx_trial_end(tr));
        idx_puff_st = find(diff(puff_tr)>0); % start of the puff
        time_puff_st = time_tr(idx_puff_st);
        trigtimes = [trigtimes time_puff_st]; % in sec
        
    elseif psth_trig_evt=='Delay'
        delay_tr= evt_delay(idx_trial_start(tr):idx_trial_end(tr));
        idx_delay_st = find(diff(delay_tr)>0) ; % start of the delay
        time_delay_st = time_tr(idx_delay_st);
        trigtimes = [trigtimes time_delay_st]; % in sec
        
    elseif psth_trig_evt=='GoCue'
        delay_tr= evt_delay(idx_trial_start(tr):idx_trial_end(tr));
        idx_GO_st = find(diff(delay_tr)<0) ; % end of the delay
        time_GO_st = time_tr(idx_GO_st);
        trigtimes = [trigtimes time_GO_st]; % in sec
        
    elseif psth_trig_evt=='Licks'
        lick_tr=  evt_lick(idx_trial_start(tr):idx_trial_end(tr));
        idx_lick_st = min(find(diff(lick_tr)>0));% start of the first lick
        if isempty(idx_lick_st) % replace by Lick evt by GOcue evt for centering during NOlick trial
            delay_tr= evt_delay(idx_trial_start(tr):idx_trial_end(tr));
            idx_GO_st = find(diff(delay_tr)<0)
            idx_lick_st=idx_GO_st;
        end
        time_lick_st = time_tr(idx_lick_st);
        trigtimes = [trigtimes time_lick_st]; % in sec
        
    elseif psth_trig_evt=='Valve'
        valve_tr= evt_valve(idx_trial_start(tr):idx_trial_end(tr));
        idx_valve_st = find(diff(valve_tr)>0) ; % start of the valve
        time_valve_st = time_tr(idx_valve_st);
        trigtimes = [trigtimes time_valve_st]; % in sec
    else
        disp(' WRONG INPUT ARG pick one: psth_trig_evt = APuff, Delay, Licks, Gocue or Valve' )
        
    end
    
end

%%
trigtimes_all=trigtimes';
trigtimes_cCL = trigtimes(trial.idx_correct_L);
trigtimes_cCR = trigtimes(trial.idx_correct_R);
trigtimes_iCL = trigtimes([trial.idx_errorDelay_PL_CL trial.idx_errorDelay_PR_CL]);
trigtimes_iCR = trigtimes([trial.idx_errorDelay_PL_CR trial.idx_errorDelay_PR_CR]);
trigtimes_oCR = trigtimes([trial.idx_correct_R_opto]);
trigtimes_oCL = trigtimes([trial.idx_correct_L_opto]);
trigtimes_ocC = trigtimes([trial.idx_correct_L_opto trial.idx_correct_R_opto]);
trigtimes_oNO = trigtimes([trial.idx_NoLick_opto]);
trigtimes_eNO = trigtimes([trial.idx_NoLick]);
trigtimes_ePL = trigtimes([trial.idx_errorResp_PL]);
trigtimes_ePR = trigtimes([trial.idx_errorResp_PR]);

%% GET spxtimes = SPIKE times in Sec (1 vector of times)
close all,
clust_file = dir('times_*S*Ch*_sub.mat');
for ncluf = 1%:max(size(clust_file)) %  channel loop
    
    load(clust_file(ncluf).name); %  e.g.: load('times_S2Ch6_man.mat')
    Nclust = max(cluster_class(:,1));
    
    for CLUST= 1:1%Nclust %Cluster loop within each channel
        idx_spk = find(cluster_class(:,1)==CLUST);
        spxtimes_ms = cluster_class(idx_spk,2);
        % convert time to sec
        spxtimes = spxtimes_ms/10^3;
        Nspk=max(size(spxtimes));
        
        nspx_delay_tr = [];
        nspx_sample_tr = [];
        nspx_resp_tr = [];
        
        figure, hold on,
        for ii=1:NbTtrialType
            
            if trial_type_list{ii} == 'all'
                trigtimes = trigtimes_all ;
            elseif trial_type_list{ii} == 'cCL'
                trigtimes = trigtimes_cCL ; disp('Correct Left trials');
            elseif trial_type_list{ii} == 'cCR'
                trigtimes = trigtimes_cCR ; disp('Correct Right trials');
            elseif trial_type_list{ii} == 'iCL'
                trigtimes = trigtimes_iCL ;
            elseif trial_type_list{ii} == 'iCR'
                trigtimes = trigtimes_iCR ;
            elseif trial_type_list{ii} == 'oCR' % opto correct Choice right
                trigtimes = trigtimes_oCR ;
            elseif trial_type_list{ii} == 'oCL'
                trigtimes = trigtimes_oCL ;
            elseif trial_type_list{ii} == 'ocC' % opto correct Choices l+r
                trigtimes = trigtimes_ocC ;
            elseif trial_type_list{ii} == 'oNO' % opto NOlick
                trigtimes = trigtimes_oNO ;
            elseif trial_type_list{ii} == 'ePL' % error Side Puff left
                trigtimes = trigtimes_ePL ;
            elseif trial_type_list{ii} == 'ePR'
                trigtimes = trigtimes_ePR ;
            elseif trial_type_list{ii} == 'eNO' % error NOlick
                trigtimes = trigtimes_eNO ;
            end
            
            pre=2000; %ms
            post=2000;%ms
            fr=1; %if '1', normalizes to firing rate (Hz); if '0', does nothing (default)
            binsz=1; %ms  bin size of psth (default: 1 ms)
           

            %SAMPLE:  Count Spikes within Puff Sample Epoch for each trial ([delaystart-750] to [delaystart+0] )
            nspx = mnspx(spxtimes,trigtimes,750,0);
            subplot(3,2,ii),
            hist(nspx,0.5:max(nspx)+0.5); xlim([0 10 ])
            title (['Sample Epoch'  trial_type_list{ii} ])
            nspx_sample_tr = [nspx_sample_tr nspx];
            
            % DELAY : Count Spikes within Delay Epoch for each trial ([delaystart+0] to [delaystart+750ms] )
            nspx = mnspx(spxtimes,trigtimes,0,750);
            subplot(3,2,ii+2),
            hist(nspx,0.5:max(nspx)+0.5); xlim([0 10 ]);
            title (['Delay Epoch'  trial_type_list{ii} ])   
            nspx_delay_tr = [nspx_delay_tr nspx]; % each coloumn title is contain i: trial_type_list  e.g. {'cCL', 'cCR'} 
                    
            
            %RESPONSE:  Count Spikes within Response Epoch for each trial ([delaystart+750] to [delaystart+2000] )
            nspx = mnspx(spxtimes,trigtimes,-750,2000);
            subplot(3,2,ii+4),
            hist(nspx,0.5:max(nspx)+0.5); xlim([0 10 ]);
            title (['Response Epoch'  trial_type_list{ii} ]) 
            nspx_resp_tr = [nspx_resp_tr nspx];
            
        end
        
        %% STAT: T-TEST
%         nspx_delay_tr    
%         nspx_sample_tr  
%         nspx_resp_tr
        
        hist(nspx,0.5:max(nspx)+0.5)
        %         ttest(nspx)
        
        
    end
end
