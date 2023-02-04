const testList = require('../testData/testList')

const app = require('../../app');

const request = require('supertest');

let cookie;
let user;
let CSRF_token;

beforeAll(async () => {
	// Authenticate to get cookie
	let res = await request(app).post('/auth/local/signin').send({ email: process.env.TESTUSER_USERNAME, password: process.env.TESTUSER_PASSWORD });
	cookie = res.headers['set-cookie'];

	// Get CSRF_token
	res = await request(app).get('/users').set('Cookie', [cookie]);
	user = res.body;
	CSRF_token = user.CSRF_token;
});

afterAll(async () => {
	res = await request(app).get('/users/signout').set('Cookie', [cookie]);
});

describe('PUT /lists', () => {
	it('adds a new list', async () => {
		res = await request(app)
			.put('/lists')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, ingredients: testList });
		expect(res.status).toEqual(200);

		res = await request(app).get('/lists').set('Cookie', [cookie]);
		expect(res.body[0][0].title).toEqual('Italian')
	});
});

describe('GET /lists', () => {
	it('rejects unauthenticated requests', async () => {
		// GET request without cookie
		res = await request(app).get('/lists');
		expect(res.status).toEqual(401);
	});

	it("returns an authenticated user's lists", async () => {
		// GET request without cookie
		res = await request(app).get('/lists').set('Cookie', [cookie]);
		expect(res.status).toEqual(200);
	});
});

describe('PUT /lists/delete', () => {
	it('deletes an ingredient from a list', async () => {
		res = await request(app)
			.put('/lists/delete')
			.set('Cookie', [cookie])
			.send({ 
				CSRF_token: CSRF_token, 
				row_uuid: ['5604741f-d59b-41c4-abf5-de366c8332f3'], 
				card_uuid: null
			});
			
		expect(res.status).toEqual(200);

		// Check that one ingredient has been deleted
		res = await request(app).get('/lists').set('Cookie', [cookie]);
		expect(res.body[0].length).toEqual(19)
	});

	it('deletes a list', async () => {
		res = await request(app)
			.put('/lists/delete')
			.set('Cookie', [cookie])
			.send({ 
				CSRF_token: CSRF_token, 
				row_uuid: null, 
				card_uuid: '7a62da6c-74f9-4dbd-8991-ace77ba9e2f3'
			});
			
		expect(res.status).toEqual(200);

		res = await request(app).get('/lists').set('Cookie', [cookie]);
		expect(res.status).toEqual(204)
	});
});
