#!/bin/bash

db_name="Backup_alfresco"
Diario="/mnt/nas/Backup_alfesco/diario"
Semanal="/mnt/nas/Backup_alfesco/semanal"
Mensual="/mnt/nas/Backup_alfesco/mensual"
Anual="/mnt/nas/Backup_alfesco/anual"
date=$(date +"%d-%b-%Y")
ruta_de_alfresco="/mnt/nas/alfresco"
# Set default file permissions
umask 177

case $1 in
        Diario)
                   echo "Iniciando backup diario $db_name"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/diario/$db_name("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
		   # Eliminar archivos que tengan mas de 7 dias
                   #find $Diario -mtime +7 -exec rm {} \;
                   #en este tengo duda  guardar en los
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco diaria Generada"    >>alfresco_Backup.log

 	;;
        Semanal)
		   echo "Iniciando backup semanal $db_name"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/semanal/$db_name("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 30 dias
                   #find $Semanal -mtime +30 -exec rm {} \;
                   #en este tengo duda  guardar en los
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco semanal Generada"    >>alfresco_Backup.log
 	;;
        Mensual)
		   echo "Iniciando backup mensual $db_name"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/mensual/$db_name("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   #find $Mensual -mtime +365 -exec rm {} \;
                   #en este tengo duda  guardar en los
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco mensual Generada"    >>alfresco_Backup.log

	;;
        Anual)
                   echo "Iniciando backup anual  $db_name"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/anual/$db_name("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   #find $Anual -mtime +365 -exec rm {} \;
                   #en este tengo duda  guardar en los
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco anual Generada"    >>alfresco_Backup.log



	;;
esac
