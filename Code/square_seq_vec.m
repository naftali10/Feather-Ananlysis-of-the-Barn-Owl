function[a]=square_seq_vec(N)                                              %input: length (integer); output: square sequence kernel, for the function square_indentify
    a=zeros(1,N);
    n1=round(N*0.078);
    n2=round(N*0.131);
    n3=round(N*0.453);
    n4=round(N*0.508);
    n5=round(N*0.83);
    a(1:n1)=0;                                                             %inside the sun
    a(n1+1:n2)=0;                                                          %gray
    a(n2+1:n3)=-0.5;                                                       %black
    a(n3+1:n4)=0;                                                          %gray
    a(n4+1:n5)=0.5;                                                        %white
    a(n5+1:N)=0;                                                           %gray
end