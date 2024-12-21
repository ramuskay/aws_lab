'use strict';
console.log('Loading California tax calculator function...');
const CA_STATE_TAX_RATE = 20;
exports.handler = (event, context, callback) => {
    console.log('Received event: ', JSON.stringify(event, null,
        2));
    try {
        console.log(`Product price: $${event.price}`);
        console.log(`Calculating California state taxes at
${CA_STATE_TAX_RATE} rate`)
        let stateTax = event.price * (CA_STATE_TAX_RATE /
            100.00);
        let finalPrice = event.price + stateTax;
        console.log(`Final price with tax: $${finalPrice}`);
        // On success, invoke the callback like so (2 arguments)
        // first one being null.
        callback(null, finalPrice); // Return calculated tax
    }
    catch (e) {
        console.log(e);
// On failure, invoke the callback like so (a single argument)
        // with a helpful error message.
        callback('ERROR: Something went wrong!');
    }
    console.log("Done calculating California tax.");
};