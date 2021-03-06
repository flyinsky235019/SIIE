%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2019-present, Mahmoud Afifi
% York University, Canada
% Email: mafifi@eecs.yorku.ca - m.3afifi@gmail.com
%
% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree.
% All rights reserved.
%
%%
% Please cite the following work if this program is used:
% Mahmoud Afifi and Michael S. Brown. Sensor Independent Illumination 
% Estimation for DNN Models. In BMVC, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

classdef imdoubleLayer_ < nnet.layer.Layer
    
    properties
        inType
    end
    
    properties (Learnable)
    end
    
    methods
        function layer = imdoubleLayer_(name, inType)
            layer.Name = name;
            layer.inType = inType;
            if strcmp(layer.inType,'uint8') == 0 && ...
                    strcmp(layer.inType,'uint16') == 0
                error('Wrong inType value in imdoubleLayer_');
            end
            layer.Description = "Layer to convert uint8/uint16 images to double";
        end
        
        function Z = predict(layer, X)
            switch layer.inType
                case 'uint8'
                    Z = X./225;
                case 'uint16'
                    Z = X./65535;
            end
            clear X
        end
        
        
        function [dLdX] = backward(layer, X, Z, dLdZ, memory)
            dLdZ(isnan(dLdZ)) = 0;
            switch layer.inType
                case 'uint8'
                    dLdX = repmat(1/255,size(X)) .* dLdZ;
                case 'uint16'
                    dLdX = repmat(1/65535,size(X)) .* dLdZ;
            end
            clear X dLdZ Z
        end
    end
end