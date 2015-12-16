function filter_data
%calls filter_function
sessions = 5
subjects = [3];
mask='/Volumes/Aidas_HDD/MRI_data/S3/Analysis/mask.nii'; %whole brain mask
%base='/Volumes/Aidas_HDD/MRI_data/' 
base = '/Volumes/Aidas_HDD/MRI_data/'
file_prefix = 'swrad'
for sub=subjects
 for session = 1 : sessions
    %sub=int2str(sub);
    disp(['loading subject ' int2str(sub) ' sesssion ' int2str(session) ' data'])
    
    %base='/Volumes/Aidas_HDD/MRI_data/'
    %input_path=[base 'S' sub '/functional' '/sess4/']
    input_path=[base 'S' int2str(sub) '/functional' '/sess' num2str(session) '/']
    %list=dir([input_path 'sm6*.nii']); %which files to take i
    list=dir([input_path [file_prefix '*.nii']]);
    
    
    file=[input_path list(1).name];
    data=cosmo_fmri_dataset(file, 'mask', mask, 'targets', randi(3), 'chunks', randi(3));
    
    for epi=2:length(list)
        file=[input_path list(epi).name];
        fmri=cosmo_fmri_dataset(file, 'mask', mask, 'targets', randi(3), 'chunks', randi(3));
        data=cosmo_stack({data fmri}); 
    end
    
    disp(['filtering sub ' int2str(sub) ' sesssion ' int2str(session)])
    data.samples=filter_function(data.samples); %Call the other function    
    output_path=input_path;
    output=['f50hz_' list(1).name];%output_fn=fullfile(output_path, output);
    output_fn=fullfile(output_path, output); %
    cosmo_map2fmri(data,output_fn);
 end
end
disp('done')