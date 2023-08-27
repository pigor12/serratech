# Serratech

**Serratech** Um sistema de instalação automatizada de software inspirado na cultura mineira. Este sistema foi criado para simplificar o processo de instalação de software em computadores, proporcionando uma experiência mais eficiente.

![](https://github.com/pigor12/serratech/blob/main/GIF.gif)

## Visão Geral

O **SerraTech** automatiza o processo de instalação de software por meio de scripts em lote (batch scripts) para Windows. Ele oferece a capacidade de instalar uma variedade de softwares de forma silenciosa e sem complicações. O sistema inclui:

- Verificação de permissões administrativas e conectividade com a internet.
- Um menu de seleção de software para instalação.
- Download automático de arquivos de instalação.
- Instalação silenciosa de software.
- Compatível com Windows 7 (parcialmente), 8, 8.1, 10 e 11.
- Extensível para qualquer empresa ou necessidade da equipe de TI.
- Leve, não ocupa mais de 2mb de disco.

## Pré-requisitos

Antes de utilizar o SerraTech, certifique-se de:

1. Ter permissões administrativas no sistema.
2. Estar conectado à internet para acesso a repositórios e downloads.
3. Manter o formato padrão para os arquivos "BD.txt" e "REPOS.txt"

## Utilização

1. Clone ou faça o download deste repositório.
2. Execute o script `PREP_INST.bat` para salvar os arquivos nos diretórios corretos.
3. Execute o arquivo "SD.bat" para iniciar o sistema.
4. Siga as instruções na tela para navegar pelo menu e selecionar o software desejado.

## Arquivos de Configuração

- `BD.txt`: Este arquivo lista os softwares disponíveis para instalação. Cada linha segue o formato: `Nome;Identificador;URL;Tipo(EXE ou MSI);Parâmetros (para EXE);Opções`. Por exemplo:

| Nome a ser impresso | URL Download | Nome do executável | Extensão do arquivo | Flags de instalação | Opções |
|---------------------|--------------|--------------------|---------------------|---------------------|--------|
| 7-Zip               |     *URL*    | 7ZIP               | exe                 | /s                  | T      |
| Skype               |     *URL*    | SKYPE              | msi                 | (padrão do formato) | L      |
| Whatsapp Desktop    | *Código MS*  | -----              | ----                | ------              | MS     |

Sendo:
- **T** = Tudo, ou seja, caso o instalador não esteja disponível no computador ou rede da empresa, irá baixar da internet o instalador.
- **L** = Local, ou seja, é obrigatório que instalador esteja na rede da empresa ou no computador.
- **MS** = Software disponível (exclusivamente) na Microsoft Store. 

- `REPOS.txt`: Este arquivo lista os repositórios onde os instaladores estão localizados. Cada linha segue o formato: `Nome do Repositório;Hostname do Servidor;Caminho do Repositório`.

## Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir um issue ou enviar um pull request.

## Licença
Este projeto está licenciado sob a GNU General Public License v3.0.

## Contato
Para quaisquer perguntas ou feedback, por favor entre em contato comigo por [e-mail](mailto:pedroigor.reis@outlook.com).
