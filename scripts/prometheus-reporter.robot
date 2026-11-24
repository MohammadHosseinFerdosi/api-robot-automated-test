*** Settings ***
Resource    services/db/prometheus.resource

*** Tasks ***
Set Summary Table To The Prometheus
    ${summary_table}    Extract Summary Table
    Send Summary To Prometheus    ${summary_table}