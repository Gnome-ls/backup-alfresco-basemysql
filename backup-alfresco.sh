#!/bin/bash
#Nombre del backup
back_alfresco="Backup_alfresco"
#Rutas para almacenado del backup de alfresco
Diario="/mnt/nas/Backup_alfesco/diario"
Semanal="/mnt/nas/Backup_alfesco/semanal"
Mensual="/mnt/nas/Backup_alfesco/mensual"
Anual="/mnt/nas/Backup_alfesco/anual"
# Formato de fecha
date=$(date +"%d-%b-%Y")
#ruta de alfresco productivo
ruta_de_alfresco="/mnt/nas/alfresco"
#Establecer permisos de archivo predeterminados
umask 177
#rutas de karina
##!/bin/bash
​
#back_alfresco="Backup_alfresco"
#Diario="/opt/Backup_alfresco/Backup_alfresco_Diario"
#Semanal="/opt/Backup_alfresco/Backup_alfresco_Semanal"
#Mensual="/opt/Backup_alfresco/Backup_alfresco_Mensual"
#Anual="/opt/Backup_alfresco/Backup_alfresco_Anual"
#date=$(date +"%d-%b-%Y")
#ruta_de_alfresco="/opt/alfresco-community"
# Set default file permissions
#Establecer permisos de archivo predeterminados
umask 177

#Creacion de carpeta log
function carpeta_log_diario () {

if [ -d "$Diario/log" ]; then
    echo "Existe"
else 
    cd $Diario
    mkdir log
fi

}

function carpeta_log_semanal () {

if [ -d "$Semanal/log" ]; then
    echo "Existe"
else 
    cd $Semanal
    mkdir log
fi

}

function carpeta_log_mensual () {

if [ -d "$Mensual/log" ]; then
    echo "Existe"
else 
    cd $Mensual
    mkdir log
fi

} 

function carpeta_log_anual () {

if [ -d "$Anual/log" ]; then
    echo "Existe"
else 
    cd $Anual
    mkdir log
fi
}

# Caso 1 diario
case $1 in
        Diario)
	#fecha=$(date +"%A")
	#if [ $fecha != domingo ]; then
	fecha=$(date +"%d")
	if [ $fecha != 01 ]; then 
		   cd $Diario
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Iniciando backup diario $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system se almacenara en Diario con el nombre del backup-fecha
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Path $Diario"    >>alfresco_Backup.log
                   _destino="$Diario/$back_alfresco-$date.zip"
		   _destinobd="$Diario/$back_alfresco-$date.sql"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup $_destino"    >>alfresco_Backup.log
                   zip -r $_destino $ruta_de_alfresco
		   #Dump de la base de datos de alfresco
		   pg_dump --no-owner --dbname=postgresql://alfresco:admin.SEAGED.2017@localhost:5432/alfresco > $_destinobd
		   # Eliminar archivos que tengan mas de 7 dias
                   cd $Diario && find $back_alfresco* -mtime +7 -type f -exec rm {} \;
		   # Llamado de funcion de creacion de carpeta log
     		   carpeta_log_diario;
		   # Generacion de archivo.log
		   touch alfresco_Backup.log
		   # Hacemos un if para preguntar si  existe archivo comprimido para despues mostrar el mensaje en el archivo.log
	           # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
			if [ -f "$Diario/$back_alfresco-$date.zip" ] ; then
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco diario Generada"    >>alfresco_Backup.log
				
			else
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco diario NO Generada"    >>alfresco_Backup.error
			fi
  	else 
		echo  "$(date +'%d-%b-%y  %r '):ALERT: Es 01 del mes y no se hace nada :D "    >>alfresco_Backup.log	
	fi
	
	MaxFileSize=2048
        while true 
        do
            # Obtener el peso en bytes del archivo.log
            file_size=`du -b alfresco_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Diario/alfresco_Backup.log $Diario/log/alfresco_Backup.log.$timestamp 
                    cd $Diario && touch alfresco_Backup.log 
                else
                    break 
                fi
        done
 	;;
	
        Semanal)
	
	fecha=$(date +"%d-%A")
	if [ $fecha != 01-domingo ]; then
        
		   cd $Semanal
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Iniciando backup Semanal $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system se almacenara en Semanal con el nombre del backup-fecha
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Path $Semanal"    >>alfresco_Backup.log
                   _destino="$Semanal/$back_alfresco-$date.zip"
  	           _destinobd="$Semanal/$back_alfresco-$date.sql"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup $_destino"    >>alfresco_Backup.log
                   zip -r $_destino $ruta_de_alfresco
		   #Dump de la base de datos de alfresco
                   pg_dump --no-owner --dbname=postgresql://alfresco:admin.SEAGED.2017@localhost:5432/alfresco > $_destinobd
                   # Eliminar archivos que tengan mas de 30 dias
                   cd $Semanal && find $back_alfresco* -mtime +30 -type f -exec rm {} \;
                   # Llamado de funcion de creacion de carpeta log
       		   carpeta_log_semanal;
		   # Generacion de archivo.log
	           touch alfresco_Backup.log
		   # Hacemos un if para preguntar si  existe archivo comprimido para despues mostrar el mensaje en el archivo.log
	           # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
			if [ -f "$Semanal/$back_alfresco-$date.zip" ] ; then
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco semanal Generada"    >>alfresco_Backup.log
				
			else
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco semanal NO Generada"    >>alfresco_Backup.error
			fi
	else 
		echo  "$(date +'%d-%b-%y  %r '):ALERT: Es Domingo primero del mes y no se hace nada :D " 
	fi
	# Peso maximo del archivo.log
	MaxFileSize=2048
	while true
	do
		# Obtener el peso en bytes del archivo.log
         	file_size=`du -b alfresco_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Semanal/alfresco_Backup.log $Semanal/log/alfresco_Backup.log.$timestamp 
                    cd $Semanal && touch alfresco_Backup.log 
                else
                    break 
                fi
        done
	
 	;;
        Mensual)
	
	#se coloca date d m para obtener el dia y el mes en numero
	fecha=$(date +"%d-%m")
	if [ $fecha != 01-01 ]; then 
	
		   cd $Mensual
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Iniciando backup Mensual $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system se almacenara en Mensual con el nombre del backup-fecha
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Path $Mensual"    >>alfresco_Backup.log
                   _destino="$Mensual/$back_alfresco-$date.zip"
		   _destinobd="$Mensual/$back_alfresco-$date.sql"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup $_destino"    >>alfresco_Backup.log
                   zip -r $_destino $ruta_de_alfresco
		   #Dump de la base de datos de alfresco
                   pg_dump --no-owner --dbname=postgresql://alfresco:admin.SEAGED.2017@localhost:5432/alfresco > $_destinobd
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Mensual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                    # Llamado de funcion de creacion de carpeta log
	           carpeta_log_mensual;
		   # Generacion de archivo.log
	           touch alfresco_Backup.log
        	   # Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
		   # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
			if [ -f "$Mensual/$back_alfresco-$date.zip" ] ; then
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco mensual Generada"    >>alfresco_Backup.log
			else
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco mensual NO Generada"    >>alfresco_Backup.error
			fi
		else 
		echo  "$(date +'%d-%b-%y  %r '):ALERT: Es primero de Enero y no se hace nada :D "   #>>alfresco_Backup.log
		fi
		# Peso maximo del archivo.log
		MaxFileSize=2048
		while true
		do
			# Obtener el peso en bytes del archivo.log
			file_size=`du -b alfresco_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
			# Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log
		        # a la carpeta log añadiendo la variable timestamp
			if [ $file_size -gt $MaxFileSize ]; then
				timestamp=`date +%s`
				mv $Mensual/alfresco_Backup.log $Mensual/log/alfresco_Backup.log.$timestamp 
                    		cd $Mensual && touch alfresco_Backup.log 
			else
                    break 
                fi
        done

	;;
        Anual)
		   cd $Anual
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Iniciando backup Anual $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system se almacenara en Anual con el nombre del backup-fecha
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Path $Anual"    >>alfresco_Backup.log
                   _destino="$Anual/$back_alfresco-$date.zip"
		   _destinobd="$Anual/$back_alfresco-$date.sql"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup $_destino"    >>alfresco_Backup.log
                   zip -r $_destino $ruta_de_alfresco
		   #Dump de la base de datos de alfresco
                   pg_dump --no-owner --dbname=postgresql://alfresco:admin.SEAGED.2017@localhost:5432/alfresco > $_destinobd
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Anual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                   # Llamado de funcion de creacion de carpeta log
	           carpeta_log_anual;
		   # Generacion de archivo.log
	           touch alfresco_Backup.log
		   	# Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
	                # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero

			if [ -f "$Anual/$back_alfresco-$date.zip" ] ; then
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco anual Generada"    >>alfresco_Backup.log
				
			else
				echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de alfresco anual NO Generada"    >>alfresco_Backup.error
			fi
		    # Peso maximo del archivo.log
		    MaxFileSize=2048
		    while true
		    do
			# Obtener el peso en bytes del archivo.log
			file_size=`du -b alfresco_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
		    	# Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log
		    	# a la carpeta log añadiendo la variable timestamp
			if [ $file_size -gt $MaxFileSize ]; then
				timestamp=`date +%s`
				mv $Anual/alfresco_Backup.log $Anual/log/alfresco_Backup.log.$timestamp
                    		cd $Anual && touch alfresco_Backup.log
                	else
                    		break
                	fi
        	done

	;;
esac
