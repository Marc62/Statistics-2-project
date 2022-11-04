function x = tSim(T,rep)
    intervalLength=zeros(rep,1);
    intervalContains=zeros(rep,1);
    loc=1; scale=2; df=4; B=1000; alpha=0.1; bootphat=zeros(B,1); 
%     %true ES
     c01 = tinv(alpha , df); % left tail quantile, for loc-0 scale-1
     truec = loc+scale*c01; % left tail quantile c
     ES01 = -tpdf(c01,df)/tcdf(c01,df) * (df+c01^2)/(df-1);
     trueES = loc+scale*ES01; % true theoretical ES
    for i=1:rep
        data=loc+scale*trnd(df,T,1); DoF = mleT(data,[df loc scale]);
        for b=1:B
            %ind=unidrnd(T,[T,1]);
            %bootsamp=data(ind);
            bootsamp = trnd(DoF(1), T,1) ; 
            VaR=quantile (bootsamp, alpha);
            temp=data(data<=VaR); bootphat(b)=mean(temp);   
        end
        ci=quantile(bootphat ,[alpha/2 1-alpha/2]);
        intervalLength(i)= ci(2) - ci(1);
        intervalContains(i)=(trueES>ci(1)) & (trueES<ci(2));
        bootphat;
    end
    ci
    intervalLength
    mean(intervalContains)
end

