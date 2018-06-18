// lambda-rewrite
// @ts-check

const path = require('path');
const { STATUS_CODES } = require('http');

exports.handler = (event, context, callback) => {
  const { request } = event.Records[0].cf;
  const parsedPath = path.parse(request.uri);

  const isAsset = /assets/.test(request.uri);
  const isBagubagu = /bagubagu/.test(request.uri);

  if (isAsset) {
    return callback(null, request);
  }

  if (parsedPath.ext === '') {
    return callback(null, { ...request, uri: '/index.html' });
  }

  // easter egg
  if (isBagubagu) {
    const redirect = redirectTo('https://bagubagu.com');
    return callback(null, redirect);
  }

  return callback(null, request);
};

function addBagubaguHeader(headers) {
  return {
    ...headers,
    'x-bagubagu': [
      { key: 'X-Bagubagu', value: 'We are hiring! bagubagu.com/jobs' }
    ]
  };
}

function redirectTo(uri) {
  return {
    status: '301',
    statusDescription: STATUS_CODES['301'],
    headers: {
      location: [{ key: 'Location', value: uri }]
    }
  };
}
