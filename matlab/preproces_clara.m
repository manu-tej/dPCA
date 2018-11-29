all_trials = length(trail_type);
[a,b]=hist(trial_type,trail_types);
min_trials = min(a);
trial_types = b;
couter = containers.Map
for i in 1:length(trail_types)
    counter(trail_types(i,:)) = 0;
spike_size = length(spiketimes);
x = -1000:1000;
gaussKernel = 1/sqrt(2*pi)/50 * exp(-x.^2/50^2/2);
psth_trial = zeros(min_trials,4000)
marker = 1
for i = 1:all_trials
    current_trail_type = trail_type(i,:);
    start = odor_onsets(i,:);
    stop = start + 4000;
    spiketrain = zeros(1,4000);
    for j in marker:spike_size
        if spiketimes(j,:) >= start || spiketimes(j,:) <= stop
            spiketrain(spiketimes(j,:),:) = 1;
        elseif spiketimes(j,:) > stop
            marker = j;
            break
   psth = conv(spiketrain, gaussKernel, 'same');
   if 
   psth_trial(1,:) = psth;
   
   
    
