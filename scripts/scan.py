#!/usr/bin/env python3

use_requests = True
timeout = 5
lowest_port = 1
highest_port = 65535
percent_divider = int(highest_port / 100)
ports={}

import http.client
import socket
try:
    import requests
except ImportError:
    print('"requests" module was not found, importing native http client')
    use_requests = False

for port in range(lowest_port, highest_port):
    if not port % percent_divider:
        print('progress: ' + str(port / percent_divider))
    # requests variant
    if use_requests:
        try:
            r = requests.get(
                'http://portquiz.net:' + str(port),
                timeout=timeout
            )
            ports[port] = r.status_code == 200
        except requests.exceptions.ConnectionError:
            ports[port] = False
        except requests.exceptions.Timeout:
            ports[port] = False
        except requests.exceptions.HTTPError:
            # invalid http answer
            ports[port] = True
        continue

    # native variant
    connection = http.client.HTTPConnection(
        host='portquiz.net',
        port=port,
        timeout=timeout
    )
    try:
        connection.request(
            method='GET',
            url='/'
        )
        r = connection.getresponse()
        ports[port] = r.status == 200
    except ConnectionResetError:
        ports[port] = False
    except socket.timeout:
        ports[port] = False
    except http.client.BadStatusLine:
        # invalid http answer
        ports[port] = True

# write output
with open('port_list.txt', mode='w') as file:
    for port in sorted(ports.keys()):
        state = 'open' if ports[port] else 'closed'
        file.write(str(port) + '/tcp ' + state)
