import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    vus: 500,
    duration: '3m',
};

export default function () {

    let res = http.get('http://host.docker.internal:8080/');

    check(res, {
        'status es 200': (r) => r.status === 200,
    });

    sleep(1);
}

//docker run --rm -i -v "${PWD}:/scripts" grafana/k6 run /scripts/test.js