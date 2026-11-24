*** Settings ***
Library         RabbitMqHttp



*** Keywords ***
Get Message From Rabbit
    [Arguments]    ${queue_name}    ${message_count}

    Create Rabbitmq Connection
    ...    ${RABBITMQ_URL}
    ...    ${RABBITMQ_PORT}
    ...    ${RABBITMQ_USER}
    ...    ${RABBITMQ_PASS}
    ...    alias=rmq

    ${msg}    Get Message    queue_name=${queue_name}    count=${message_count}    requeue=False    encoding=auto

    RETURN    ${msg}

    [Teardown]    Close All Rabbitmq Connections
