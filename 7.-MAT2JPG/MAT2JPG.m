%%This program is used at the end of the work flow in the Photoelastic
%%Tomography project since the recontructions gives the imkages in a .mat
%%format and in case we need it in jpg this programs helps to conver them.
%%The user just need to change 'name' in line 11 as he wishes that the files 
%%will be named.

for i=0:1:180;
    n=i+1;
    if n<=180
        contourf(allmax(:,:,n))
        filename=['name',num2str(n),'.fig']
        saveas(gcf,filename)
    else
        disp('done')
    end
end