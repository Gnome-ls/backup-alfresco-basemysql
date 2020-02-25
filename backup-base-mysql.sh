#!/bin/bash
# Credenciales de la base de datos
user="root"
password="admin.SEAGED.2017"
db_name="victimas_prod"
Diario="/home/usuario/Backups/BD/Diario"
Semanal="/home/usuario/Backups/BD/Semanal"
Mensual="/home/usuario/Backups/BD/Mensual"
Anual="/home/usuario/Backups/BD/Anual"
date=$(date +"%d-%b-%Y")
AYER=$(date --date "yesterday" +%d-%n-%Y)
# Set default file permissions
umask 177

function carpeta_log () {

if [ -d "$Diario/log" ]; then
    echo "Existe"
else 
    cd $Diario
    mkdir log
fi

if [ -d "$Semanal/log" ]; then
    echo "Existe"
else 
    cd $Semanal
    mkdir log
fi

if [ -d "$Mensual/log" ]; then
    echo "Existe"
else 
    cd $Mensual
    mkdir log
fi

if [ -d "$Anual/log" ]; then
    echo "Existe"
else 
    cd $Anual
    mkdir log
fi
}

case $1 in
    Diario)
        echo "Iniciando backup Diario $db_name"
        # Dump database into SQL file
        mysqldump --user=$user -p --password=$password $db_name >$Diario/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 7 dias
        cd $Diario && find $db_name* -mtime +7 -type f -exec rm {} \; 
        #find $Diario -mtime +7 -exec rm {} \;
        #DB backup log
        carpeta_log;
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base diaria Generada"    >>DB_Backup.log
                MaxFileSize=2048
                while true
                do
                    #sh /home/jccv/base.sh >> DB_Backup.log
                    file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                    if [ $file_size -gt $MaxFileSize ];then   
                        timestamp=`date +%s`
                        mv DB_Backup.log $Diario/log/DB_Backup.log.$timestamp
                        touch DB_Backup.log
                    fi
                done
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base diaria NO Generada"    >>DB_Backup.error
        fi 
    ;;
    Semanal)
        echo "Iniciando backup Semanal $db_name"
        # Dump database into SQL file
        mysqldump --user=$user -p --password=$password $db_name >$Semanal/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 30  dias
        cd $Semanal && find $db_name* -mtime +30 -type f -exec rm {} \;
        #DB backup log
        carpeta_log;
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base semanal Generada"    >>DB_Backup.log
                MaxFileSize=2048
                while true
                do
                    #sh /home/jccv/base.sh >> DB_Backup.log
                    file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                    if [ $file_size -gt $MaxFileSize ];then   
                        timestamp=`date +%s`
                        mv DB_Backup.log $Semanal/log/DB_Backup.log.$timestamp
                        touch DB_Backup.log
                    fi
                done
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base semanal NO Generada"    >>DB_Backup.error
        fi 
    ;;
    Mensual)
        echo "Iniciando backup Mensual $db_name"
        # Dump database into SQL file
        mysqldump --user=$user -p --password=$password $db_name >$Mensual/$db_name-$date.sql
        # Eliminar archivos que tengan mas de 365 dias
        cd $Mensual && find $db_name* -mtime +365 -type f -exec rm {} \;
        #DB backup log
        carpeta_log;
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base mensual Generada"    >>DB_Backup.log
                MaxFileSize=2048
                while true
                do
                    #sh /home/jccv/base.sh >> DB_Backup.log
                    file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                    if [ $file_size -gt $MaxFileSize ];then   
                        timestamp=`date +%s`
                        mv DB_Backup.log $Mensual/log/DB_Backup.log.$timestamp
                        touch DB_Backup.log
                    fi
                done
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base mensual NO Generada"    >>DB_Backup.error
        fi 
    ;;
    Anual)
        echo "Iniciando backup Anual $db_name"
        # Dump database into SQL file
        mysqldump --user=$user -p --password=$password $db_name >$Anual/$db_name-$date.sql
        # Eliminar archivos que tengan mas de  dias
        cd $Anual && find $db_name* -mtime +365 -type f -exec rm {} \;
        #DB backup log
        carpeta_log;
        if [ -f "$db_name-$date.sql" ] ; then 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base anual Generada"    >>DB_Backup.log
                MaxFileSize=2048
                while true
                do
                    #sh /home/jccv/base.sh >> DB_Backup.log
                    file_size=`du -b DB_Backup.log | tr -s '\t' ' ' | cut -d' ' -f1`
                    if [ $file_size -gt $MaxFileSize ];then   
                        timestamp=`date +%s`
                        mv DB_Backup.log $Anual/log/DB_Backup.log.$timestamp
                        touch DB_Backup.log
                    fi
                done
            else 
                echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base anual NO Generada"    >>DB_Backup.error
        fi 
    ;;
esac
