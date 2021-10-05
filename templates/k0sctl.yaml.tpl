apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: k0s-cluster
spec:
  hosts:
    ${indent(4, replace(yamlencode(hosts), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:") )}
  k0s:
    version: 1.22.2+k0s.0
    config:
      apiVersion: k0s.k0sproject.io/v1beta1
      kind: Cluster
      metadata:
        name: k0s
      spec:
        api:
          k0sApiPort: 9443
          port: 6443
        images:
          calico:
            cni:
              image: docker.io/calico/cni
              version: v3.18.1
            kubecontrollers:
              image: docker.io/calico/kube-controllers
              version: v3.18.1
            node:
              image: docker.io/calico/node
              version: v3.18.1
          coredns:
            image: docker.io/coredns/coredns
            version: 1.7.0
          default_pull_policy: IfNotPresent
          konnectivity:
            image: us.gcr.io/k8s-artifacts-prod/kas-network-proxy/proxy-agent
            version: v0.0.24
          kubeproxy:
            image: k8s.gcr.io/kube-proxy
            version: v1.22.1
          kuberouter:
            cni:
              image: docker.io/cloudnativelabs/kube-router
              version: v1.2.1
            cniInstaller:
              image: quay.io/k0sproject/cni-node
              version: 0.1.0
          metricsserver:
            image: gcr.io/k8s-staging-metrics-server/metrics-server
            version: v0.5.0
        installConfig:
          users:
            etcdUser: etcd
            kineUser: kube-apiserver
            konnectivityUser: konnectivity-server
            kubeAPIserverUser: kube-apiserver
            kubeSchedulerUser: kube-scheduler
        konnectivity:
          adminPort: 8133
          agentPort: 8132
        network:
          kubeProxy:
            disabled: false
            mode: iptables
          kuberouter:
            autoMTU: true
            mtu: 0
            peerRouterASNs: ""
            peerRouterIPs: ""
          podCIDR: 10.244.0.0/16
          provider: kuberouter
          serviceCIDR: 10.96.0.0/12
        podSecurityPolicy:
          defaultPolicy: 00-k0s-privileged
        storage:
          type: etcd
        telemetry:
          enabled: true
