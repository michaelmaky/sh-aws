RESOURCE_ID_OLD=$1
RESOURCE_ID_NEW=$2
AWS_ACCOUNT='123456789012'
AWS_REGION='ap-southeast-1'

EXPRESSION="arn:aws:rds-db:${AWS_REGION}:${AWS_ACCOUNT}:dbuser:${RESOURCE_ID_OLD}/db_user"
echo 'Expression is:' \n ${EXPRESSION}''

if jq -e '.Statement[] | if .Resource | type == "array" then select(.Resource[] | contains("'$EXPRESSION'")) else select(.Resource |="'$EXPRESSION'") end' policy.json > /dev/null; then
# if jq -e '.Statement[] | select(.Resource[] | contains("'$EXPRESSION'"))' policy.json > /dev/null; then
  echo "ARN found, replace resource in policy..."
  jq '.Statement[] | if .Resource | type == "array" then .Resource[] = "arn:aws:rds-db:${AWS_REGION}:${AWS_ACCOUNT}:dbuser:'"$RESOURCE_ID_NEW"'/db_user" else .Resource = "arn:aws:rds-db:${AWS_REGION}:${AWS_ACCOUNT}:dbuser:'"$RESOURCE_ID_NEW"'/db_user" end' policy.json > policy-new.json && mv policy-new.json policy.json
else
  echo "ARN not found"
fi




