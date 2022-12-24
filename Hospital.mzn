% Sarah Cuenca Sanchez

%Parámetros--------------------------------------------------

%----Operaciones y su duracion
int: numOp = 6;
array [1..numOp] of int: duracion = [60, 120, 180, 30, 45, 60];

%----Numero de puestos de trabajo distintos 
int: numTrabajo = 4; 

%----Numero de trabajadores del puesto i -> {cirujanos, anestesistas, enfermeros, técnicos}
array[1..numTrabajo] of int: tr = [3, 3, 5, 5]; 

%----Guardo el numero total de trabajadores que tengo entre todos los puestos
int: trabajadoresTotal= sum(i in 1..numTrabajo) (tr[i]);

%----Numero de trabajadores por operacion como minimo
array[1..numTrabajo] of int: trXop = [1, 1, 2, 2];



%Variables---------------------------------------------------

%----Asignacion de cada trabajador en cada operacion. 1 esta asignado, 0 no lo esta
array[1..numOp, 1..trabajadoresTotal] of var 0..1: asignacion;



%Restricciones-----------------------------------------------

%----Cirujanos por operacion
constraint forall(i in 1..numOp)(sum(j in 1..tr[1])(asignacion[i,j]) >= trXop[1]);

%----Anestesistas por operacion
constraint forall(i in 1..numOp)(sum(j in tr[1]+1..tr[1]+tr[2])(asignacion[i,j]) >= trXop[2]);

%----Enfermeros por operacion
constraint forall(i in 1..numOp) (sum(j in tr[1]+tr[2]+1..tr[1]+tr[2]+tr[3])(asignacion[i,j]) >= trXop[3]);

%----Técnicos por operacion
constraint forall(i in 1..numOp) (sum(j in tr[1]+tr[2]+tr[3]+1..tr[1]+tr[2]+tr[3]+tr[4])(asignacion[i,j]) >= trXop[4]);

%----Maximo de 6 horas (360 minutos) por persona
constraint forall(i in 1..trabajadoresTotal)(sum(j in 1..numOp)(asignacion[j,i]*duracion[j]) <= 360); 

%----Maximo de 3 operaciones por persona
constraint forall(i in 1..trabajadoresTotal)(sum(j in 1..numOp)(asignacion[j,i]) <= 3); 

%----Un cirujano no puede realizar dos operaciones consecutivas
constraint forall(i in 1..tr[1], j in 1..numOp-1)(asignacion[j,i]+asignacion[j+1,i]<=1);

%----Op 1 la realiza C2 o C3 de forma exclusiva al menos
constraint asignacion[1,2]=1 xor asignacion[1,3]=1;

%----Op 2 la realiza C1 o C2 de forma exclusiva al menos
constraint asignacion[2,1]=1 xor asignacion[2,2]=1;

%----Op 3 la realiza C1 o C3 de forma exclusiva al menos
constraint asignacion[3,1]=1 xor asignacion[3,3]=1;

%----Op 4 la realiza al menos dos cirujanos
constraint sum(i in 1..tr[1])(asignacion[4,i])>=2;



%Funcion objetivo--------------------------------------------
solve minimize sum(i in 1..numOp)(asignacion[i,3]*duracion[i]);














