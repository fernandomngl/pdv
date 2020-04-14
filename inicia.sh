#!/bin/bash
sleep 5 #Espera um pouco iniciar o sistema
xhost + #Utilizamos para automatizar e interagir com a tela com xdotool no DISPLAY
numlockx on #Iniciando numlock ativado
xrandr -d :0 --output `xrandr -q | grep 'primary' | cut -d' ' -f1` --mode 800x600 #Res
while true; do
	rm /home/`echo $USER`/.wine/dosdevices/com1
	rm /home/`echo $USER`/.wine/dosdevices/com2
	sleep 5
	xset -dpms s noblank s noexpose s off s 0 0 #Soluciona problemas -antigos- hibernar
	LOCALINI="/home/"`echo $USER`"/.wine/drive_c/pdv/"
	#PARA IGNORAR CASE E PEGAR APENAS UM local.ini:
	LOCALINI=$(find "$LOCALINI" -maxdepth 1 -iname local.ini | head -n 1)
  #PARA CAMINHO DO PINPAD
	PINPAD="/dev/serial/by-id/"$(ls /dev/serial/by-id/*Pinpad* | cut -d'/' -f5)
	ln -s $PINPAD /home/`echo $USER`/.wine/dosdevices/com2 #Link porta wine antigo
  sed -i 's,\("COM2"="\).*$,\1'"$PINPAD"'",' /home/`echo $USER`/seriais.reg
	echo $LOCALINI
	if [ -e "$LOCALINI" ]
	then
	  IMPRESSORA="/dev/serial/by-id/usb-Bematech_MP-4200_TH_Miniprinter-if00"
		IMPRESSORA2="/dev/serial/by-id/"$(ls /dev/serial/by-id/usb-EPSON* | cut -d'/' -f5)
	else
		#echo "arquivo local.ini nao encontrado"
		exit 0
	fi

	if [ -c "$IMPRESSORA2" ]
	then
		ln -s $IMPRESSORA2 /home/`echo $USER`/.wine/dosdevices/com1 #Link porta wine antigo
		INICIALIZADA=$(stty < `echo $IMPRESSORA2`)
		echo $INICIALIZADA > /home/`echo $USER`/printercfg.txt
		sed -i -E "s/(ModeloImpressora=).*$/\1EpsonNF/gI" $LOCALINI  #Ajusta no local.ini
		sed -i 's,\("COM1"="\).*$,\1'"$IMPRESSORA2"'",' /home/`echo $USER`/seriais.reg
	fi

	if [ -c "$IMPRESSORA" ]
	then
		ln -s $IMPRESSORA /home/`echo $USER`/.wine/dosdevices/com1 #Link porta wine antigo
    INICIALIZADA=$(stty < `echo $IMPRESSORA`)
    echo $INICIALIZADA > /home/`echo $USER`/printercfg.txt
		sed -i -E "s/(ModeloImpressora=).*$/\1BematechNF/gI" $LOCALINI #Ajusta no local.ini
		sed -i 's,\("COM1"="\).*$,\1'"$IMPRESSORA"'",' /home/`echo $USER`/seriais.reg
	fi


        if [ -c "$IMPRESSORA" ] || [ -c "$IMPRESSORA2" ]
        then
                wine regedit /home/`echo $USER`/seriais.reg
                cd /home/`echo $USER`/.wine/drive_c/pdv/
                sleep 2
                wine tcpcom.exe &
                sleep 8
                wine pdv10.exe
                exit
        else
                #echo "nao_existe" #ESPERA IMPRESSORA CARREGAR COM UM LIMITE
                zenity --error --text "IMPRESSORA DESLIGADA OU COM ERRO"
        fi
done
