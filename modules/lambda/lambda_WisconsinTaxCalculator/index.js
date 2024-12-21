'use strict';
console.log('Loading Wisconsin tax calculator function...');
const WI_STATE_TAX_RATE = 10; // cheaper than California
exports.handler = (event, context, callback) => {
    console.log('Received event: ', JSON.stringify(event, null,
        2));
    try {
        console.log(`Product price: $${event.price}`);
        console.log(`Calculating Wisconsin state taxes at${WI_STATE_TAX_RATE} rate`)
        let stateTax = event.price * (WI_STATE_TAX_RATE /
            100.00);
        let finalPrice = event.price + stateTax;
        console.log(`Final price with tax: $${finalPrice}`);
        // On success, invoke the callback like so (2 arguments)
        // first one being null.
        callback(null, finalPrice); // Return calculated tax
    }
    catch (e) {
        console.log(e);
        // On failure, invoke the callback like so (a singleargument)
        // with a helpful error message.
        callback('ERROR: Something went wrong!');
    }
    console.log("Done calculating Wisconsin tax.");
};