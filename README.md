What we want to do:
- deploy sample application
- deploy elasticsearch Helm chart

elasticseach password: kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}' -n elastic-stack
2Iiix3Qw99NzoMpXK23l4151

'''
# Kibana config
elasticsearch:
    hosts:
        - https://elasticsearch-es-http.elastic-stack.svc:9200
    serviceAccountToken: AAEAAWVsYXN0aWMva2liYW5hL2VsYXN0aWMtc3RhY2tfZXMta2ItcXVpY2tzdGFydC1lY2sta2liYW5hXzA5ZDcyMmQyLTJlMjMtNGFhNy1iMjk3LTM2YWQ5MmU5MzI1NTpzUERNdzh6bjFTbWFySDVVWWFLRlBES2VyTDRaWGJsOTNTdlRJRGQwcTZkNkc1TE9Ma2N6Z1lQcFpBaGhwdGZW
    ssl:
        certificateAuthorities: /usr/share/kibana/config/elasticsearch-certs/ca.crt
        verificationMode: certificate
monitoring:
    ui:
        container:
            elasticsearch:
                enabled: true
server:
    host: 0.0.0.0
    name: es-kb-quickstart-eck-kibana
    ssl:
        certificate: /mnt/elastic-internal/http-certs/tls.crt
        enabled: true
        key: /mnt/elastic-internal/http-certs/tls.key
xpack:
    encryptedSavedObjects:
        encryptionKey: pIfJSl43A0zdBNNKxl8LcRAo1UOt8j66zsDcOzzNPvknUFlNYM7n2TAzkrvFfWzF
    license_management:
        ui:
            enabled: false
    reporting:
        encryptionKey: P5BU5c7XynamNBKm2sziVAOARrRU2hu3pgyN5PeUoyUj8tFFktmiERpNn1CaS1oO
    security:
        encryptionKey: Nb0w6Zahv5lzEcu1sLsncTyXfEQ6UumUscY3blfoB2WEamXcyN3RqKir1ilJl3am
'''

- Deploy Kibana Helm chart
- Configure kibana with elasticsearch

- Install fluentbit
helm repo add fluent https://fluent.github.io/helm-charts
- collect logs from application and send them to elastic
    - Hecho, ahora estaria bien desarrollar un automatismo, para que de forma dinamica se añadan bloques de output cada vez que se despleiga una app.

- Instalar jenkins
  - Instalar plugin de kubernetes
  - Instalar kubectl en el ejecutor
    1. Creamos dockerfile tirando del agente jnlp
    2. Instalamos kubectl
    3. Sobreescribimos el contendor jnlp, sino se crea uno a parte
  - crear pipeline para que:
    1. despliegue una app dada una imagen
    2. añada con ansible un nuevo bloquee de output al fiochero de config de fluentbit.
        1. Git pull del fichero de config
        2. Actualizar los contenidos usando ansible
        3. Git push
        4. Usar helm para para actualizar la pipeline

L76ltuu2aG7P2ENKPXiqMy




- deploy istio?
- use opentelemetry?