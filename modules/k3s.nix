{ name, config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  services.k3s = {
    enable = true;
    role = "server";

    disable = [
      "traefik" # we maintain our own version
    ];

    autoDeployCharts.traefik2 = {
      repo = "https://traefik.github.io/charts";
      name = "traefik";
      version = "37.4.0";
      hash = "sha256-BIGagu9qqQ7ijloBJp5bRBQUnVhcO8k4tmr6ZNx4pZU=";
      targetNamespace = "traefik";
      createNamespace = true;

      values = {
        additionalArguments = [
          "--entryPoints.websecure.http.tls.certResolver=letsencrypt"
          "--certificatesresolvers.letsencrypt.acme.caServer=https://acme-v02.api.letsencrypt.org/directory"
          "--certificatesresolvers.letsencrypt.acme.email=it@fluufff.org"
          "--certificatesresolvers.letsencrypt.acme.httpChallenge.entryPoint=web"
          "--certificatesresolvers.letsencrypt.acme.storage=/data/acme.json"
        ];
        ingressRoute = {
          dashboard = {
            enabled = true;
            matchRule = "Host(`traefik.next.fluufff.org`)";
            entryPoints = ["websecure"];
            middlewares = [{
              name = "google-oauth";
              namespace = "traefik";
            }];
          };
        };
        extraObjects = [
          {
            apiVersion = "traefik.io/v1alpha1";
            kind = "Middleware";
            metadata = {
              name = "google-oauth";
              namespace = "traefik";
            };
            spec = {
              forwardAuth = {
                address = "http://google-oauth.traefik";
                trustForwardHeader = true;
                authResponseHeaders = [
                  "X-Forwarded-User"
                ];
              };
            };
          }
          {
            apiVersion = "apps/v1";
            kind = "Deployment";
            metadata = {
              name = "google-oauth";
              namespace = "traefik";
            };
            spec = {
              replicas = 1;
              selector = {
                matchLabels = {
                  app = "google-oauth";
                };
              };
              template = {
                metadata = {
                  labels = {
                    app = "google-oauth";
                  };
                };
                spec = {
                  containers = [{
                    name = "traefik-forward-auth";
                    image = "thomseddon/traefik-forward-auth:2";
                    env = [
                      # These depend on `traefik-secret.yaml`
                      # being manually applied to the cluster.
                      {
                        name = "PROVIDERS_GOOGLE_CLIENT_ID";
                        valueFrom = {
                          secretKeyRef = {
                            name = "auth";
                            key = "clientID";
                          };
                        };
                      }
                      {
                        name = "PROVIDERS_GOOGLE_CLIENT_SECRET";
                        valueFrom = {
                          secretKeyRef = {
                            name = "auth";
                            key = "clientSecret";
                          };
                        };
                      }
                      {
                        name = "SECRET";
                        valueFrom = {
                          secretKeyRef = {
                            name = "auth";
                            key = "cookieSecret";
                          };
                        };
                      }
                      {
                        name = "INSECURE_COOKIE";
                        value = "true";
                      }
                    ];
                  }];
                };
              };
            };
          }
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "google-oauth";
              namespace = "traefik";
            };
            spec = {
              ports = [{
                name = "http";
                targetPort = 4181;
                port = 80;
              }];
              selector = {
                app = "google-oauth";
              };
            };
          }
        ];
      };
    };

    autoDeployCharts.argocd = {
      repo = "https://argoproj.github.io/argo-helm";
      name = "argo-cd";
      version = "9.1.4";
      hash = "sha256-JUeUjNwtVo/87q8zk5efNLmN4+y/J+C/5WDEy8VnNUY=";
      targetNamespace = "argocd";
      createNamespace = true;
      values = {
        global = {
          domain = "argocd.next.fluufff.org";
        };
        configs = {
          params = {
            "server.insecure" = "true";
          };
          cm = {
            url = "https://argocd.next.fluufff.org";
            "admin.enabled" = false;
            "dex.config" = ''
              connectors:
              - config:
                  issuer: https://accounts.google.com
                  # These depend on `argocd-secret.yaml`
                  # being manually applied to the cluster.
                  clientID: $oidc.google.clientID
                  clientSecret: $oidc.google.clientSecret
                  insecureSkipVerify: true
                type: oidc
                id: google
                name: Google
              '';
            # Backup config for use in case of Dex troubles.
            # "oidc.config" = ''
            #   name: Google
            #   issuer: https://accounts.google.com
            #   clientID: $oidc.google.clientID
            #   clientSecret: $oidc.google.clientSecret
            #   requestedScopes: ["openid", "profile", "email"]
            #   '';

          };
          rbac = {
            "policy.csv" = ''
              p, role:operator, applications, sync, *, allow
              p, role:operator, applications, get, *, allow
              p, role:operator, applicationsets, get, *, allow

              g, it@fluufff.org, role:admin
              g, juravenator@fluufff.org, role:admin
              g, proko@fluufff.org, role:admin
              g, niki@fluufff.org, role:operator
              '';
          };
          secret = {
            createSecret = false;
          };
        };
        server = {
          ingress = {
            enabled = true;
          };
        };
      };
    };
  };
}
