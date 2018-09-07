#!/usr/bin/env bash
set -e -x

oc login -u developer -p developer
oc project myproject

APP=app

# || true to make it idempotent
oc new-build --binary --name=${APP} -l app=${APP} || true

mvn -s settings.xml clean dependency:copy-dependencies compile -DincludeScope=runtime

oc start-build ${APP} --from-dir=. --follow

# || true to make it idempotent
oc new-app ${APP} -l app=${APP} || true
# || true to make it idempotent
oc expose service ${APP} || true