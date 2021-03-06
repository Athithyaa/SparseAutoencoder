%  ����������
%  ------------
% 
%  ���� ���� �������� ���, ������� ������� ������ ������ ��� ��������.
%  ��� ����� ��������� ��� �� ������:
%   sampleIMAGES.m,
%   sparseAutoencoderCost.m
%   computeNumericalGradient.m. 
%  ��� ���������� ������� ��� ������������� ������ ���� ����. 
%
%======================================================================
% ��� 0: ����� ���� �������� ����������, ����������� ������������ ������
% ������� �������. ������ ��� ��������� ��� �������������.
% 
nSamples=10000;

%patchSize=28;
%visibleSize = patchSize*patchSize;   % ���������� ������� ����� 
%hiddenSize = 196;       % ���������� ������� ����� 
%sparsityParam = 0.1;  % �������� ������� ������� ��������� �������� �������� ����.
                     % (���� �������� ��������� � ������ ��������� ������ ��). 
%lambda =3e-3;     % ����������� ���������� ����� ������       
%beta = 3;            % ����������� �������������    

%======================================================================
% ��� 1: ���������� sampleIMAGES
%
%  ����� ���������� sampleIMAGES, ������� display_network ������ ����������
%  ��������� ����� �� 200 ���������� �� ��������������� ������� ������
%patches = loadMNISTImages('t10k-images.idx3-ubyte');

patchSize=10;
patches = sampleIMAGES(patchSize,nSamples);
visibleSize = patchSize*patchSize;   % ���������� ������� ����� 
hiddenSize = 25;       % ���������� ������� ����� 
sparsityParam = 0.01;  % �������� ������� ������� ��������� �������� �������� ����.
lambda =1e-4;     % ����������� ���������� ����� ������     
beta = 3; 

display_network(patches(:,randi(size(patches,2),200,1)),8);

%  ������������� ������� ���������� theta ���������� ����������
theta = initializeParameters(hiddenSize, visibleSize);

%======================================================================
% ��� 2: ���������� sparseAutoencoderCost
%
%  You can implement all of the components (squared error cost, weight decay term,
%  sparsity penalty) in the cost function at once, but it may be easier to do 
%  it step-by-step and run gradient checking (see STEP 3) after each step.  We 
%  suggest implementing the sparseAutoencoderCost function using the following steps:
%
%  (a) Implement forward propagation in your neural network, and implement the 
%      squared error term of the cost function.  Implement backpropagation to 
%      compute the derivatives.   Then (using lambda=beta=0), run Gradient Checking 
%      to verify that the calculations corresponding to the squared error cost 
%      term are correct.
%
%  (b) Add in the weight decay term (in both the cost function and the derivative
%      calculations), then re-run Gradient Checking to verify correctness. 
%
%  (c) Add in the sparsity penalty term, then re-run Gradient Checking to 
%      verify correctness.
%
%  Feel free to change the training settings when debugging your
%  code.  (For example, reducing the training set size or 
%  number of hidden units may make your code run faster; and setting beta 
%  and/or lambda to zero may be helpful for debugging.)  However, in your 
%  final submission of the visualized weights, please use parameters we 
%  gave in Step 0 above.

[cost, grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, lambda, ...
                                     sparsityParam, beta, patches);

%======================================================================
% STEP 3: Gradient Checking
%
% Hint: If you are debugging your code, performing gradient checking on smaller models 
% and smaller training sets (e.g., using only 10 training examples and 1-2 hidden 
% units) may speed things up.

% First, lets make sure your numerical gradient computation is correct for a
% simple function.  After you have implemented computeNumericalGradient.m,
% run the following: 
%checkNumericalGradient();

% Now we can use it to check your cost function and derivative calculations
% for the sparse autoencoder.  

%  numgrad = computeNumericalGradient( @(x) sparseAutoencoderCost(x, visibleSize, ...
%                                                    hiddenSize, lambda, ...
%                                                    sparsityParam, beta, ...
%                                                    patches), theta);

% Use this to visually compare the gradients side by side
 %disp([numgrad grad]); 

% Compare numerically computed gradients with the ones obtained from backpropagation
%diff = norm(numgrad-grad)/norm(numgrad+grad);
%disp(diff); % Should be small. In our implementation, these values are
            % usually less than 1e-9.

            % When you got this working, Congratulations!!! 

%======================================================================
% STEP 4: After verifying that your implementation of
%  sparseAutoencoderCost is correct, You can start training your sparse
%  autoencoder with minFunc (L-BFGS).

%  Randomly initialize the parameters
theta = initializeParameters(hiddenSize, visibleSize);

%  Use minFunc to minimize the function
addpath minFunc/
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter = 1000;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';


[opttheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   visibleSize, hiddenSize, ...
                                   lambda, sparsityParam, ...
                                   beta, patches), ...
                              theta, options);

%======================================================================
% STEP 5: Visualization 

W1 = reshape(opttheta(1:hiddenSize*visibleSize),hiddenSize,visibleSize);
display_network(W1',1); 

print -djpeg weights.jpg   % save the visualization to a file 


