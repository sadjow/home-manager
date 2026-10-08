{ pkgs, ... }:

let
  # Sinkhole telemetry endpoints so no app on this machine can export to them.
  hostsFile = pkgs.writeText "hosts" ''
    ##
    # Host Database
    #
    # localhost is used to configure the loopback interface
    # when the system is booting.  Do not change this entry.
    ##
    127.0.0.1	localhost
    255.255.255.255	broadcasthost
    ::1             localhost

    127.0.0.1 otlp-gateway-prod-us-east-3.grafana.net
    ::1       otlp-gateway-prod-us-east-3.grafana.net
  '';
in
{
  # Determinate Nix manages its own daemon, avoid conflicts
  nix.enable = false;

  networking = {
    hostName = "codecraft";
    computerName = "codecraft";
    localHostName = "codecraft";
  };

  # mDNSResponder's sandbox only permits reading the literal /private/etc/hosts, so it
  # cannot follow the /etc/static symlink environment.etc would create into /nix/store.
  system.activationScripts.postActivation.text = ''
    if [[ -L /etc/hosts ]] || ! cmp -s ${hostsFile} /etc/hosts; then
      echo "installing /etc/hosts..." >&2
      install -m 644 -o root -g wheel ${hostsFile} /etc/hosts
    fi
  '';

  system.stateVersion = 5;
}
