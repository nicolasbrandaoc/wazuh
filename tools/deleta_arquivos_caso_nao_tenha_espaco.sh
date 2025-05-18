#!/bin/bash
#
# Script para deletar arquivos antigos em /var/ossec/logs quando o espaço livre estiver abaixo do limite
# Caminho: /root/tools/deleta_arquivos_caso_nao_tenha_espaco.sh
#

# Configurações
DIR="/var/ossec/logs"                  # Diretório a ser monitorado
FREESPACE=5000000                      # Espaço livre mínimo em KB (aproximadamente 5GB)
LOG_FILE="/var/log/delete_files.log"   # Arquivo de log para registrar ações
MAX_FILES_DELETE=100                   # Limite máximo de arquivos a serem deletados por execução

# Função para registrar mensagens
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

# Verifica se o diretório existe
if [ ! -d "$DIR" ]; then
    log_message "ERRO: Diretório $DIR não encontrado!"
    exit 1
fi

# Verifica espaço disponível atual
AVAILABLE_SPACE=$(df --output=avail "$DIR" | tail -1)

# Se já temos espaço suficiente, não precisamos excluir arquivos
if [ "$AVAILABLE_SPACE" -ge "$FREESPACE" ]; then
    log_message "Espaço disponível ($AVAILABLE_SPACE KB) já é suficiente. Nenhum arquivo será excluído."
    exit 0
fi

log_message "Iniciando limpeza. Espaço disponível antes: $AVAILABLE_SPACE KB (meta: $FREESPACE KB)"

# Contador de arquivos excluídos
FILES_DELETED=0
BYTES_FREED=0

# Encontra os arquivos mais antigos e os exclui até atingir o espaço necessário
find "$DIR" -type f -printf "%T+ %s %p\n" | sort | while read -r timestamp size filepath; do
    # Verifica se já atingimos nosso limite de exclusão de arquivos
    if [ $FILES_DELETED -ge $MAX_FILES_DELETE ]; then
        log_message "Atingido limite máximo de arquivos ($MAX_FILES_DELETE). Interrompendo."
        break
    fi
    
    # Verifica novamente o espaço disponível
    CURRENT_SPACE=$(df --output=avail "$DIR" | tail -1)
    
    # Se já temos espaço suficiente, pare
    if [ "$CURRENT_SPACE" -ge "$FREESPACE" ]; then
        break
    fi
    
    # Registra o tamanho do arquivo em KB para estatísticas
    size_kb=$((size / 1024))
    
    # Remove o arquivo
    if rm -f "$filepath"; then
        BYTES_FREED=$((BYTES_FREED + size))
        FILES_DELETED=$((FILES_DELETED + 1))
        log_message "Excluído: $filepath ($size_kb KB)"
    else
        log_message "FALHA ao excluir: $filepath"
    fi
done

# Verificação final
FINAL_SPACE=$(df --output=avail "$DIR" | tail -1)
BYTES_FREED_KB=$((BYTES_FREED / 1024))

log_message "Limpeza concluída: $FILES_DELETED arquivos removidos, $BYTES_FREED_KB KB liberados"
log_message "Espaço atual: $FINAL_SPACE KB (necessário: $FREESPACE KB)"

if [ "$FINAL_SPACE" -lt "$FREESPACE" ]; then
    log_message "AVISO: Ainda não há espaço suficiente após a limpeza!"
fi

exit 0