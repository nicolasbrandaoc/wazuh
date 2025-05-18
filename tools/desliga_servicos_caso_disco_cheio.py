import shutil
import subprocess

# Defina o limite de uso de disco (em porcentagem)
DISK_USAGE_LIMIT = 95

# Caminho a ser monitorado
MONITOR_PATH = '/'

# Lista de comandos a serem executados se o limite for ultrapassado
comandos = [
    '/usr/sbin/service wazuh-dashboard stop'
    '/usr/sbin/service wazuh-manager stop'
    '/usr/sbin/service wazuh-indexer stop'
    '/usr/sbin/service rsyslog stop'
]

def verificar_uso_disco(path):
    total, usado, livre = shutil.disk_usage(path)
    percentual_usado = (usado / total) * 100
    return percentual_usado

def executar_comandos(lista_comandos):
    for comando in lista_comandos:
        print(f"Executando: {comando}")
        resultado = subprocess.run(comando, shell=True, text=True, capture_output=True)
        print(f"Saída:\n{resultado.stdout}")
        if resultado.stderr:
            print(f"Erros:\n{resultado.stderr}")

def main():
    uso = verificar_uso_disco(MONITOR_PATH)
    print(f"Uso atual do disco em '{MONITOR_PATH}': {uso:.2f}%")

    if uso >= DISK_USAGE_LIMIT:
        print("⚠️  Limite de uso de disco ultrapassado. Executando comandos definidos.")
        executar_comandos(comandos)
    else:
        print("✅ Uso de disco dentro do limite.")

if __name__ == '__main__':
    main()
