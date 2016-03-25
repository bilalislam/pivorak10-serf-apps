# This repo includes Serf in action demo suite.

## DB maintenance demo

[db-maintenance-demo](https://github.com/romanvbabenko/pivorak10-serf-apps/tree/master/db-maintenance-demo) folder
includes Vagrant config to run simple web app cluster demo. It consists of DB and App nodes.

Run `$ ./build.sh` to create and provision nodes.

Open http://192.168.33.10 in your browser and see hello from app

Then try to bringing DB node down by running `$ vagrant halt db` and refresh page in your browser.
You will see a fancy DB maintenance page

Bring the DB node up again by running `$ vagrant up db` and refresh page again and see Hello from app again.

[![Serf in action](https://img.youtube.com/vi/U1jOrtCHvxo/0.jpg)](https://www.youtube.com/watch?v=U1jOrtCHvxo)

## Code snippets

[snippets](https://github.com/romanvbabenko/pivorak10-serf-apps/tree/master/snippets) folder includes code snippets
(configs and handler scripts) DB maintenance demo, load balancer config with automatic upstream list update and 
Serf custom events and queries demo

## User query demo

![user-query-demo](https://github.com/romanvbabenko/pivorak10-serf-apps/tree/master/user-query-demo) folder
includes Vagrant config to run Serf's custom events and queries demo.

Start Vagrant nodes:
`$ vagrant up`

SSH into one of nodes:

`$ vagrant ssh n0`

Run `date` query:

`$ serf query date`

Run `hello` query:

`$ serf query hello`

Try to dispatch `deploy` event:

`$ serf event deploy "{\"version\": \" a00d163\", \"branch\": \"master\"}"`

Then SSH into n1 node:

`$ vagrant ssh n1`

And see the deploy event has been processed:

`$ cat /var/log/upstart/serf-agent.log`

[![Serf in action](https://img.youtube.com/vi/PbGEubFCJ5g/0.jpg)](https://www.youtube.com/watch?v=PbGEubFCJ5g)
