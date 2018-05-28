@echo OFF
powershell -Command "plink -ssh -i D:\your\path\to\private\key\id_rsa.ppk -noagent root@11.111.111.11 /root/scripts/yourScriptInServer.sh yourwebsitename"
powershell -Command "WinSCP.exe /console /script='D:\\your\\path\\to\\winscp\\script\\prod_to_server.txt'"
