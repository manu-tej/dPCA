directory = dir('data');

for file = 3:3
    all_files = what(['data/' 'Task 1']);
    psth_trial = NaN(length(all_files.mat)/2,12,2,4000,35);
    trial_num = zeros(length(all_files.mat)/2,12,2);
    sal = 0;
    salb = 0;
    for Neuron = 1:length(all_files.mat)
        
        disp(all_files.mat{Neuron})
       
            
        load (['data/' 'Task 1' '/' all_files.mat{Neuron}])
        
        all_trials = length(trial_type);
%         disp(trial_type)
%         disp(unique(trial_type))
        name_split = strsplit(all_files.mat{Neuron},'_');
        
        if strcmp(name_split{1},'SalB')
            D = 2;
            salb =salb + 1;
            neuron = salb;
        else
            D = 1;
            sal = sal + 1;
            neuron = sal;
        end
            
        [a,b]=hist(trial_type,rmmissing(unique(trial_type)));
        trial_types = b;
        for i = 1:length(trial_types)
            if i <= 11
                trial_num(neuron,b(i),D) = a(1,i);
            else
                trial_num(neuron,12,D) = trial_num(neuron,12,D) + a(1,i);
            end
            
        end
        
        counter = containers.Map;
        for i = 1:length(trial_types)
            if i <= 11
                counter(num2str(trial_types(i,:))) = 0;
            else
                counter('12') =  0;
            end
        end
        spike_size = length(spiketimes);
        x = -1000:1000;
        gaussKernel = 1/sqrt(2*pi)/50 * exp(-x.^2/50^2/2);
        
        marker = 1;
        for i = 1:all_trials
            if isnan(trial_type(i,:))
                continue
            end
            if trial_type(i,:) <= 11
                current_trial_type = trial_type(i,:);
            else
                current_trial_type = 12;
            end
            counter(num2str(current_trial_type)) = counter(num2str(current_trial_type)) + 1 ;
            start = odor_onsets(i,:);
            stop = start + 4000;
            spiketrain = zeros(4000,1);
            for j = marker:spike_size
                if spiketimes(j,:) >= start && spiketimes(j,:) <= stop
                    % disp(int16((spiketimes(j,:)-start)))
                    if int16((spiketimes(j,:)-start)) ~= 0
                        if spiketrain(int16((spiketimes(j,:)-start)),:) ~= 0
                            spiketrain(int16((spiketimes(j,:)-start)),:) = spiketrain(int16((spiketimes(j,:)-start)),:) + 1;
                        else
                            spiketrain(int16((spiketimes(j,:)-start)),:) = 1;
                        end
                    end
                elseif spiketimes(j,:) > stop
                    marker = j;
                    break
                end
            end
            psth = conv(spiketrain, gaussKernel,'same');
            psth_trial(neuron,current_trial_type,D,:,counter(num2str(current_trial_type))) = reshape(psth,[4000,1]);
            
        end
        
        clear odor_onsets reward_onsets spiketimes trial_type
    end
end
% all_trials = length(trial_type);
% [a,b]=hist(trial_type,unique(trial_type));
% min_trials = min(a);
% trial_types = b;
% counter = containers.Map;
% for i = 1:length(trial_types)
%     counter(num2str(trial_types(i,:))) = 0;
% end
% spike_size = length(spiketimes);
% x = -1000:1000;
% gaussKernel = 1/sqrt(2*pi)/50 * exp(-x.^2/50^2/2);
% psth_trial = zeros(length(trial_types),4000,min_trials);
% marker = 1;
% for i = 1:all_trials
%     current_trial_type = trial_type(i,:);
%     counter(num2str(current_trial_type)) = counter(num2str(current_trial_type)) + 1 ;
%     start = odor_onsets(i,:);
%     stop = start + 4000;
%     spiketrain = zeros(4000,1);
%     for j = marker:spike_size
%         if spiketimes(j,:) >= start && spiketimes(j,:) <= stop
%             spiketrain(int16(spiketimes(j,:)-start),:) = 1;
%         elseif spiketimes(j,:) > stop
%             marker = j;
%             break
%         end
%     end
%    psth = conv(spiketrain, gaussKernel);
%    if counter(num2str(current_trial_type)) <= min_trials
%        psth_trial(current_trial_type,:,counter(num2str(current_trial_type))) = reshape(psth,[4000,1]);
%    end
% end
%    
%     
