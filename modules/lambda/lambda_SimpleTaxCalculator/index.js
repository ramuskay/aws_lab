'use strict';
console.log('Loading tax calculator function...');
exports.handler = (event, context, callback) => {
    console.log('Received event: ', JSON.stringify(event, null, 2));
    try {
        let productPrice, taxRate, surchargeRate = null;
        if (event.body !== null && event.body !== undefined) {
            let body = JSON.parse(event.body)
            productPrice = body.productPrice;
            taxRate = body.taxRate;
            surchargeRate = body.surchargeRate;
        }
        else {
            productPrice = event.productPrice;
            taxRate = event.taxRate;
            surchargeRate = event.surchargeRate;
        }
        console.log(`Product price: $${productPrice}`);
        console.log(`Tax rate: ${taxRate}%`);
        console.log(`Surcharge rate: ${surchargeRate}%`);
        
        let tax = productPrice * (taxRate / 100.00);
        let surcharge = productPrice * (surchargeRate / 100.00);
        let finalPrice = productPrice + tax + surcharge;
        console.log(`Final price with tax: $${finalPrice}`);
        let returnValue = {
            price: finalPrice,
            state: "CA"
        }
        var response = {
            statusCode: 200,
            headers: {
                "x-custom-header": "Some custom header value"
            },
            body: JSON.stringify(returnValue)
        };
        // On success, invoke the callback like so (2 arguments)
        // first one being null.
        callback(null, response); // Return calculated tax
    }
    catch (e) {
        console.log(e);
        // On failure, invoke the callback like so (a singleargument)
        // with a helpful error message.
        callback('ERROR: Something went wrong!');
    }
    console.log("Done calculating tax.");
};