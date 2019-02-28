clc;
clear all;
%% initialized the nodes as 3d array
all_nodes=[];
%% initialised Parent node and node number and nodeinfo
global parent_node_number;
global node_number;
parent_node_number = 0;
node_number = 2;
node_Info(1,:)=[1,0];
%% Ask the user for initial state
%nodes_init=[0 1 3;4 2 5;7 8 6];
prompt='enter the initial state matrix: '
nodes_init=input(prompt);
s=is_it_solvable(nodes_init)
 

%% goal state
nodes_goal=[1 2 3; 4 5 6; 7 8 0];
%% saving the initial node to node matrix
all_nodes(:,:,1)= nodes_init;

%% main code where functions are called and the nodes are found and lists updated
current_node=[];
current_node(:,:,1)=nodes_init;
if s==1
 while goalcheck(current_node,nodes_goal,node_Info,all_nodes)==0
    children_node= [];
    for i=1:size(current_node,3)
    parent_node_number = parent_node_number+1;
    [status,newnode]=actionmoveright(current_node(:,:,i));
    if status==1
    [flag,all_nodes,node_Info]=addnode(newnode,all_nodes,parent_node_number,node_number,node_Info);
    if flag==true
       children_node = cat(3,children_node,newnode);
       node_number = node_number+1;
    end
    end
    [status,newnode]=actionmoveleft(current_node(:,:,i));
    if status==1
    [flag,all_nodes,node_Info]= addnode(newnode,all_nodes,parent_node_number,node_number,node_Info);
    
    if flag==true
       children_node = cat(3,children_node,newnode); 
       node_number = node_number+1;
    end
    end
    [status,newnode]=actionmoveup(current_node(:,:,i));
    if status==1
    [flag,all_nodes,node_Info]=addnode(newnode,all_nodes,parent_node_number,node_number,node_Info);
    if flag==true
       children_node = cat(3,children_node,newnode);
       node_number = node_number+1;
    end
    end
    [status,newnode]=actionmovedown(current_node(:,:,i));
    if status==1
    [flag,all_nodes,node_Info]=addnode(newnode,all_nodes,parent_node_number,node_number,node_Info);
    if flag==true
       children_node = cat(3,children_node,newnode);
       node_number = node_number+1;
    end
    end
   end
    current_node = children_node;
 end
else
    disp('please enter correct node')
end
if s==1
[u,moves]=goalcheck(current_node,nodes_goal,node_Info,all_nodes);
nodePath=cat(3,moves,nodes_goal)
end
%% writing to text file
fileID= fopen('allnodes.txt','w');
if s==1
len=size(all_nodes,3);
for k=1:len
    fprintf(fileID,'%i %i %i %i %i %i %i %i %i \n',reshape(all_nodes(:,:,k),[9,size(all_nodes(:,:,k),3)])');
end
else
    fprintf(fileID,' ');
end
fclose(fileID);

fileID= fopen('nodePath.txt','w');
if s==1
len=size(nodePath,3);
for k=1:len
    fprintf(fileID,'%i %i %i %i %i %i %i %i %i \n',reshape(nodePath(:,:,k),[9,size(nodePath(:,:,k),3)])');
end
else
    fprintf(fileID,' ');
end
fclose(fileID);

fileID= fopen('node_Info.txt','w');
if s==1
len=size(node_Info,1);
for k=1:len
    fprintf(fileID,'%i %i \n',(node_Info(k,:)));
end
else
    fprintf(fileID,' ')
end
fclose(fileID);

%% for visualisation uncomment this
plotOutput( nodePath )

%% function to check solvability of the given input node
function [count] = number_of_inversions(nodes_init)
count=0;
% write the given array in linear form
node_init=cat(2,nodes_init(1,:),nodes_init(2,:),nodes_init(3,:))
for i=1:8
    for j=i+1:9
        if (node_init(i)>0&&node_init(j)>0&&node_init(i)>node_init(1,j))
        count=count+1;
        end
    end
end
        
end

function [solve] = is_it_solvable(nodes_init)
count=number_of_inversions(nodes_init);
if rem(count,2)==0
    disp('solvable')
    solve=1;
else
    disp('not solvable')
    solve=0;
end
end
%% function for finding blanktile location
function [x0,y0] = blanktile_location(currentnode)
i= currentnode==0;
[x0,y0]= find(i);
end
%% function for moving blanktile to right
function [status,newnode]= actionmoveright(currentnode)
[x,y]= blanktile_location(currentnode);
% x have same value y becomes y-1
if (y~=3)
    temp=currentnode(x,y);
    currentnode(x,y)=currentnode(x,y+1);
    currentnode(x,y+1)=temp;
    newnode = currentnode;
    status=1;
else
    newnode=[];
    status=0;
end
end
%% function to move left
function [status,newnode]= actionmoveleft(currentnode)
[x,y]= blanktile_location(currentnode);
% x have same value y becomes y+1
if (y~=1)
    temp1=currentnode(x,y);
    currentnode(x,y)=currentnode(x,y-1);
    currentnode(x,y-1)=temp1;
    newnode = currentnode;
    status= 1;
else
    newnode=[];
    status= 0;
end
end
%% function to move top
function [status,newnode]= actionmoveup(currentnode)
[x,y]= blanktile_location(currentnode);
% y have same value x becomes x-1
if (x~=1)
    temp2=currentnode(x,y);
    currentnode(x,y)=currentnode(x-1,y);
    currentnode(x-1,y)=temp2;
    newnode = currentnode;
    status= 1;
else 
    newnode=[];
    status= 0;
end
end
%% function to move down
function [status,newnode]= actionmovedown(currentnode)
[x,y]= blanktile_location(currentnode);
% y have same value x becomes x+1
if (x~=3)
    temp3=currentnode(x,y);
    currentnode(x,y)=currentnode(x+1,y);
    currentnode(x+1,y)=temp3;
    newnode = currentnode;
    status= 1;
else
    newnode=[];
    status= 0;
end
end
%% function to check wether node is new or not
function [flag,all_nodes,node_Info]= addnode(newnode,all_nodes,parent_node_number,node_number,node_Info)
flag=true;
    for j=1:size(all_nodes,3)
       if isequal(newnode,all_nodes(:,:,j))
           flag=false;
        end
     end
  if (flag)
  all_nodes=cat(3,all_nodes,newnode);
  nodeinfo = [node_number,parent_node_number];
  node_Info=cat(1,node_Info,nodeinfo);
  end
end

%% function for goal checking
function [n,moves] = goalcheck(current_node,nodes_goal,node_Info,all_nodes)

    for i=1:size(current_node,3)
        if isequal(current_node(:,:,i),nodes_goal)==1
            n=1;
            disp("goal reached");
% search for goal node in all_nodes
               b=0;
               for d=1:size(all_nodes,3)
                   if(isequal(all_nodes(:,:,d),nodes_goal))
                    b=d;
                   end
               end
             idx=node_Info(b,2);
             id=[];
             id(1,1)=idx;
% finding path using backtracking
             while(idx~=1)
             temp= node_Info(idx,2);
             id=cat(1,id,temp);
             idx=temp;
             end
             id1=fliplr(id');
             for i=1:size(id1,2)
               moves(:,:,i)=all_nodes(:,:,id1(1,i));
             end
            break
        else 
            n=0;
        end
    end
end
   
    
