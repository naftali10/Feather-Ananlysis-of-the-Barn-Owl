function[angle,lngth]=square_identify(Im,x,y)
%input: Image, and sun center coordinates
%output: length of the card in pixels, and its angle relatively to x axis
    Im=(double(rgb2gray(Im))-128)/256;                                     %normalizing the image into the boundries [-0.5,0.5]
    load param.mat;
    %% creating the correlation kernels
    [ImH,ImW]=size(Im);
    N=round(0.5*sqrt(0.0311*ImH*ImW*param.card))*10;                       %estimated sequence length
    M=30;                                                                  %number of uniformly-distributed scanning angles
    K=5;                                                                   %the number of finer sampling angles
    P=20;                                                                  %number of rough kernel lengths
    Q=5;                                                                   %number of fine kernel lengths
    n=round(linspace(N/4,N*1.5,P));                                           %kernels lngths
    seqs_max=max(n);                                                       %longest sequence size
    seqs_num=numel(n);
    seq=zeros(seqs_num,seqs_max);                                          %initializing the kernels matrix
    for i=1:seqs_num
        seq(i,1:n(i))=square_seq_vec(n(i));
    end
    %% sampling the sun's surroundings
    Im_pad=padarray(Im,[seqs_max,seqs_max]);                               %padded for outer-image angular scans
    for k=1:M
        theta=2*pi*k/M;
        smp_co(1,:)=round(linspace(x,x+seqs_max*cos(theta),seqs_max))+seqs_max; %horizontal sampling coordinates;   the addition of seqs_max is because of the zero-padding
        smp_co(2,:)=round(linspace(y,y-seqs_max*sin(theta),seqs_max))+seqs_max; %vertical sampling coordinates
        for i=1:seqs_max
            X(k,i)=Im_pad(smp_co(2,i),smp_co(1,i));                        %each row is an angular scan in length of seqs_max
        end
    end
    %% finding the best-fitting squence
    for i=1:seqs_num
        for k=1:M
            cor(i,k)=sum(seq(i,:).*X(k,:))/n(i);                           %each row is a kernel's correlation with all the angular scans
        end
    end
    [max_corrs,max_seqs]=max(cor);
    [max_corr,max_angl]=max(max_corrs);
    max_seq=max_seqs(max_corrs==max_corr);
    max_angl=max_angl(1)/M*360;                                            %converting the angle to degrees
    max_corr=max_corr(1); max_seq=max_seq(1);                              %solving a multiple maximum case
    %% creating finer kernel sizes
    n=round(linspace(n(max_seq)-(N*3-N/3)/(P-1)/2,n(max_seq)+(N*3-N/3)/(P-1)/2,Q)); %fine kernel lenghts
    seqs_max_fine=max(n);                                                  %longest sequence size
    seqs_num=numel(n);
    seq=zeros(seqs_num,max(n));                                            %initializing the kernels matrix
    for i=1:seqs_num
        seq(i,1:n(i))=square_seq_vec(n(i));                                %building the new kernels (each row)
    end
    %% finer sampling of the sun's surroundings
    clear smp_co;
    close_angles=max_angl+0.5*linspace(-360/M,360/M,K);                    %max_angle's surrounding of half way to each neighbouring main angle
    for k=1:K
        theta=close_angles(k)/180*pi;                                       %theta should be in radians
        smp_co(1,:)=round(linspace(x,x+seqs_max_fine*cos(theta),seqs_max_fine))+seqs_max; %horizontal sampling coordinates;   the addition of seqs_max is because of the zero-padding
        smp_co(2,:)=round(linspace(y,y-seqs_max_fine*sin(theta),seqs_max_fine))+seqs_max; %vertical sampling coordinates
        for i=1:seqs_max_fine
            X_fine(k,i)=Im_pad(smp_co(2,i),smp_co(1,i));                   %each row is an angular scan in lngth of seqs_max_fine
        end
    end
    %% finding the best-fitting fine squence
    for i=1:seqs_num
        for k=1:K
            cor_fine(i,k)=sum(seq(i,:).*X_fine(k,:))/n(i);                 %each row is a kernel's correlation with all the angular scans
        end
    end
    [max_corrs,max_seqs]=max(cor_fine);
    [max_corr,max_angl_fine]=max(max_corrs);
    max_seq=max_seqs(max_corrs==max_corr);
    max_corr=max_corr(1); max_seq=max_seq(1);                              %solving a multiple-maximum case
    
    angle=close_angles(max_angl_fine(1));
    lngth=round(n(max_seq)/0.878);
    
end