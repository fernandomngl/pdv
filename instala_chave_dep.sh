#!/bin/sh
CAMINHO_RSA="/home/$USER/.ssh/id_rsa.pub"
if [ -f "$CAMINHO_RSA" ]; then
	CHAVE=$(head -n 1 ~/.ssh/id_rsa.pub)
	ansible-playbook -i hosts/inventario.yml -l 'deposito' autoriza_chave.yml --ask-pass --extra-vars="chave='$CHAVE'"
else
	echo "FAVOR GERAR O id_rsa.pub em $CAMINHO_RSA para esse script funcionar!"
fi
