name        "ancar_app"
description "Installs ancar(backend) application"
maintainer  "Takafumi Miki"

depends "deploy"

recipe "ancar_app::setup", "Setup middlewares for ancar(backend)"
#recipe "ancar_app::deploy", "Deploy ancar(backend)"
