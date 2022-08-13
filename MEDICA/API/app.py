from flask import Flask, jsonify, request
import requests
import os
from twilio.rest import Client

app = Flask(__name__)
@app.route('/api', methods = ['GET'])

def return_hospitals():
    URL = "https://discover.search.hereapi.com/v1/discover"
    # latitude = request.args.get('lat')
    latitude = 31.7814767 #hardcoded for testing
    # longitude = str(request.args.get('long'))
    longitude = 76.9987996 #hardcoded for testing
    api_key = os.environ['API_HERAPI']
    query = 'hospital'
    limit = 5

    PARAMS = {
                'apikey':api_key,
                'q':query,
                'limit': limit,
                'at':'{},{}'.format(latitude,longitude)
            }

    r = requests.get(url = URL, params = PARAMS) 
    data = r.json()
    d_final = {}
    for i in range (0, 5):
        d_temp = {'name': data['items'][i]['title'], 'address': data['items'][i]['address']['label'], 
        'distance': data['items'][i]['distance']}
        d_final[i] = d_temp

    # hospitalOne = data['items'][0]['title']
    # hospitalOne_address =  data['items'][0]['address']['label']
    # hospitalOne_latitude = data['items'][1]['position']['lat']

    return d_final


def call():
    account_sid = os.environ['TWILIO_ACCOUNT_SID']
    auth_token = os.environ['TWILIO_AUTH_TOKEN']
    client = Client(account_sid, auth_token)

    string_1 = '<Response><Say>Location is ' +str(longitude)+' degrees, '+str(latitude)+ ' degrees</Say></Response>'

    call = client.calls.create(
                            twiml=string_1,
                            to=+918126568193,
                            from_=+15076075985
                        )

    return(call.sid)
    
if __name__ == '__main__':
	app.run(debug = False)