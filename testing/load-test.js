import http from 'k6/http';
import { check, sleep } from 'k6';

// Test configuration
export const options = {
    stages: [
        { duration: '30s', target: 25 },   // Ramp up to 25 users in 30 seconds
        { duration: '1m', target: 50 },   // Stay at 50 users for 1 minute
        { duration: '20s', target: 0 },    // Ramp down to 0 users in 20 seconds
    ],
};

// Main test - runs for each virtual user
export default function () {
    // Test both endpoints randomly
    const urls = [
        'http://bar.localhost:30080/',
        'http://foo.localhost:30080/',
    ];
    
    const url = urls[Math.floor(Math.random() * urls.length)];
    const res = http.get(url);
    check(res, {
        'is status 200': (r) => r.status === 200,  // Check if status is 200
        'is response time < 200ms': (r) => r.timings.duration < 200, // Check if response time is under 200ms
    });

    sleep(1);  // Wait 1 second between requests
}
