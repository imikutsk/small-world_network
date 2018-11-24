% Projekt GIS 2017-L Generator sieci malego swiata
% Mikutskaya Iryna

clear
n=16;	% liczba wierzcholkow
d=6; 	% stopien wierzcholkow (poczatkowy)
p=0.5;	%prawdopodobienstwo przelaczenia
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
			if i==(n-tmp) 
			ind1=numokr-tmp;  
			tmp=tmp-1;
			else 
				ind1=i+numokr;
			end
			
			random=rand;	% generowanie wartosci losowej
			if random<=p 	% jesli wartosc jest miejsza albo rowna wspolczynniku grupowania, to krawedz jest przepinana
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

% ================ rozklad stopni wierzcholkow =========
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



% ================== wspulczynnik grupowania =====================
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
wsgrs=ws/n;		% wspolczynnig grupowania calej sieci

% przewidywania teoretyczne wsp. gr.
wsprgteor=((3*(d/2-1))/(2*((2*d/2)-1)))*(1-p)^3;

% ===================== zapis do plikow ======================

%wspolczynnik grupowania
fid=fopen('wspgrup.txt','wt');
fprintf(fid,'Wspolczynniki grupowania wierzcholkow:\n');
fprintf(fid,'%0.4f\n',wspgr);
fprintf(fid,'Wspolczynnik grupowania calej sieci:\n');
fprintf(fid,'%0.4f\n',wsgrs);
fclose(fid);

%rozklad stopni
fid=fopen('rstopni.txt','wt');
fprintf(fid,'Rozklad stopni wierzcholkow:\n');
for i=1:2
	for j=mini:length(rstopni)
			fprintf(fid,'%0.0f',rstopni(i,j));
			fprintf(fid,' ');
	end
	fprintf(fid,'\n');
end
fclose(fid);

% macierz sasiedztwa
fid=fopen('M.csv','wt');
for j=1:n
	fprintf(fid,';');
	fprintf(fid,'%0.0f',j-1);
end
fprintf(fid,'\n');
	
for i=1:n
	fprintf(fid,'%0.0f',i-1);
	fprintf(fid,';');
	for j=1:n
		if j~=n			
			fprintf(fid,'%0.0f',M(i,j));
			fprintf(fid,';');
		else fprintf(fid,'%0.0f',M(i,j)); end
	end
	fprintf(fid,'\n');
end
fclose(fid);
