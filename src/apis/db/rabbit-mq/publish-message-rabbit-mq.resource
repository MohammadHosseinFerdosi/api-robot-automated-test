*** Settings ***
Library     RabbitMqHttp


*** Keywords ***
Publish Message To Rabbit
    [Arguments]    ${exchange_name}    ${routing_key}    ${payload}    ${headers}    ${payload_encoding}=string

    Create Rabbitmq Connection
    ...    ${RABBITMQ_URL}
    ...    ${RABBITMQ_PORT}
    ...    ${RABBITMQ_USER}
    ...    ${RABBITMQ_PASS}
    ...    alias=rmq

    ${properties}    Create Dictionary    delivery_mode=${1}    headers=${headers}

    Publish Message
    ...    exchange_name=${exchange_name}
    ...    routing_key=${routing_key}
    ...    payload=${payload}
    ...    payload_encoding=${payload_encoding}
    ...    props=${properties}

    [Teardown]    Close All Rabbitmq Connections
