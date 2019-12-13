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

case $1 in
	Diario)
		echo "Iniciando backup Diario $db_name"
		# Dump database into SQL file
		mysqldump --user=$user -p --password=$password $db_name >$Diario/$db_name-$date.sql
		# Eliminar archivos que tengan mas de 7 dias
		cd $Diario && find $db_name* -mtime +7 -type f -exec rm	{} \; 
		#find $Diario -mtime +7 -exec rm {} \;
		#DB backup log
		echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base diaria Generada"    >>DB_Backup.log
	;;
	Semanal)
		echo "Iniciando backup Semanal $db_name"
		# Dump database into SQL file
		mysqldump --user=$user -p --password=$password $db_name >$Semanal/$db_name-$date.sql
		# Eliminar archivos que tengan mas de 30  dias
		#find $Semanal/* -mtime +30 -exec rm {} \;
		cd $Semanal && find $db_name* -mtime +30 -type f -exec rm {} \;
		#DB backup log
		echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base Semanal Generada"    >>DB_Backu.log
	;;
	Mensual)
		echo "Iniciando backup Mensual $db_name"
		# Dump database into SQL file
		mysqldump --user=$user -p --password=$password $db_name >$Mensual/$db_name-$date.sql
		# Eliminar archivos que tengan mas de 365 dias
		#find $Mensual/* -mtime +365 -exec rm {} \;
		cd $Mensual && find $db_name* -mtime +365 -type f -exec rm {} \;
		#DB backup log
		echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup  de la base Mensual  Generada"    >>DB_Backup.log
	;;
	Anual)
		echo "Iniciando backup Anual $db_name"
		# Dump database into SQL file
		mysqldump --user=$user -p --password=$password $db_name >$Anual/$db_name-$date.sql
		# Eliminar archivos que tengan mas de  dias
		#cd $Anual && find $db_name* -mtime +365 -type f -exec rm {} \;
		#DB backup log
		#echo -e "$(date +'%d-%b-%y  %r '):ALERT:Backup de la base diaria Generada"    >>DB_Backup.log
	;;
esac
