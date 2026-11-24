from robot.api.deco import keyword
import requests


@keyword
def push_metric_to_prometheus(
    url, username, password, metric_name, metric_type, description, value, labels=None
):
    """
    Push a single Prometheus metric to a Pushgateway.

    Args:
        url (str): Full Pushgateway endpoint, e.g. http://10.198.13.77:9091/metrics/job/qa
        username (str): Basic-auth username
        password (str): Basic-auth password
        metric_name (str): Name of the metric, e.g. task_duration_seconds
        description (str): HELP text describing the metric
        metric_type (str): Metric type, e.g. gauge, counter
        value (float|int): Metric value
        labels (dict): Optional labels dictionary, e.g. {"app": "qa2", "env": "dev"}
    """

    label_str = ""
    if labels:
        label_pairs = [f'{k}="{v}"' for k, v in labels.items()]
        label_str = "{" + ",".join(label_pairs) + "}"

    payload = (
        f"# HELP {metric_name} {description}\n"
        f"# TYPE {metric_name} {metric_type}\n"
        f"{metric_name}{label_str} {value}\n"
    )

    response = requests.post(
        url,
        data=payload,
        headers={"Content-Type": "text/plain; version=0.0.4"},
        auth=(username, password),
        timeout=10,
    )

    response.raise_for_status()

    return payload, response
