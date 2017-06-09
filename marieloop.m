%marieloop

% clear all
%
%filename = 'I:\marking\MARIElab\Example2.0.mas';
%filename = 'I:\marking\MARIElab\Example2.3-If then.mas';
%filename = 'I:\marking\MARIElab\Example2.7.mas';

if ~exist('filename', 'var')
    [filefile, pathname] = uigetfile('*.mas');
    filename = [pathname filefile ];
end
if ~exist('Prog', 'var')
    fid = fopen(filename);
    Prog = load_marie_prog(fid);%%loads program into memory
    fclose(fid);
end

clear inputs input
ipnuts__
inputs = inputs1;

pick = {1; [2 3]; 4};
%vec = [2 2 2 2];
%shuffl = [1 2 3 4];

%pick = {1; [2 3]; 1};
%vec = [2 2 2 2]; %must be size 4
%shuffl = [1 2 3 ];

%inputs = shufflecell(constructinput(vec,pick), shuffl);
%inputs_ = shufflecell(constructinput([2 2 2 2],pick), [1 4]);
%inputs = inputs_([1:9 18:29]);

%inputs_ = shufflecell(constructinput([2 2 2 2]), [1 2 3]);
%inputs = inputs_(1:17);

%inputs_ = shufflecell(constructinput([2 2 2 2]), [1 2 3]);
%inputs = inputs_(10:17);

%inputs =  {[2 2 2 255]};
%inputs =  {[2 2 2 2]};
%inputs =  {[7 2 2 2]};
%inputs = inputs_sep1;
%inputs = inputs_sep2;
%inputs = inputs_sep3;

%inputs = inputs8;

if 1
   
    for i = 1:length(inputs)
        input(i).input = inputs{i};
        input(i).counter = 1;
    end
    
    for i =1:length(input)
        disp('New prog instance: ')
        [outputs(i), outprog(i)] = marie_sim(Prog, input(i));
    end
end