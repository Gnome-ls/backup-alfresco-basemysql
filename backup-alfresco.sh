#!/bin/bash

back_alfresco="Backup_alfresco"
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
                   echo "Iniciando backup diario $back_alfresco"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/diario/$back_alfresco("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
		     # Eliminar archivos que tengan mas de 7 dias
                   cd $Diario && find $back_alfresco* -mtime +7 -type f -exec rm {} \;
                   #find $Diario -mtime +7 -exec rm {} \;
                   #logs de alertas backup alfresco
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco diaria Generada"    >>alfresco_Backup.log

 	;;
        Semanal)
		   echo "Iniciando backup semanal $back_alfresco"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/semanal/$back_alfresco("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 30 dias
                   cd $Semanal && find $back_alfresco* -mtime +30 -type f -exec rm {} \;
                   #find $Semanal -mtime +30 -exec rm {} \;
                   #logs de alertas backup alfresco
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco semanal Generada"    >>alfresco_Backup.log
 	;;
        Mensual)
		   echo "Iniciando backup mensual $back_alfresco"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/mensual/$back_alfresco("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Mensual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                   #find $Mensual -mtime +365 -exec rm {} \;
                   #logs de alertas backup alfresco
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco mensual Generada"    >>alfresco_Backup.log

	;;
        Anual)
                   echo "Iniciando backup anual  $back_alfresco"
                   #hacer el back up de file system
                   _destino="/mnt/nas/Backup_alfesco/anual/$back_alfresco("$date").tgz"
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Anual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                   #find $Anual -mtime +365 -exec rm {} \;
                   #logs de alertas backup alfresco
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco anual Generada"    >>alfresco_Backup.log



	;;
esac
