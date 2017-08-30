function myresults = CALtotxt(B, filename)

%This function saves matrix B in the txt file called filename
%B = matrix
%filename = string ending with .txt; name of the output file

myresults = fopen(filename, 'a');                                         %wt mode for windows. a append the text to the existing file                                           
myformat = '%+04d\t%04.4f\n';                                              %change the format depending on the matrix B
fprintf(myresults , myformat, B');                                         %transpose of B: fprintf reads the matrix by columns
fclose(myresults);