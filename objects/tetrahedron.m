% [obj] = tetrahedron(p_sphere)
%
% Input:
% p_sphere = struct with the following fields
%		R 	= radius (meters)
%		Ne	= Number of edges = 12 x 4^n, n integer
%
% Output: see object.m
%
% Juan M. Rius, Josep Parron June 1999


function [obj] = tetrahedron(p_sphere)

obj = struct('vertex',[],'topol',[],'trian',[],'edges',[],'un',[],'ds',[],'ln',[],'cent',[],'feed',[],'Ng',0);
R  = p_sphere.R;
Ne = p_sphere.Ne;

n = log(Ne/12)/log(4);
%view_var('n',n);
%view_var('Mesh size',2*pi*R/(4*2^n));
if floor(n)~=n, error('Ne must be = 12 x 4^n, n integer'); end

obj.vertex = R * [  0  1  0 -1  0  0; % Cartesian coordinates of obj.vertex
              		0  0  1  0 -1  0;
                	1  0  0  0  0 -1];

obj.topol = [   1 1 1 1 6 6 6 6;
                3 4 5 2 2 3 4 5;
				2 3 4 5 3 4 5 2];

Nt = 8; Nv = 6;
for it = 1:n			% Divide by 2 mesh size
for t = 1:Nt			% For each triangle
	v1 = obj.topol(1,t); v2 = obj.topol(2,t); v3 = obj.topol(3,t);
	r12 = (obj.vertex(:,v1) + obj.vertex(:,v2))/2;
	r23 = (obj.vertex(:,v2) + obj.vertex(:,v3))/2;
	r31 = (obj.vertex(:,v3) + obj.vertex(:,v1))/2;

	% Check if new obj.vertex already exists
	e12 = find(all([r12(1)==obj.vertex(1,:); r12(2)==obj.vertex(2,:); r12(3)==obj.vertex(3,:)]));
	e23 = find(all([r23(1)==obj.vertex(1,:); r23(2)==obj.vertex(2,:); r23(3)==obj.vertex(3,:)]));
	e31 = find(all([r31(1)==obj.vertex(1,:); r31(2)==obj.vertex(2,:); r31(3)==obj.vertex(3,:)]));
	if e12, v12 = e12; else v12 = Nv+1; Nv = Nv+1; obj.vertex = [obj.vertex r12]; end %#ok<*SEPEX>
	if e23, v23 = e23; else v23 = Nv+1; Nv = Nv+1; obj.vertex = [obj.vertex r23]; end
	if e31, v31 = e31; else v31 = Nv+1; Nv = Nv+1; obj.vertex = [obj.vertex r31]; end

	obj.topol(:,t) = [v12; v23; v31]; % Replace current triangle
	obj.topol = [obj.topol [v2; v23; v12] [v23; v3; v31] [v31; v1; v12]];
	end
	Nt = Nt*4;
end

