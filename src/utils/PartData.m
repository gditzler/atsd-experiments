function [ ] = PartData( randseed, percent_train, filenames, optional_postfix )
%function [ ] = PartData( randseed, percent_train, filenames, optional_postfix )
%
%This function randomly partitions each set of data described by
%'filenames' into a training set and a test set. It does this by creating
%new files named after those in filenames appended with 'test' and 'train'.
%Currently, this file assumes any file extensions are 3 characters, but
%thats an easy fix if need be.
%
% randseed = an integer random seed used to randomly shuffle the data
%
% percent_train = a real number between 0 and 1 designating the fraction to
%   use as training/probe data and the complement as the test data
%
% filenames = a cell array of files containing all the data
%
% optional_postfix = a string to append after 'test' and 'train'. By
%   default, this is .csv
%
%Note, while this function uses a random number generator, it does not
%modify the global random number generator. It uses a local random number
%generator only.

%Error checking to keep us from accidently using this incorrectly
if(nargin < 4)
    optional_postfix = '.csv';
end
if(nargin < 3)
    error('PartData requires a random seed, a percent that should be training data, and a cell array of file names');
end
if( max(size(randseed)) ~= 1)
    error('The random seed must be a single non-negative integer. If the value is not an integer, it will be rounded to the nearest integer');
end
if( or(percent_train < 0.0, percent_train > 1.0))
    error('The percent to train must be a real number between 0.0 and 1.0 inclusive');
end
if( ~iscell(filenames))
    error('The filenames are not specified as a cell array. Please use {} when specifying the array of file names');
end

%Backup current random number generator
backup_rng = rng;

%Overwrite the random number generator (defaults to Mersenne Twister)
rng(round(abs(randseed)));
rand(625,1); %ensure the Mersenne Twister is fully initialized

for i=1:length(filenames)
    %Load the data and split
    if( strcmp(filenames{i}(end-3), '.') )
        clean_fn = filenames{i}(1:end-4);
        full_fn = filenames{i};
    else
        clean_fn = filenames{i};
        full_fn = [filenames{i} '.csv'];
    end
    data = load(full_fn);
    
    %Shuffle the data and labels
    num_data = size(data, 1);
    for j=1:100 %I know I'm being paranoid shuffling it 100 times
        P = randperm(num_data);
        data = data(P, :);
    end
    
    %Split
    %training data = 1:train_end_index
    %test data = (train_end_index+1):num_data
    train_end_index = 1 + round( (num_data-2) * percent_train); %+1 ... -2 adjusts so that 0% train --> index 1, 100% train --> end-1.
                                                                %This ensures as long as there are at least two data points, one goes 
                                                                %into training and the other goes into test. Why else would you call this? 
    test_start_index = train_end_index+1;
    
    %Write the csv files
    test_name = [clean_fn '_test' optional_postfix];
    train_name = [clean_fn '_train' optional_postfix];
    csvwrite(train_name, data(1:train_end_index, :));
    csvwrite(test_name, data(test_start_index:end, :));
end

%Restore backed up random number generator
rng(backup_rng);

end

