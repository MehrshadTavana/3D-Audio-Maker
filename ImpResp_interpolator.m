%% Functions

function [Left_ImpResp , Right_ImpResp]  = ImpResp_interpolator(SourcePosition , recording1 , recording2)

innerproducts1      = zeros(recording1.number_of_angles  ,  1);
t_recording1 = 1 : recording1.number_of_angles;

innerproducts1(t_recording1) = (sin(SourcePosition.azimuth.*pi/180).*sin(recording1.azimuth_degree(t_recording1).*pi/180).*(cos((pi/180).*((90-SourcePosition.elevation) - ...
(90-recording1.elevation_degree(t_recording1)))))) + cos((SourcePosition.azimuth - recording1.azimuth_degree(t_recording1)).*pi/180);

innerproducts2      = zeros(recording2.number_of_angles  ,  1);
t_recording2 = 1 : recording2.number_of_angles;

innerproducts2(t_recording2) = (sin(SourcePosition.azimuth.*pi/180).*sin(recording2.azimuth_degree(t_recording2).*pi/180).*(cos((pi/180).*((90-SourcePosition.elevation) - ...
(90-recording2.elevation_degree(t_recording2)))))) + cos((SourcePosition.azimuth - recording2.azimuth_degree(t_recording2)).*pi/180);




ind1                = (innerproducts1 >= 0.9);
ind2                = (innerproducts2 >= 0.9);



Left_ImpResp1       = recording1.ImpResp_LeftEar(: , ind1) * (innerproducts1(ind1).^2);
Left_ImpResp1       = Left_ImpResp1 / sum(innerproducts1(ind1).^2);
% Left ear with range 2
Left_ImpResp2       = recording2.ImpResp_LeftEar(: , ind2) * (innerproducts2(ind2).^2);
Left_ImpResp2       = Left_ImpResp2 / sum(innerproducts2(ind2).^2);
% combining the two ranges
Left_ImpResp        = ( (recording2.range_cm - SourcePosition.range) * Left_ImpResp1 + ...
                        (SourcePosition.range - recording1.range_cm) * Left_ImpResp2 ) / ...
                        (recording2.range_cm - recording1.range_cm);


Right_ImpResp1      = recording1.ImpResp_RightEar(: , ind1) * (innerproducts1(ind1).^2);
Right_ImpResp1      = Right_ImpResp1 / sum(innerproducts1(ind1).^2);

Right_ImpResp2      = recording2.ImpResp_RightEar(: , ind2) * (innerproducts2(ind2).^2);
Right_ImpResp2      = Right_ImpResp2 / sum(innerproducts2(ind2).^2);

Right_ImpResp       = ( (recording2.range_cm - SourcePosition.range) * Right_ImpResp1 + ...
                        (SourcePosition.range - recording1.range_cm) * Right_ImpResp2 ) / ...
                        (recording2.range_cm - recording1.range_cm);
