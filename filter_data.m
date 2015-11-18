function filter_data
%calls filter_function

subjects = [203 205 206 207 208 212 214 219 221 224 225 226 227 228 231 232];
mask='/home/danx/Documents/FAISCO003M2Z/bin5_mask.nii.gz'; %whole brain mask

for sub=subjects
    sub=int2str(sub);
    disp(['loading sub ' sub ' data'])
    
    base='/home/danx/Documents/FAISCO003M2Z/';
    input_path=[base sub '/sess_1/'];
    list=dir([input_path 's4*.nii']);
    
    file=[input_path list(1).name];
    data=cosmo_fmri_dataset(file, 'mask', mask, 'targets', randi(3), 'chunks', randi(3));
    
    for epi=2:length(list)
        file=[input_path list(epi).name];
        fmri=cosmo_fmri_dataset(file, 'mask', mask, 'targets', randi(3), 'chunks', randi(3));
        data=cosmo_stack({data fmri}); 
    end
    
    disp(['filtering sub ' sub])
    data.samples=filter_function(data.samples); % only works if signal processing toolbox is installed
    
    output_path=input_path;
    output=['f50hz_' list(1).name(1:17) '.nii'];
    output_fn=fullfile(output_path, output);
    cosmo_map2fmri(data,output_fn);
        
end