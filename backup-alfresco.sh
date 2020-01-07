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
		   cd $Diario
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Iniciando backup diario $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Path $Diario"    >>alfresco_Backup.log
                   _destino="/mnt/nas/Backup_alfesco/diario/$back_alfresco("$date").tgz"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Destino $_destino"    >>alfresco_Backup.log
                   tar cvfz $_destino $ruta_de_alfresco
		   # Eliminar archivos que tengan mas de 7 dias
		   # cd $Diario && find $back_alfresco* -mtime +7 -print
                   cd $Diario && find $back_alfresco* -mtime +7 -type f -exec rm {} \;
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco diaria Generada"    >>alfresco_Backup.log

 	;;
        Semanal)
		   cd $Semanal
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Iniciando backup Semanal $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Path $Semanal"    >>alfresco_Backup.log
                   _destino="/mnt/nas/Backup_alfesco/semanal/$back_alfresco("$date").tgz"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Destino $_destino"    >>alfresco_Backup.log
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 30 dias
                   cd $Semanal && find $back_alfresco* -mtime +30 -type f -exec rm {} \;
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco semanal Generada"    >>alfresco_Backup.log
 	;;
        Mensual)
		   cd $Mensual
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Iniciando backup Mensual $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Path $Mensual"    >>alfresco_Backup.log
                   _destino="/mnt/nas/Backup_alfesco/mensual/$back_alfresco("$date").tgz"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Destino $_destino"    >>alfresco_Backup.log
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Mensual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco mensual Generada"    >>alfresco_Backup.log

	;;
        Anual)
		   cd $Anual
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Iniciando backup Anual $back_alfresco"    >>alfresco_Backup.log
                   #hacer el back up de file system
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Path $Anual"    >>alfresco_Backup.log
                   _destino="/mnt/nas/Backup_alfesco/anual/$back_alfresco("$date").tgz"
		   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Destino $_destino"    >>alfresco_Backup.log
                   tar cvfz $_destino $ruta_de_alfresco
                   # Eliminar archivos que tengan mas de 365 dias
                   cd $Anual && find $back_alfresco* -mtime +365 -type f -exec rm {} \;
                   echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de Alfresco anual Generada"    >>alfresco_Backup.log



	;;
esac
