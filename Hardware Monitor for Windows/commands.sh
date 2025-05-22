

Uso de Memória RAM

> (Get-Counter -ListSet * | where {$_.CounterSetName -eq 'Memory'}).Paths

Uso de Memória CPU

> (Get-Counter -ListSet * | where {$_.CounterSetName -eq 'Processor'}).Paths

'C:\\Program Files (x86)\\ossec-agent\\ossec.conf'