name        "ancarjs_app"
description "Installs ancarJS application"
maintainer  "Takafumi Miki"

depends "deploy"

recipe "ancarjs_app::setup", "Setup middlewares for ancarJS"
recipe "ancarjs_app::deploy", "Deploy ancarJS"
