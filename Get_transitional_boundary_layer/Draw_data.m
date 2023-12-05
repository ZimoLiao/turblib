clear
close all

x_start=676;
y_start=1;
z_start=801;
x_end=825;
y_end=120;
z_end=920;
x_step=1;
y_step=1;
z_step=1;
filter_width=1;
nx = (x_end-x_start+1)/x_step;
% ny = (y_end-y_start+1)/y_step;
ny = 1;
nz = (z_end-z_start+1)/z_step;
datasize = nx*ny*nz*3;

fid = fopen('tbl_local.t0001y0025');

data = fread(fid,[datasize,1],'float');

fclose(fid);

data = reshape(data,[3,nx,nz]);

imagesc(squeeze(data(1,:,:)));
axis equal tight