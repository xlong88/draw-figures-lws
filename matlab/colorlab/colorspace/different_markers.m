function [ output_args ] = different_markers( input_args )
%DIFFERENT_MARKERS Summary of this function goes here
%   Detailed explanation goes here
                      % 1    2    3    4    5    6    7    8    9   10   11
    output_args_cad = ['<', 'o', '+', 'X', '^', 'v', 'p', 'd', 's', 'h', '*'];
    if input_args > length(output_args_cad)
        error('Exceeds the maximum number of markers we can provide');
    end
    output_args = output_args_cad;
    

end

