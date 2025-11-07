#!/bin/bash
#
# Autor: Altemir Pacheco 
# Data: 07/11/2025
# Recursos:
# •  Lista todos os formatos disponíveis (vídeo e áudio)
# •  Menu interativo com 4 opções:
#    a. Melhor qualidade automática - baixa e mescla automaticamente
#    b. Seleção manual - você escolhe os IDs específicos de vídeo e áudio
#    c. Apenas áudio - extrai MP3 da melhor qualidade
#    d. Apenas vídeo - baixa só o vídeo
# •  Verifica se yt-dlp e ffmpeg estão instalados
# •  Interface colorida para melhor visualização
#
# Requisitos:
# •  yt-dlp (para instalar: pip install yt-dlp)
# •  ffmpeg (para instalar: sudo apt install ffmpeg)
#

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verifica se yt-dlp está instalado
if ! command -v yt-dlp &> /dev/null; then
    echo -e "${RED}Erro: yt-dlp não está instalado.${NC}"
    echo "Instale com: pip install yt-dlp ou sudo apt install yt-dlp"
    exit 1
fi

# Verifica se ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}Aviso: ffmpeg não está instalado. Pode ser necessário para mesclar formatos.${NC}"
    echo "Instale com: sudo apt install ffmpeg"
fi

# Recebe a URL
if [ -z "$1" ]; then
    echo -e "${BLUE}Digite a URL do vídeo:${NC}"
    read -r URL
else
    URL="$1"
fi

# Valida URL
if [ -z "$URL" ]; then
    echo -e "${RED}Erro: URL não fornecida.${NC}"
    exit 1
fi

echo -e "${GREEN}Buscando formatos disponíveis...${NC}\n"

# Lista formatos disponíveis
yt-dlp -F "$URL"

if [ $? -ne 0 ]; then
    echo -e "${RED}Erro ao buscar formatos. Verifique a URL.${NC}"
    exit 1
fi

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Opções de download:${NC}"
echo -e "  1) Melhor qualidade (vídeo + áudio automaticamente)"
echo -e "  2) Selecionar formato de vídeo e áudio manualmente"
echo -e "  3) Apenas áudio (melhor qualidade)"
echo -e "  4) Apenas vídeo (melhor qualidade)"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

read -p "Escolha uma opção [1-4]: " OPTION

case $OPTION in
    1)
        echo -e "${GREEN}Baixando melhor qualidade...${NC}"
        yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 "$URL"
        ;;
    2)
        echo -e "\n${BLUE}Digite o ID do formato de VÍDEO desejado:${NC}"
        read -r VIDEO_FORMAT
        
        echo -e "${BLUE}Digite o ID do formato de ÁUDIO desejado:${NC}"
        read -r AUDIO_FORMAT
        
        if [ -z "$VIDEO_FORMAT" ] || [ -z "$AUDIO_FORMAT" ]; then
            echo -e "${RED}Erro: Formatos não especificados.${NC}"
            exit 1
        fi
        
        echo -e "${GREEN}Baixando formato ${VIDEO_FORMAT}+${AUDIO_FORMAT}...${NC}"
        yt-dlp -f "${VIDEO_FORMAT}+${AUDIO_FORMAT}" --merge-output-format mp4 "$URL"
        ;;
    3)
        echo -e "${GREEN}Baixando apenas áudio (melhor qualidade)...${NC}"
        yt-dlp -f "bestaudio" -x --audio-format mp3 "$URL"
        ;;
    4)
        echo -e "${GREEN}Baixando apenas vídeo (melhor qualidade)...${NC}"
        yt-dlp -f "bestvideo" "$URL"
        ;;
    *)
        echo -e "${RED}Opção inválida.${NC}"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ Download concluído com sucesso!${NC}"
else
    echo -e "\n${RED}✗ Erro durante o download.${NC}"
    exit 1
fi
