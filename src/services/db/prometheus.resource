*** Settings ***
Library     library/prometheus.py
Library     Collections
Library     OperatingSystem
Library     String


*** Keywords ***
Send Summary To Prometheus
    [Documentation]    Build and push execution summary metrics (passed/failed/skipped/total)
    ...    for each suite to the Pushgateway using YAML-configured settings.
    [Arguments]    ${summary_table}

    ${test_suites}    Get Dictionary Keys    ${summary_table}

    FOR    ${suite}    IN    @{test_suites}
        ${suite_data}    Set Variable    ${summary_table['${suite}']}

        ${total}    Evaluate    int(${suite_data['total']})
        ${failed}    Evaluate    int(${suite_data['failed']})
        ${skipped}    Evaluate    int(${suite_data['skipped']})
        ${passed}    Evaluate    ${total} - ${failed} - ${skipped}

        ${metric_name}    Set Variable    qa_test_summary
        ${metric_type}    Set Variable    gauge
        ${description}    Set Variable    Snapshot of test counts by suite and outcome

        ${conditions}    Create Dictionary
        ...    passed=${passed}
        ...    failed=${failed}
        ...    skipped=${skipped}
        ...    total=${total}

        FOR    ${condition}    IN    passed    failed    skipped    total
            ${base_url}    Set Variable
            ...    http://${PROMETHEUS_URL}:${PROMETHEUS_PORT}/${PROMETHEUS_PATH}/job/${PROMETHEUS_JOB}/suite/${suite}/condition/${condition}

            ${response_prometheus}    Push Metric To Prometheus
            ...    url=${base_url}
            ...    username=${PROMETHEUS_USERNAME}
            ...    password=${PROMETHEUS_PASSWORD}
            ...    metric_name=${metric_name}
            ...    metric_type=${metric_type}
            ...    description=${description}
            ...    value=${conditions['${condition}']}
        END
    END

Extract Summary Table
    [Documentation]    This keywords extracts the .txt summary table generatd from the qa-script execution.
    ...
    ...    Returns a Dictionary: ${summary_table}
    [Arguments]    ${file_path}=${SUMMARY_TABLE_PATH}
    ${content}    Get File    ${file_path}
    ${lines}    Split To Lines    ${content}    start=${1}
    ${length}    Get Length    ${lines}
    ${summary_table}    Create Dictionary
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${line}    Set Variable    ${lines}[${i}]
        ${line}    Split String    ${line}    ${SPACE}${SPACE}
        ${summary_i}    Create List
        FOR    ${item}    IN    @{line}
            IF    '${item}'!='${EMPTY}'
                IF    '${item}'!=' '
                    Append To List    ${summary_i}    ${item}
                END
            END
        END
        ${summary_i}    Set Variable    ${summary_i}[${1}:]
        ${feature_data}    Create Dictionary
        ...    total=${summary_i}[1]
        ...    failed=${summary_i}[2]
        ...    skipped=${summary_i}[3]

        Set To Dictionary    ${summary_table}    ${summary_i}[0]=${feature_data}
    END

    RETURN    ${summary_table}
