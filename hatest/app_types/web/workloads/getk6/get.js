import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  discardResponseBodies: true,
  scenarios: {
    contacts: {
      executor: 'constant-arrival-rate',

      // Our test should last 30 seconds in total
      duration: '30s',

      // It should start 30 iterations per `timeUnit`. Note that iterations starting points
      // will be evenly spread across the `timeUnit` period.
      rate: 10,

      // It should start `rate` iterations per second
      timeUnit: '1s',

      // It should preallocate 2 VUs before starting the test
      preAllocatedVUs: 2,

      // It is allowed to spin up to 50 maximum VUs to sustain the defined
      // constant arrival rate.
      maxVUs: 50,
    },
  },
};

export default function () {
  const params = {
    timeout: 10,
    tags: {phase: "blah"}
  };
  const timestamp = new Date().toISOString();
  const probe = __VU * 100000 + __ITER + 1;
  const res = http.get(`http://localhost:8080/user/1?probe=${probe}`, params);
  code = "unexpected";
  switch (res.status) {
    case 500:
      code = "http500";
      break;
    case 200:
      code = "http200";
      break;
    case 404:
      code = "http404";
      break;
    case 0:
      if (res.error == "request timeout") code="timeout";
      break;
  }
  console.log(
    `timestamp=${timestamp} ` +
    `probe=${probe} ` +
    `latency=${res.timings.duration/1000.0} ` + 
    `code=${code} ` +
    `http_status=${res.status} ` +
    `status_text="${res.status_text}" ` +
    `error="${res.error}" ` +
    `error_code=${res.error_code}`);
}
