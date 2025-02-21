import os
import base64
import json
from auth0.v3.authentication import GetToken
from auth0.v3.management import Users
import boto3

sns_client = boto3.client('sns')


def get_auth0_user_client():
    tenant_domain = os.environ.get('AUTH0_TENANT_DOMAIN')
    client_id = os.environ.get('AUTH0_CLIENT_ID')
    client_secret = os.environ.get('AUTH0_CLIENT_SECRET')
    get_token = GetToken(tenant_domain)
    token = get_token.client_credentials(client_id, client_secret, 'https://{}/api/v2/'.format(tenant_domain))
    return Users(tenant_domain, token['access_token'])


def get_default_account_id(auth0_user_client, system, user_id):
    user = auth0_user_client.get(id=user_id, fields=['user_metadata'], include_fields=True)
    if system == 'BackOffice':
        return str(0)
    elif system == 'Public Water Systems':
        default_account_key = 'PWSDefaultAccountId'
    elif system == 'State Dashboard':
        default_account_key = 'StateDashboardDefaultAccountId'
    elif system == 'PWSPureView':
        default_account_key = 'PWSPureViewDefaultAccountId'
    elif system == 'Facilities':
        default_account_key = 'SchoolsDefaultAccountId'
    else:
        default_account_key = ''
    if 'user_metadata' in user and default_account_key in user['user_metadata']:
        return str(user['user_metadata'][default_account_key])
    return str(0)


def get_system(data):
    if 'client_name' in data and data['client_name'] != '':
        return data['client_name']
    return 'auth0'


def get_application(system):
    if system == 'BackOffice':
        return 'backoffice'
    elif system == 'Public Water Systems':
        return 'pws'
    elif system == 'State Dashboard':
        return 'stateportal'
    elif system == 'PWSPureView':
        return 'pwspureview'
    elif system == 'Facilities':
        return 'facilities'
    else:
        return ''


def get_description(type, data):
    description = data['description'] if 'description' in data else ''
    if type == 'slo' and description == '':
        return 'logout successful'
    if type == 'flo' and description == '':
        return 'logout failed'
    if type in ['s', 'sepft'] and description == '':
        return 'login successful'
    if type in ['f', 'fp' 'fu', 'fepft'] and description == '':
        return 'login failed'
    return description


def get_category(event_type):
    if event_type in ['sertft', 'fertft', 'srrt']:
        return 'token'
    if event_type in ['f', 's', 'fp', 'fu', 'sepft', 'fepft']:
        return 'login'
    if event_type in ['flo', 'slo']:
        return 'logout'
    if event_type in ['ssa', 'fsa']:
        return 'silent_auth'
    return 'unknown'


def get_subcategory(event_type):
    if event_type.startswith('s'):
        return 'success'
    if event_type.startswith('f'):
        return 'failure'
    return 'unknown'


def send_message_to_events_topic(json_data, account_id, system, status):
    event_type = json_data['detail']['data']['type']
    category = get_category(event_type)
    if category == 'silent_auth':
        category = 'account_switch'
    if category == 'login' or category == 'logout' or category == 'account_switch':
        auth_id = json_data['detail']['data']['user_id'] if 'user_id' in json_data['detail']['data'] else ''
        auth_email = json_data['detail']['data']['user_name'] if 'user_name' in json_data['detail']['data'] else ''
        message = [{
            "definitionVersion": "1",
            "application": get_application(system),
            "accountId": account_id,
            "userAuthId": auth_id,
            "userEmail": auth_email,
            "event": category,
            "subject": category,
            "eventTimestamp": json_data['time'] if 'time' in json_data else '',
            "data": {
                "status": status,
                "message": get_description(event_type, json_data['detail']['data'])
            }
        }]
        sns_client.publish(TopicArn=os.environ.get('SNS_AUDIT_TOPIC'),
                           Message=json.dumps(message),
                           MessageGroupId=auth_id.replace("|", "-"))


def lambda_handler(event, context):
    auth0_user_client = get_auth0_user_client()
    response = []
    for record in event['records']:
        # Kinesis data is base64 encoded so decode here
        payload = base64.b64decode(record["data"]).decode('utf-8')
        json_data = json.loads(payload)
        user_id = json_data['detail']['data']['user_id'] if 'user_id' in json_data['detail']['data'] else ''
        user_email = json_data['detail']['data']['user_name'] if 'user_name' in json_data['detail']['data'] else ''
        event_type = json_data['detail']['data']['type']
        if user_id != '' and event_type not in ['seacft', 'seccft']:
            system = get_system(json_data['detail']['data'])
            account_id = get_default_account_id(auth0_user_client, system, user_id)
            status = get_subcategory(event_type)
            send_message_to_events_topic(json_data, account_id, system, status)
            response_data = ''
            response_data += account_id + "||"
            response_data += system+ "||"
            response_data += get_category(event_type) + "||"
            response_data += status + "||"
            response_data += 'user' + "||"
            response_data += user_id + "||"
            response_data += user_id + "||"
            response_data += get_description(event_type, json_data['detail']['data']) + "||"
            response_data += json_data['detail']['data']['date'] + "||"
            response_data += payload + "||"
            response_data += user_email + "\n"
            response.append({
                'recordId': record['recordId'],
                'result': 'Ok',
                'data': base64.b64encode(response_data.encode('utf-8'))
            })
        else:
            response.append({
                'recordId': record['recordId'],
                'result': 'Dropped',
                'data': base64.b64encode(payload.encode('utf-8')).decode('utf-8')
            })
    return {'records': response}
