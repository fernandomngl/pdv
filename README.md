# pdv
Scripts para preparar ambiente de PDV - Ubuntu 18 LTS ou superior

Esses scripts foram editados com base nos que utilizamos para compartilharmos com os nossos colegas de sistema.

--

Como utilizar:

Utilizamos uma maq. com a distrib. Ubuntu 18.04 LTS como agente instalador,
nela o ansible precisa estar instalado. Para conectar utilizamos chaves ssh, geradas com ssh-keygen.

-- Procedimento PDV:

Instalar Ubuntu 18.04 LTS ou superior (pode ser config normal, removemos jogos e desnec. nos scripts), anotar o nome de user pois utilizaremos no arquivo hosts/inventario.yml
Instalar openssh-server python e desabilitar o firewall:

sudo apt update && sudo apt upgrade -y && sudo apt install openssh-server python -y && sudo ufw disable

anotem o ip da maquina caso necessario com o comando ifconfig ou com o comando ip a

-- Procedimento na maquina agente instalador de onde executamos o Ansible:

instalar os programas do ansible e de edição

sudo apt update && sudo apt upgrade -y && sudo apt install ansible vim sshpass -y

gerem uma chave com o comando ssh-keygen (pode ser sem senha mesmo)

editem o arquivo inventario.yml na pasta hosts para inserir o ip na secao pdv_staging e modifiquem o ansible_user dele para o user que foi colocado enquanto era instalado e salvem

rodem da pasta dos scripts o instala_chave_staging.sh

sh instala_chave_staging.sh

--- importante, colocamos nessa pasta o arquivo ansible.cfg , dependendo do agente instalador ele pode nao sobreescrever o de /etc/ansible/ansible.cfg , nesse caso, editem la o caminho do inventario e confiram se host_key_checking = False ---

(nesse modo simples que fizemos recomendamos usar a mesma senha pra diferentes maquinas, mudando apenas os usuarios, se quiserem usar senhas diferentes essas podem ser colocadas tambem no arquivo inventario, para compartilharmos esses scripts nesse repositorio publico nao salvamos senhas)

para testar se funcionou a instalacao das chaves rodem o comando

ansible-playbook -i hosts/inventario.yml ping_pdv

para fazer o deploy do pdv utilizar o script prepara_pdv

ansible-playbook -i hosts/inventario.yml prepara_pdv

apos maquina reiniciar, com o wine instalem o setup_pdv e copiem os arquivos que serao utilizados em /home/<user>/pdv 

acredito que seja isso, qualquer duvida entrem em contato, comentem e me ajudem a corrigir erros (no texto tb)

tudo de bom!

--

alguns detalhes extras:

configuramos para detectar automaticamente a impressora e o pinpad usb no boot, impressora com1 e pinpad com2
esse ajuste inclusive modifica o arquivo local.ini (cuidem para estar minusculo o nome do arquivo, podem acontecer alguns problemas case senstive com os scripts rodando diretamente do linux)
as portas seriais normais contar a partir da porta 3, no caso, com1 da maquina utilizamos com3 no wine

o horario esta configurado para ser automatico

174 e 175 funcionando (para isso utilizamos um wrapper shell no sudo, porque o wine consegue usar assim para chamar o sudo init 0 e 6 que o programa utiliza)

foram feitos varios ajustes, acho que o mais importante foi comentado
