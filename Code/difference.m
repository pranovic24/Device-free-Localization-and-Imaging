clear all; close all;
clc;
tic

load('empty_10_1_matrix.mat')
load('empty_15_3_matrix.mat')

result = empty_10_1_matrix - empty_15_3_matrix;
% load('F.mat')
% 
% empty = tril(empty_20_matrix, -1);
% people = tril(people_20_matrix, -1);
% 
% empty_reshape = reshape(nonzeros(empty),[],1);
% people_reshape = reshape(nonzeros(people),[],1);
% 
% delta = people_reshape - empty_reshape;



















toc