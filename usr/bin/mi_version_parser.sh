#!/bin/bash

#Matias Basso - 26/04/2012

#El propósito de este programa es tomar los datos del archivo -mi_version- del sistema de Actualización y
#procesarlo para luego ser utilizado por la Ventana de Información "Mi Magallanes" de manera que sea entendible por un usuario.

ARCHIVO=/etc/.actualizaciones/mi_version
LINEAS=0
VERSIO_GENERAL=""
VERSION_MG=""
LIENA=""
LINEA_FINAL=""

#Función que dado un numero de versión devuelve el mismo en formato fecha dd/mm/aaaa
function fecha {
	CHAR1=$(echo $1 | cut -c1)
	CHAR2=$(echo $1 | cut -c2)
	CHAR3=$(echo $1 | cut -c3)
	CHAR4=$(echo $1 | cut -c4)
	CHAR5=$(echo $1 | cut -c5)
	CHAR6=$(echo $1 | cut -c6)
	CHAR7=$(echo $1 | cut -c7)
	CHAR8=$(echo $1 | cut -c8)
	echo $CHAR7$CHAR8"/"$CHAR5$CHAR6"/"$CHAR1$CHAR2$CHAR3$CHAR4
}

#Si el archivo existe cuanta las lineas.
if [ -f $ARCHIVO ]
	then
		LINEAS=$(wc -l /etc/.actualizaciones/mi_version | awk {'print $1'})
fi

#Coloca todo el texto en una simple linea
for ((i=1; i<=$LINEAS; i++))
do
	LINEA=$(head -$i $ARCHIVO)
done

#A la linea anteriormente generada se le quita : '[' ']' 'version' '='
#También se coloca todo texto en mayúscula.
LINEA=$(echo $LINEA | sed s/"version"/""/g | sed s/"\["/""/g | sed s/"\]"/""/g | tr [:lower:] [:upper:] | sed s/"\="/""/g)

#El motivo de este bloque es distinguir entre lo que es un Titulo (Nombre del tipo de Actualización) y el Código (Fecha de la Actualización)
#Para cada "bloque" de texto en la variable LINEA realiza lo siguiente:
for i in $(echo $LINEA)
do
	ES_TITULO=false
	#Cuenta la cantidad de caracteres que hay en ese "Bloque" de texto.
	COUNT=$(echo $i | wc -m)
	
	#Iteración para recorrer el "Bloque".
	for ((j=1; j<=($COUNT-1); j++))
	do
		#Selecciona un caracter.
		CHAR=$(echo $i | cut -c$j)
		#Si el caracter no es un numero, identifica al "Bloque" como Titulo y sale de la Iteración. 
		if ! [[ $CHAR =~ [0-9]+$ ]]; then
			ES_TITULO=true
			break
		fi
	done
	
	#Si el "Bloque" no era un Titulo lo modifica con la función -fecha- para darle formato legible y concatena a una Variable Final
	#De lo contrario simplemente concatena el "Bloque".
	if ! ($ES_TITULO); then
#		LINEA_FINAL=$LINEA_FINAL""$(fecha $i)"\n"
		LINEA_FINAL=$LINEA_FINAL""$i"\n"
	else
		LINEA_FINAL=$LINEA_FINAL""$i" : "
	fi
done

#Simplemente muestra el resultado en terminal.
echo $LINEA_FINAL
