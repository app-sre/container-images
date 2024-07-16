# Logrotate container image

This image provides logrotate for log files, and can be used as a sidecar container
in a Kubernetes pod, or as a scheduled resource such as a cronJob.

## Usage

Two paths are mounted to the cronjob: the logging folder, and the log rotation config.

The logrotate configuration file is expected to be mounted at `/etc/logrotate.d/`.
Create a logrotate.conf file:

```bash
oc create configmap logrotate-config --from-file=logrotate.conf
```

Mount the configmap and the log files to be rotated in a cronJob or pod:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: logrotate
spec:
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      template:
          spec:
          containers:
          - name: logrotate
            image: quay.io/app-sre/logrotate:latest
            command: ["/usr/sbin/logrotate" ]
            args: ["/etc/logrotate.d/example-file" ]
            volumeMounts:
            - name: logrotate-config
              mountPath: /etc/logrotate.d
            - name: logs-to-rotate
              mountPath: /var/log/messages
          volumes:
            - name: logrotate-config
              configMap:
              name: logrotate-config
            - name: logs
              emptyDir: {}
```
