#!/bin/bash
# ############# #
# PROTOCOLOS_V4 #
# ############# #

# ############################################## #
# NECESSARIO TER INSTALADO OS PROGRAMAS ABAIXO:  #
# NMAP                                           #
# MASSCAN                                        #
#                                                #
# E OS SCRIPTS NSE abaixo:                       #
# dns-service-discovery                          #
# ldap-search                                    #
# nbstat.nse                                     #
# tftp-enum.nse                                  #
# ############################################## #

# IPS QUE SERÃO SCANEADOS                    #
IP="1.1.1.1/32 8.8.8.8/32"                   #
IP_MASSCAN="1.1.1.1/32 8.8.8.8/32"           #
# ########################################## #

# #################################################### #
# CONFIG RELACIONADO AO NMAP                           #
VAR1=$(date '+%d-%m-%y')                               #
caminho_do_relatorio="/home/felipe/protocolos/nmap"    #
mkdir -p $caminho_do_relatorio/$VAR1                   #
# #################################################### #  

# #################################################################################### #
# CONFIG RELACIONADO AO MASSCAN                                                        #
pasta_do_config="/home/felipe/masscan"                                                 #
arquivo_do_config="$pasta_do_config/config.txt"                                        #
arquivo_do_resultado="/home/felipe/protocolos/masscan/$VAR1/masscan.log"               #
mkdir -p $pasta_do_config                                                              #
mkdir -p $arquivo_do_resultado                                                         #
# #################################################################################### #

# #######################################################
# CAMINHO DO LOG UNIFICADO                              #
PASTA_LOG_UNIFICADO=/home/felipe/protocolos/            #
mkdir -p $PASTA_LOG_UNIFICADO                           #
ARQUIVO_LOG_UNIFICADO=$PASTA_LOG_UNIFICADO/log.data     #
touch $ARQUIVO_LOG_UNIFICADO                            #
# #######################################################


echo "Iniciando NMAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o DNS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 53 E 5353 ###########################################
nmap --script=dns-service-discovery  -n -sUV -oA $caminho_do_relatorio/$VAR1/53.log -p 53 $IP
########################################################################################################
echo "Terminei o DNS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o MDNS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 53 E 5353 ###########################################
nmap --script=dns-service-discovery  -n -sUV -oA $caminho_do_relatorio/$VAR1/5353.log -p 5353 $IP
########################################################################################################
echo "Terminei o MDNS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o NTP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 123 #################################################
nmap -T5 -n -Pn -sUV  -oA $caminho_do_relatorio/$VAR1/123.log -p 123 $IP
########################################################################################################
echo "Terminei o NTP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o QOTD em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 17 ##################################################
nmap -T5 -n -Pn -sUV  -oA $caminho_do_relatorio/$VAR1/17.log -p 17 $IP
########################################################################################################
echo "Terminei o QOTD em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o SNMP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 161 #################################################
nmap -sUV -p 161  -oA $caminho_do_relatorio/$VAR1/161.log -T5 $IP
########################################################################################################
echo "Terminei o SNMP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o MEMCACHED em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 11211 ###############################################
nmap -sUV -p 11211  -T5 -oA $caminho_do_relatorio/$VAR1/11211.log $IP
########################################################################################################
echo "Terminei o MEMCACHED em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o PORTMAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 111 #################################################
nmap -sUV -p 111 -T5  -oA $caminho_do_relatorio/$VAR1/111.log $IP
########################################################################################################
echo "Terminei o PORTMAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o TFTP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 69 ##################################################
nmap -sUV -p 69 --version-intensity 10 -oA $caminho_do_relatorio/$VAR1/69.log --script tftp-enum.nse --script-args tftp-enum.filelist=customlist.txt $IP
#OBS: https://www.shodan.io/search?query=tftp
########################################################################################################
echo "Terminei o TFTP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o NETBIOS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 137 #################################################
nmap -sUV --script nbstat.nse -p 137 -oA $caminho_do_relatorio/$VAR1/137.log  $IP
########################################################################################################
echo "Terminei o NETBIOS em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Inicia o LDAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
######################################### PORTA(S) 389 #################################################
nmap -p 389 -sUV -Pn --script ldap-search --script-args 'ldap.username="cn=ldaptest,cn=users,dc=cqure,dc=net",ldap.password=ldaptest,ldap.qfilter=custom,ldap.searchattrib="operatingSystem",ldap.searchvalue="Windows *Server*",ldap.attrib={operatingSystem,whencreated,OperatingSystemServicePack}' -oA $caminho_do_relatorio/$VAR1/389.log $IP
########################################################################################################
echo "Terminei o LDAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Terminando NMAP em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Iniciando MASSCAN em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO

echo "Criando arquivo de configuração"

echo "# targets" > $arquivo_do_config
echo "range = "$IP_MASSCAN"" >> $arquivo_do_config
echo "ports = U:53,U:123,U:17,U:1900,U:11211,U:5353,U:111,U:137,U:19,U:389,U:161,U:69" >> $arquivo_do_config
echo "ping = False" >> $arquivo_do_config
echo "rate = 100" >> $arquivo_do_config
echo "output-format = xml" >> $arquivo_do_config
echo "output-filename = $arquivo_do_resultado.xml" >> $arquivo_do_config

masscan -c $arquivo_do_config

echo "Finalizando MASSCAN em $(date '+%d-%m-%y %H:%M:%S')" >> $ARQUIVO_LOG_UNIFICADO
