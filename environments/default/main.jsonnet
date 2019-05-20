local prometheus = import 'prometheus-ksonnet/prometheus-ksonnet.libsonnet';
local tns = import 'tns-mixin/mixin.libsonnet';

prometheus + tns {
  _config+:: {
    namespace: 'default',
    grafana_root_url: '',
  },

  grafana_datasource_config_map+:
    $.core.v1.configMap.withDataMixin({
      'loki.yml': $.util.manifestYaml({
        apiVersion: 1,
        datasources: [{
          name: 'Loki-Demo',
          type: 'loki',
          access: 'proxy',
          url: 'http://loki:3100/',
          isDefault: false,
          version: 1,
          editable: false,
        }],
      }),
    }),

  local service = $.core.v1.service,
  local servicePort = $.core.v1.service.mixin.spec.portsType,

  grafana_service+:
    service.mixin.spec.withType('NodePort') +
    service.mixin.spec.withPorts([
      servicePort.newNamed('grafana-grafana', 80, 80) +
      servicePort.withNodePort(30080),
    ]),
}
