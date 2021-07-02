
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello world!',
        'headers': {
            'Content-Type': 'application/json'
        }
    }
