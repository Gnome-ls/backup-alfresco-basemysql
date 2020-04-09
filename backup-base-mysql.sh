#!/bin/bash

# Credenciales de la base de datos productiva
user="root"
password="admin.SEAGED.2017"

# Nombre de la base de datos
db_name="victimas_prod"

#Rutas donde se almacenarán los backups
Diario="/home/usuario/Backups/BD/Diario"
Semanal="/home/usuario/Backups/BD/Semanal"
Mensual="/home/usuario/Backups/BD/Mensual"
Anual="/home/usuario/Backups/BD/Anual"

# Formato de fecha
date=$(date +"%d-%b-%Y")

##### variables locales #####
# Credenciales de la base de datos
#user="root"
#password="Eamm#931122"
# Nombre de la base de datos
#db_name="Solvetic"
# Carpeta de almacenado para backup diarios
#Diario="/home/jccv/Backup/diario"
# Carpeta de almacenado para backup semanales
#Semanal="/home/jccv/Backup/semanal"
# Carpeta de almacenado para backup mensuales
#Mensual="/home/jccv/Backup/mensual"
# Carpeta de almacenado para backup anuales
#Anual="/home/jccv/Backup/anual"


# permisos por default 
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
#  Caso 1 diario
case $1 in
    Diario)
    fecha=$(date +"%d")
    if [ $fecha != 01 ]; then  
        echo "Iniciando backup Diario $db_name"
        # Dump de base de datos en archivo SQL, se almacenara en Diario con el nombre de la base-fecha
        mysqldump --user=$user -p --password=$password $db_name >$Diario/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 7 dias
        cd $Diario && find $db_name* -mtime +7 -type f -exec rm {} \; 
        # Llamado de funcion de creacion de carpeta log
        carpeta_log_diario;
        # Generacion de archivo.log
        cd $Diario && touch DB_Backup.log  
        # Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
        # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base diaria Generada"    >>DB_Backup.log
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base diaria NO Generada"    >>DB_Backup.error
        fi 
    else 
        echo  "$(date +'%d-%b-%y  %r '):ALERT: Es 01 del mes y no se hace nada :D "    #>>DB_Backup.log    
    fi
    # Peso maximo del archivo.log
    MaxFileSize=2048
        while true
        do
            # Obtener el peso en bytes del archivo.log
            file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Diario/DB_Backup.log $Diario/log/DB_Backup.log.$timestamp 
                    cd $Diario && touch DB_Backup.log 
                else
                    break 
                fi
        done
    ;;
    Semanal)
	fecha=$(date +"%d-%A")
	if [ $fecha != 01-domingo ]; then 
        echo "Iniciando backup Semanal $db_name"
        # Dump de base de datos en archivo SQL, se almacenara en Diario con el nombre de la base-fecha
        mysqldump --user=$user -p --password=$password $db_name >$Semanal/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 7 dias
        cd $Semanal && find $db_name* -mtime +7 -type f -exec rm {} \; 
        # Llamado de funcion de creacion de carpeta log
        carpeta_log_semanal;
        # Generacion de archivo.log
        cd $Semanal && touch DB_Backup.log  
        # Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
        # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base semanal Generada"    >>DB_Backup.log
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base semanal NO Generada"    >>DB_Backup.error
        fi 
    else 
        echo  "$(date +'%d-%b-%y  %r '):ALERT: Es 01 y Domingo no se hace nada :D "    #>>DB_Backup.log    
    fi
    # Peso maximo del archivo.log
    MaxFileSize=2048
        while true
        do
            # Obtener el peso en bytes del archivo.log
            file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Semanal/DB_Backup.log $Semanal/log/DB_Backup.log.$timestamp 
                    cd $Semanal && touch DB_Backup.log 
                else
                    break 
                fi
        done
    ;;
    Mensual)
	#se coloca date d m para obtener el dia y el mes en numero
	fecha=$(date +"%d-%m")
	if [ $fecha != 01-01 ]; then 
        echo "Iniciando backup Mensual $db_name"
        # Dump de base de datos en archivo SQL, se almacenara en Diario con el nombre de la base-fecha
        mysqldump --user=$user -p --password=$password $db_name >$Mensual/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 7 dias
        cd $Mensual && find $db_name* -mtime +7 -type f -exec rm {} \; 
        # Llamado de funcion de creacion de carpeta log
        carpeta_log_mensual;
        # Generacion de archivo.log
        cd $Mensual && touch DB_Backup.log 
        # Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
        # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero 
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base Mensual Generada"    >>DB_Backup.log
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base Mensual NO Generada"    >>DB_Backup.error
        fi 
    else 
        echo  "$(date +'%d-%b-%y  %r '):ALERT: Es 01 de Enero y no se hace nada :D "    #>>DB_Backup.log    
    fi
    # Peso maximo del archivo.log
    MaxFileSize=2048
        while true
        do
            # Obtener el peso en bytes del archivo.log
            file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Mensual/DB_Backup.log $Mensual/log/DB_Backup.log.$timestamp 
                    cd $Mensual && touch DB_Backup.log 
                else
                    break 
                fi
        done
    ;;
    Anual)
        echo "Iniciando backup Anual $db_name"
        # Dump de base de datos en archivo SQL, se almacenara en Diario con el nombre de la base-fecha
        mysqldump --user=$user -p --password=$password $db_name >$Anual/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 7 dias
        cd $Anual && find $db_name* -mtime +7 -type f -exec rm {} \; 
        # Llamado de funcion de creacion de carpeta log
        carpeta_log_anual;
        # Generacion de archivo.log
        cd $Anual && touch DB_Backup.log  
        # Hacemos un if para preguntar si el dump existe para despues mostrar el mensaje en el archivo.log
        # En caso de no generarse, se generara un archivo.error mostrando el mensaje que no se genero
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base anual Generada"    >>DB_Backup.log
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT: Backup de la base anual NO Generada"    >>DB_Backup.error
        fi 
        # Peso maximo del archivo.log
        MaxFileSize=2048
        while true
        do
            # Obtener el peso en bytes del archivo.log
            file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                # Preguntamos si el archivo.log es mas grande en peso que MaxFileSize, movera el archivo.log 
                # a la carpeta log añadiendo la variable timestamp
                if [ $file_size -gt $MaxFileSize ];then 
                    timestamp=`date +%s`
                    mv $Anual/DB_Backup.log $Anual/log/DB_Backup.log.$timestamp 
                    cd $Anual && touch DB_Backup.log 
                else
                    break 
                fi
        done
    ;;
esac
