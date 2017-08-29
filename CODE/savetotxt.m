function myresults = savetotxt(B, filename)

%This function saves matrix B in the txt file called filename
%B = matrix
%filename = string ending with .txt; name of the output file

%Output variabels: 
%1.exp.condition; exp.stimulus(2. start.pos, 3. firststop.pos, 4. end.pos); 
%exp.input (5. speed, 6. length, 7. ref.first); exp.resp (8. answer, 9. time)

%myresults = fopen(filename, 'wt');                                          
myresults = fopen(filename, 'a');
%myformat = ...                                                             %change the format depending on the matrix B
%    '%1u\t %+07d\t %+07d\t %4.4f\t %+07d\t %4.4f\t %05d\t %+07d\t %1u\t %1u\t %+07d\t %4.4f\t %+07d\t%4.4f\t';   

myformat = ...                                                             %change the format depending on the matrix B
    '%1u\t %1u\t %+07d\t %+07d\t %4.4f\t %+07d\t %4.4f\t %05d\t %+07d\t %1u\t %1u\t %u\t %4.4f\n';   
fprintf(myresults , myformat, B');                                         %transpose of B: fprintf reads the matrix by columns
fclose(myresults);                                                         