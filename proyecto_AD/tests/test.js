import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    scenarios: {
        usuarios_100: {
            executor: 'constant-vus',
            vus: 100,
            duration: '3m',
        },
        usuarios_300: {
            executor: 'constant-vus',
            vus: 300,
            duration: '3m',
            startTime: '3m', // Empieza cuando termina el primero
        },
        usuarios_500: {
            executor: 'constant-vus',
            vus: 500,
            duration: '3m',
            startTime: '6m', // Empieza cuando termina el segundo
        },
    },
};

export default function () {
    const res = http.get('http://host.docker.internal:8080/');

    check(res, {
        'status es 200': (r) => r.status === 200,
    });

    sleep(1);
}
//docker run --rm -i -v "${PWD}:/scripts" grafana/k6 run /scripts/test.js
//docker stats