
# docker-compose-wait

Some useful script to wait until all services declared in a docker-compose file are up and running.

This script uses the health check mechanism provided since Docker 1.12. If your services have a configured health check, after making a `docker-compose up -d` you can simply call this script to have it wait until all your services health statuses are fixed. If they are all `healthy` it will return `0` if any of them is `unhealthy` (or `Down`) it will return -1.

This script can be useful, as example, in Continuous Integration or other situations when you just want to wait until a stack is deployed before performing other actions.

<aside class="notice">
Please note this script does not do anything about dependencies startup order.
</aside>
