const app = require('../../app')
// .withCredentials()

const request = require('supertest');

const jsdom = require('jsdom');
const { JSDOM } = jsdom;

// Function using jsdom to return HTML element.
const parseTextFromHTML = (htmlAsString, selector) => {
    const selectedElement = new JSDOM(htmlAsString).window.document.querySelector(selector);
    if (selectedElement !== null) {
        return selectedElement.textContent;
    } else {
        throw new Error(`No element with selector ${selector} found in HTML string`);
    }
};

describe('user authentication', () => {
	it('rejects authentication requests with missing credentials', async () => {
        let res = await request(app)
            .post('/signin')
            .set('Content-Type', 'application/json')
            .send({email: ''})
            .expect(400)
        
            // expect(res.status).toEqual(400)

    });
	it('rejects authentication requests with empty credentials', async () => {

    });
	it('rejects authentication requests with credentials shorter than 6 characters', async () => {

    });
	it('rejects authentication requests with credentials with a backslash character', async () => {

    });
	it('rejects authentication requests with an unknown email', async () => {

    });
	it('rejects authentication requests with an unmatched password', async () => {

    });
	it('successfully authenticates valid user credentials', async () => {

    });
});
