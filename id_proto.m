%% Input file structure
%a numeric csv file with Column structure
%               [id(numeric), latitide, longitude]
%% Input parameter
%filename: char type filename of the input completely numeric csv file.
%threshold: distance threshold determining if two places are connected.
%unit: unit of threshold distance. char 'm' or 'km' are acceptable.
%mode: arrangement mode or combination mode 'a' or 'c' determines whether
%the output contains reversely directed connection relationship.
%% Output
%a numeric csv file with columns 
%      [source id, target id, distance_in_m, directed_or_not(0 or 1)]
%output file name is cooked_old-filename.csv
%% Function body
function id_proto(filename,threshold,unit,mode)
temp_out = zeros(4);%source target distance direction(di:1,un:0)
index = 1;%initialize temp_out index (row number)
if unit == 'km'
    threshold = threshold * 1000; %convert to meter for distance comparison
elseif unit == 'm'
else
    fprinf("only 'm' or 'km' is acceptable");
end
raw = csvread(filename);
distance = id_dist(raw,mode);
size_dist = size(distance);%row column
if mode == 'a'
    for i = 1 : size_dist(1)%iterate input locations
        for j = 1 : size_dist(1)%iterate input locations
            if distance(i,j)~= 0 && distance(i,j) <= threshold%determine connectivity
                temp_out(index,:) = [i,j,distance(i,j),1];%directed network A(*,*) rows
                index = 1+index;
            end
        end
    end
    
elseif mode == 'c'
    for i = 1 : size_dist(1)
        for j = i : size_dist(1)
            if distance(i,j)~= 0 && distance(i,j)<=threshold
                temp_out(index,:) = [i,j,distance(i,j),0];%undirected network C(*,*) rows
                index = 1+index;
            end
        end
    end
else
    fprintf("input mode should be 'a' or 'c'");
end
csvwrite(['cooked_' filename],temp_out);
end