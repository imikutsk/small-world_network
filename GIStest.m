clear;
n=400;	% liczba wierzcholkow
d=40; 	% stopien wierzcholkow (poczatkowy)
p=0;	%prawdopodobienstwo przelaczenia

test=0;
test_wspgr=zeros(2,21);
wsprg_teor=zeros(2,21);
p=10.^(-3:0.15:0);
it=1;

while it<=length(p)
	test=test+1;
	M=diag(0);
	for u = 1:d/2 	% macierz sasiedstwa
	M = M + diag(ones(n-u,1),u)+diag(ones(u,1),n-u);
	end
	M=M+M'; 

	for numokr=1:d/2		% numokr - numer okrazenia
	l=1; 
	tmp=numokr-1;
			for i=1:n
				ind1=0;		% indeks jedynki, ktora bedziemy poddawac analizie
				% wybor wezla do analizy
				if i==(n-tmp) % tutaj robimy tak, aby na 1-m okrazeniu scprawdzany byl pierwszy najblizszzy sasiad, na 2-m - drugi i td.
				ind1=numokr-tmp;  
				tmp=tmp-1;
				else 
					ind1=i+numokr;
				end
				
				random=rand;	% generowanie wartosci losowej
				if random<=p(it) 	% jesli wartosc jest miejsza albo rowna wspolczynniku grupowania, to krawedz jest przepinana
					% tworzona tablica z indeksami wierzcholkow, do ktorych moze byc przelaczona krawedz
					ind=1;
					zer=zeros(1,n);	
					for j=1:n				
						if (i ~= j && M(i,j)==0)
							zer(ind)=zer(ind)+j; 
							ind=ind+1; 
						end 
					end
					
					% losowo wybieramy wierzcholek, do ktorej bedzie przepieta krawedz
					nul = find(zer==0);	
					ind0random = randi(length(zer)-length(nul)); 
					ind0=zer(ind0random);

					% przepinanie krawedzi
					M(i,ind0)=1;
					M(ind0,i)=1;
					M(i,ind1)=0;
					M(ind1,i)=0;
				end
			end
	end		

	% rozklad stopni wierzcholkow wynik w macierzy
	stopnie=zeros(1,n);
	for i=1:n
		stopnie(i) = length(find(M(i,:)==1));
	end

	mini=min(stopnie);	%minimalny stopien wierzcholka
	maxi=max(stopnie);	%maksymalny stopien wierzcholka

	rstopni=zeros(2,maxi);
	ilosc=0;
	for stopien=mini:maxi
		for i=1:n
			if stopnie(i)==stopien
				ilosc=ilosc+1;
			end
			rstopni(1,stopien)=stopien;
			rstopni(2,stopien)=ilosc;
		end
		ilosc=0;
	end

	% wspulczynnik grupowania
	wspgr=zeros(1,n);
	for i=1:n
		ci=0;
		e=0;
		for j=1:n
			if M(i,j)==1 
				for j1=(j+1):n
					if M(i,j1)==1 && M(j,j1)==1
						e=e+1;
					end
				end
			end
		end
		ci=(2*e)/(d*(d-1));
		wspgr(i)=ci;
	end

	ws=0;
	for i=1:n
		ws=ws+wspgr(i);
	end
	wsgrs=ws/n;		% wspolczynnik grupowania calej sieci
    test_wspgr(1,test)=p(it);
	test_wspgr(2,test)=wsgrs;
    
    % teoretyczny wspgr
    wsprgteor=((3*(d/2-1))/(2*((2*d/2)-1)))*(1-p(it))^3;
    wsprg_teor(1,test)=p(it);
    wsprg_teor(2,test)=wsprgteor;
    
    p(it)
    it=it+1;

end

    figure(test+1);
	plot(test_wspgr(1,:), test_wspgr(2,:),'bo', ...
        wsprg_teor(1,:), wsprg_teor(2,:), 'ro');
    grid on;
    title(['Rozklad wspolczynnika grupowania dla \it n= ',num2str(n), ', d= ',num2str(d)]);
    xlabel('p');
	ylabel('Wspolczynnik grupowania');
	legend('otrzymany','oczekiwany');
    figure(test+2);
    semilogx(test_wspgr(1,:), test_wspgr(2,:),'bo', ...
        wsprg_teor(1,:), wsprg_teor(2,:), 'ro');
    grid on;
    title(['Rozklad wspolczynnika grupowania dla \it n= ',num2str(n), ', d= ',num2str(d)]);
    xlabel('p');
	ylabel('Wspolczynnik grupowania');
	legend('otrzymany','oczekiwany');

