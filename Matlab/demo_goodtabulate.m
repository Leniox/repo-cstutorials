%Do same as matlabs tabulate but do not return a bunch of zeros
function temp=goodtabulate(x);
  if(size(x,2) > 1)
    x = x';
  end
  x=sort(x(~isnan(x))); %All but NaNs;
  f=[0;find(diff(x))];
  obs=x(1+f);
  counts=diff([f;length(x)]);
  N = sum(counts);
  percents = counts./N*100;
  temp = [obs, counts, percents];
 
  if nargout == 0
      temp = num2cell(temp);
      disp('     Value     count    percent');
      disp(temp);
      clear temp
  end
return
