#!/usr/bin/env bash
echo "deploying flyway layer..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}/../..
PROJECT_DIR=$(pwd)
echo ${PROJECT_DIR}

OUTPUT_DIR=${PROJECT_DIR}/output/flyway

if [[ -d ${OUTPUT_DIR} ]]; then
    rm -rf ${OUTPUT_DIR}
fi

mkdir -p "${OUTPUT_DIR}"


CONFIG_FILE="${PROJECT_DIR}/.env-${APP_ENVIRONMENT}-${APP_VERSION}"

source ${CONFIG_FILE}

FlywayVersion="5-2-4"
deploytime=`date +%Y%m%d%H%M%S`
CODE_PREFIX="flyway-${FlywayVersion}-${deploytime}"

cd ${OUTPUT_DIR}
curl https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.2.4/flyway-commandline-5.2.4-linux-x64.tar.gz -o flyway-commandline-5.2.4-linux-x64.tar.gz
tar xzf flyway-commandline-5.2.4-linux-x64.tar.gz
chmod -R 777 flyway-5.2.4/
zip flyway.zip $(tar tf flyway-commandline-5.2.4-linux-x64.tar.gz)

aws s3 cp ${OUTPUT_DIR}/flyway.zip s3://${CODE_BUCKET}/${CODE_PREFIX}/
aws cloudformation deploy \
    --stack-name ${APP_NAME}-${SERVICE_NAME}-flyway-${FlywayVersion}-${APP_ENVIRONMENT}-${APP_VERSION} \
    --template-file ${PROJECT_DIR}/cfn/flyway.yaml \
    --s3-bucket ${CODE_BUCKET} \
    --s3-prefix ${CODE_PREFIX} \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        CodeBucket=${CODE_BUCKET} \
        CodePrefix=${CODE_PREFIX} \
        AppName=${APP_NAME} \
        Environment=${APP_ENVIRONMENT} \
        ServiceName=${SERVICE_NAME} \
        AppVersion=${APP_VERSION} \
        FlywayVersion=${FlywayVersion} \
    --no-fail-on-empty-changeset