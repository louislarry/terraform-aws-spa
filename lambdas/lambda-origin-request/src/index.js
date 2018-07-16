// lambda-origin-request
// @ts-check

const path = require("path");
const { STATUS_CODES } = require("http");

exports.handler = (event, context, callback) => {
  const { request } = event.Records[0].cf;
  const parsedPath = path.parse(request.uri);

  return callback(null, request);
};

function redirectTo(uri) {
  return {
    status: "301",
    statusDescription: STATUS_CODES["301"],
    headers: {
      location: [{ key: "Location", value: uri }]
    }
  };
}
