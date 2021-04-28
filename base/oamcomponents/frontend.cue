parameter: {
	image:  string
	port:   *80 | int
	domain: *"k.seankhliao.com" | string
}
output: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name: context.appName
		labels: {
			"app.kubernetes.io/name":       context.name
			"app.kubernetes.io/instance":   context.appName
			"app.kubernetes.io/version":    context.appRevision
			"app.kubernetes.io/managed-by": "kubevela"
		}
	}
	spec: {
		selector: matchLabels: {
			"app.kubernetes.io/name":     context.name
			"app.kubernetes.io/instance": context.appName
		}
		revisionHistoryLimit: 1
		strategy: rollingUpdate: maxSurge: "25%"
		template: {
			metadata: {
				labels: {
					"app.kubernetes.io/name":       context.name
					"app.kubernetes.io/instance":   context.appName
					"app.kubernetes.io/version":    context.appRevision
					"app.kubernetes.io/managed-by": "kubevela"
				}
			}
			spec: {
				enableServiceLinks:            false
				terminationGracePeriodSeconds: 10
				serviceAccountName:            context.appName
				containers: [{
					name:  context.name
					image: parameter.image
					ports: [{
						name:          "http"
						containerPort: parameter.port
					}]
				}]
			}
		}
	}
}
outputs: serviceaccount: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name: context.appName
		labels: {
			"app.kubernetes.io/name":       context.name
			"app.kubernetes.io/instance":   context.appName
			"app.kubernetes.io/version":    context.appRevision
			"app.kubernetes.io/managed-by": "kubevela"
		}
	}
}
outputs: service: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: context.appName
		labels: {
			"app.kubernetes.io/name":       context.name
			"app.kubernetes.io/instance":   context.appName
			"app.kubernetes.io/version":    context.appRevision
			"app.kubernetes.io/managed-by": "kubevela"
		}
	}
	spec: {
		type: "ClusterIP"
		ports: [{
			name:       "http"
			port:       80
			targetPort: parameter.port
		}]
		selector: {
			"app.kubernetes.io/name":     context.name
			"app.kubernetes.io/instance": context.appName
		}
	}
}
outputs: virtualservice: {
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "VirtualService"
	metadata: {
		name: context.appName
		labels: {
			"app.kubernetes.io/name":       context.name
			"app.kubernetes.io/instance":   context.appName
			"app.kubernetes.io/version":    context.appRevision
			"app.kubernetes.io/managed-by": "kubevela"
		}
	}
	spec: {
		hosts: [context.appName + "." + parameter.domain]
		gateways: ["mesh", context.appName]
		http: [{
			route: [{
				destination: {
					host: context.appName + "." + context.namespace + ".svc.cluster.local"
					port: number: 80
				}
			}]
		}]
	}
}
outputs: gateway: {
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "Gateway"
	metadata: {
		name: context.appName
		labels: {
			"app.kubernetes.io/name":       context.name
			"app.kubernetes.io/instance":   context.appName
			"app.kubernetes.io/version":    context.appRevision
			"app.kubernetes.io/managed-by": "kubevela"
		}
	}
	spec: {
		selector: istio: "ingressgateway"
		servers: [{
			hosts: [context.appName + "." + parameter.domain]
			port: {
				name:     "https-" + context.name
				number:   443
				protocol: "HTTPS"
			}
			tls: {
				mode:               "SIMPLE"
				credentialName:     "k-tls"
				minProtocolVersion: "TLSV1_3"
			}
		}, {
			hosts: [context.appName + "." + parameter.domain]
			port: {
				name:     "http-" + context.name
				number:   80
				protocol: "HTTP"
			}
			tls: httpsRedirect: true
		}]
	}
}
