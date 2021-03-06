# Calcula el volumen de una n-esfera
# usando método MC y QMC(Lattice Rule)
# INPUTS
# dim : dimensión del espacio
# R : radio de la esferea
# nuestramax : Numero de muestras
# Formula exacta Vn= pi^n/2 * R^n / gamma(n/2+1)

# Dimension del problema
dim=4; 
# Radio
R=1; 
muestramax=500
# parametro para el vector generador z de QMC
param=115; 

#Reserva de memoria
volumen_estimado=eye(muestramax,1);
errores_mc=eye(muestramax,1);

### Estimacion mediante MC
elapse_time=0;
t0=clock();
num_puntos_dentro_esfera=0;
for i=1:muestramax
	punto_aleat=f_hipercubo_punto_aleatorio(dim,R);
	if(f_hiperesfera_dentro_radio(R,punto_aleat)==true);
	  num_puntos_dentro_esfera+=1; 
	endif
	est_vol_mc(i)=(num_puntos_dentro_esfera/i)*R*power(2,dim);;
endfor
elapse_time=etime(clock(),t0)
volumen_estimado_mc=est_vol_mc(muestramax)

### Estimacion mediante QMC(Lattice Rule)

numpuntos=muestramax;

vol_qmc_lr=eye(numpuntos,1);

t1=clock();
glp=f_glp_ndim(numpuntos,dim-1,param);

suma=0;
for k=1:numpuntos

  vector_glp=glp(k,:);

  normv=norm(vector_glp)*norm(vector_glp);
  if(normv>1)
	 result=0;
  else
	 result=sqrt(R*R-normv);
  endif
 
  suma+=result;
  vol_qmc_lr(k)=power(2,dim)*suma/k;

endfor
volumen_qmc_lattice_rule=vol_qmc_lr(numpuntos)


#Volumen exacto teorico
volumen_teorico=f_hiperesfera_volumen(dim,R)

#Graficando el resultado
#subplot(1,1,1);
plot(est_vol_mc(10:muestramax),'r',vol_qmc_lr(10:muestramax),'b');



