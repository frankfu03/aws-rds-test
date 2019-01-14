let
  defaultPkgs = import <nixpkgs> {};
  pinnedPkgs = import (defaultPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "56fb68dcef4"; # 25 March 2018
    sha256 = "0im8l87nghsp4z7swidgg2qpx9mxidnc0zs7a86qvw8jh7b6sbv2";
  }) {};

in

{ nixpkgs ? pinnedPkgs, installDevTools ? false }:

let
  pkgs = if nixpkgs == null then defaultPkgs else pinnedPkgs;

  buildTools = with pkgs; [
    awscli
    awslogs
    #libuuid
    curl
    cacert
    #gcc
    git
    #jdk8
    jq
    #maven
    #ng
    #packer
    postgresql
    #plantuml
    terraform_0_11

    # TODO: Remove once https://github.com/awslabs/aws-request-signing-apache-interceptor/issues/2
    #wget
  ];

  devEnv = with pkgs; buildEnv {
    name = "devEnv";
    paths = buildTools ++ (if installDevTools then devTools else []);
  };
in
  pkgs.runCommand "setupEnv" {
    buildInputs = [
      devEnv
    ];
    shellHook = ''
      alias mvn="mvn -s$(pwd)/maven-settings.xml"
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      unset SOURCE_DATE_EPOCH
      if [ -e "./aws/aws-env.sh" ]; then
        . ./aws/aws-env.sh
      fi

      # workaround due to some bug in nixpkgs
      function credstash() {
        "${pkgs.pythonPackages.credstash}/bin/credstash.py" $@
      }
      export -f credstash

      git config core.hooksPath .githooks

      # show git branch in prompt
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }
      set_prompt() {
        export PS1="\n\[\033[1;32m\][nix-shell:\w]$(parse_git_branch)$\[\033[0m\] "
      }
      PROMPT_COMMAND=set_prompt
    '';
  } ""
