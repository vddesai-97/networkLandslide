function [CA] = multilayerCommDet(edgemat, tsteps, gamma, omega)

%Create a multilayer matrix
edgemat = readmatrix(strcat('DM', num2str(n), '.csv'), 'NumHeaderLines',1);
sz = max(max(edgemat(:, 1:2)));
for t = 1:tsteps
     A{t} = sparse(edgemat(:, 1), edgemat(:, 2), edgemat(:, 2+t), sz, sz);
end


%Parameters and Information
NC=length(A{1});
TC=length(A);
B=sparse(NC*TC,NC*TC,NC*NC*TC+2*NC*TC);
% %global avera


%%%%%%%%%%%%%%%%% geographic null model %%%%%%%%%%%%%%
for s=1:TC
    indx=[1:NC]+(s-1)*NC;
    % extract the binary contact network
    Adjacency= A{s};
    Binary = zeros(size(Adjacency));
    Binary(Adjacency~=0) = 1;
    % follow Papadopoulos et al. 2016 and normalize by the mean weight
    average = mean2(Adjacency(Adjacency~=0));
    Astar = Adjacency./average;
    % add this layer into B
    B(indx,indx) =(Astar - gamma.*Binary);
end

        
D = D + omega*spdiags(ones(NC*TC,2),[-NC,NC],NC*TC,NC*TC);
[S,Q] = genlouvain(D);
CA = reshape(S,NC,TC); 


end



