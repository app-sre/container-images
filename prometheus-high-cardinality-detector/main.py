import os
import requests
from slack_sdk.webhook import WebhookClient


"""
This script is supposed to run as a cronjob in the prom server namespace
"""
# TODO: proper error handling
host = os.environ.get("PROM_HOST", "prometheus-app-sre.openshift-customer-monitoring.svc.cluster.local")
cluster = os.environ.get("CLUSTER")
cardinality_threshold = int(os.environ.get("CARDINALITY_THRESHOLD", "50000"))

with open("/etc/slack_url", "r") as f:
    slack_url = f.read().strip()


webhook = WebhookClient(slack_url)
response = requests.post(
    f"http://{host}:9090/api/v1/query",
    headers={"Content-Type": "application/x-www-form-urlencoded"},
    data={"query": "topk(10, count by (__name__)({__name__=~\".+\"}))"},
    timeout=300, # 5 minutes
)

data = response.json()

metrics = data.get("data", {}).get("result", [])
high_cardinality_metrics = {}
for metric in metrics:
    metric_name = metric.get("metric", {}).get("__name__")
    cardinality = int(metric.get("value", [-1, -1])[1])

    print(f"{metric_name=} {cardinality=}")

    if cardinality > cardinality_threshold:
        high_cardinality_metrics[metric_name] = cardinality

if high_cardinality_metrics:
    # TODO: @app-sre-ic should ping. Maybe rich text block or similar needed here? https://api.slack.com/reference/block-kit/blocks
    response = webhook.send(text=f"@app-sre-ic we have high cardinality metrics in prometheus in cluster '{cluster}' {high_cardinality_metrics}")
