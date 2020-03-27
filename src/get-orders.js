'use strict';

// noinspection JSUnresolvedFunction
const AWS = require('aws-sdk');

const dynamoDb = new AWS.DynamoDB.DocumentClient();

// noinspection JSUnresolvedVariable
module.exports.getOrders = (event, context, callback) => {
    const timestamp = new Date().getTime();
    const body = event.body;

    // noinspection JSUnresolvedVariable
    const params = {
        TableName: process.env.DYNAMO_TABLE,
        Item: {
            orderId: event.requestContext.requestId,
            customerId: body.customerId,
            creationDate: timestamp
        }
    };

    dynamoDb.put(params, (error) => {
        // handle potential errors
        if (error) {
            console.error(error);
            callback(null, {
                statusCode: error.statusCode || 501,
                headers: {'Content-Type': 'text/plain'},
                body: 'Couldn\'t create the request.',
            });
            return;
        }

        // create a response
        const response = {
            statusCode: 200,
            body: JSON.stringify(params.Item),
        };
        callback(null, response);
    });
};