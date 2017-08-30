%(a short test)
p1 = serial('/dev/cu.usbserial-ftEGHNL6','BaudRate',57600);                %the port name depend on the platform
fopen(p1);
%is NV blocking command?
fprintf(p1,'LR%i\n SP%i\n AC%i\n NV%i\n M\n AC%i\n NV%i\n M\n', [415000 2000 10 100 3000 2000]);
fclose(p1);