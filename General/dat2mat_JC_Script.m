

% dat2mat_JC_Script
% Convert .dat from INTAN into matlab format .mat
% by JC April 2018 in Jaegerlab


%% read info.rhd file
% clear all
currentFolder= [pwd '\'];
Auto = 1;
% load rhd file (info file)
if Auto==1
    read_Intan_RHD2000_file_JC_fun (currentFolder)
else
    read_Intan_RHD2000_file
end

ampID = dir([currentFolder '\amp*.dat']);
NampA= dir([currentFolder '\amp-A*.dat']);
Nmat = dir([currentFolder '\S*Ch*_raw.mat']);
%% Ephys Channels convertion from .dat to .mat
if isempty(ampID);
    disp('no amp electrode chan found');
elseif size(NampA,1)== size(Nmat,1)
    disp('Data amp-A.dat already processed previously, SXChX_raw.mat should already be in folder, skipping this step')
else
    for ndat = 1:size(ampID,1)
        if currentFolder(25:36)== 'vgat15_w10d8' % manually corrected exceptions
            LIST= [1 5 6 8 13 15 22 23 24 26 27 29]
            ndatB = 1+LIST(ndat) %+32; if some files have been deleted after recording, but are still in info.rhd
        else
            LIST=zeros(1,64); % classic case
            ndatB=ndat
        end
        disp([amplifier_channels(ndatB).custom_channel_name '  ' amplifier_channels(ndatB).native_channel_name '  '  ampID(ndat).name])
        
        fileinfo = dir([currentFolder ampID(ndat).name]);
        num_samples = fileinfo.bytes./2; % int16 = 2 bytes
        fid = fopen([currentFolder ampID(ndat).name], 'r');
        v = fread(fid, num_samples, 'int16');
        fclose(fid);
        data = v' * 0.195; % convert to microvolts
        if ampID(ndat).name == ['amp-' amplifier_channels(ndatB).native_channel_name '.dat']
            unit='microVolts';
            sr= frequency_parameters.amplifier_sample_rate; %20000
%      save([ currentFolder amplifier_channels(ndatB).custom_channel_name_raw.mat'], 'data', 'sr', 'unit');
% change to native to  avoid error in mapping; 
            save([ currentFolder amplifier_channels(ndatB).native_channel_name '_raw.mat'], 'data', 'sr', 'unit')
            disp('ok')
        else
            disp('ERROR :  NAME MISMATCH');
            forcestop
        end
    end
end

%% rename info
info.info_DIN_ch = board_dig_in_channels; clear board_dig_in_channels;
info.info_freq_parameters = frequency_parameters; clear frequency_parameters;
% if ~isempty(ampID);
    info.info_amp_ch = amplifier_channels;  clear amplifier_channels;
    info.info_spike_trigg= spike_triggers; clear spike_triggers;
% end
save('info.mat','info')

%% Convert .DAT to .MAT for:
%% Timestamp data file: time.dat   %  creates a time vector with units of seconds:
% This file contains int32-type sequential integers (e.g., 0, 1, 2, 3�) corresponding to sample times indices, with zero marking the
% beginning of a recording or a trigger point. Time indices can be negative to denote pre-trigger times.
if ~isempty(dir('time.mat'))
    disp('Data time.dat already processed previously, time.mat should already be in folder, skipping this step')
else
    fileinfo = dir('time.dat');
    num_samples = fileinfo.bytes/4; % int32 = 4 bytes
    fid = fopen('time.dat', 'r');
    t = fread(fid, num_samples, 'int32');
    fclose(fid);
    time = t / info.info_freq_parameters.amplifier_sample_rate; % sample rate from header file
    save('time.mat','time')
end
%% Board digital input data files (e.g. board-DIN-00.dat)
% Each uint16 value in these files will be equal either to 0 or 1.
% The following MATLAB code reads a board digital input data file and creates a waveform vector:

if ~isempty(dir('evt.mat'))
    disp('Data DIN.dat already processed previously, evt.mat should already be in folder, skipping this step')
else
    DINCh=dir('board-DIN-*')
    for dd = 1:size(DINCh,1)
        clear fid
        fileinfo = DINCh(dd);
        num_samples = fileinfo.bytes/2; % uint16 = 2 bytes
        fid = fopen(DINCh(dd).name, 'r');
        
        if info.info_DIN_ch(dd).native_channel_name == fileinfo.name(7:12)
            disp(fileinfo.name(7:12))
            
            if info.info_DIN_ch(dd).custom_channel_name(end-4:end) ==   'Trial'     %Evt_TrigTrial
                evt_trial = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'oStim'       %Evt_OptoStim
                evt_opto = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'Delay'   %Evt_Delay
                evt_delay = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'ory_L'   %Evt_Sensory_L
                evt_puff_L = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'ory_R'   %Evt_Sensory_R
                evt_puff_R = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'Rwd_L'  %Evt_Rwd_L
                evt_rwd_L = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'Rwd_R'  %Evt_Rwd_R
                evt_rwd_R = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'ick_L'  %Evt_Lick_L
                evt_lick_L = fread(fid, num_samples, 'uint16');
                
            elseif info.info_DIN_ch(dd).custom_channel_name(end-4:end) == 'ick_R'  %Evt_Lick_R
                evt_lick_R = fread(fid, num_samples, 'uint16');
                
            end
            
            fclose(fid);
            
        else
            disp('ERROR NON MATCHING CHANNELS')
            STOP
        end
    end
    
    save('evt.mat','evt_trial', 'evt_opto', 'evt_delay', 'evt_puff_L', 'evt_puff_R', 'evt_rwd_L', 'evt_rwd_R', 'evt_lick_L', 'evt_lick_R')
end