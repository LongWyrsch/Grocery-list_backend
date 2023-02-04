const testRecipe = require('../testData/testRecipe')

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

describe('PUT /recipes', () => {
	it('adds a new recipe', async () => {
		res = await request(app)
			.put('/recipes')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, ingredients: testRecipe });
		expect(res.status).toEqual(200);

		res = await request(app).get('/recipes').set('Cookie', [cookie]);
		expect(res.body[0][0].title).toEqual('Beef pie')
	});
});

describe('GET /recipes', () => {
	it('rejects unauthenticated requests', async () => {
		// GET request without cookie
		res = await request(app).get('/recipes');
		expect(res.status).toEqual(401);
	});

	it("returns an authenticated user's recipes", async () => {
		// GET request without cookie
		res = await request(app).get('/recipes').set('Cookie', [cookie]);
		expect(res.status).toEqual(200);
	});
});

describe('POST /recipes/join', () => {
	it('rejects requests with input other than UUIDs', async () => {
		res = await request(app)
			.post('/recipes/join')
			.set('Cookie', [cookie])
			// .send({ CSRF_token: CSRF_token, selectedRecipes: ['9d9995e2-ac8a-4f5a-8485-801d17143e4f'] });
			.send({ CSRF_token: CSRF_token, selectedRecipes: ['invalidUUID'] });
		expect(res.status).toEqual(400);
		// expect(res.body.length).toBe(13)
	});
	it('returns ingredients from selected recipes', async () => {
		res = await request(app)
			.post('/recipes/join')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, selectedRecipes: ['61621a51-3ae1-4b87-b7de-42261cf174ec'] });
		expect(res.status).toEqual(200);
		expect(res.body.length).toBe(14);
	});
});



describe('PUT /recipes/delete', () => {
	it('deletes an ingredient from a recipe', async () => {
		res = await request(app)
			.put('/recipes/delete')
			.set('Cookie', [cookie])
			.send({ 
				CSRF_token: CSRF_token, 
				row_uuid: ['d6573e1f-9ed9-41a8-9944-c4ae0bfba288'], 
				card_uuid: null
			});
			
		expect(res.status).toEqual(200);

		// Check that one ingredient has been deleted
		res = await request(app).get('/recipes').set('Cookie', [cookie]);
		expect(res.body[0].length).toEqual(13)
	});

	it('deletes a recipe', async () => {
		res = await request(app)
			.put('/recipes/delete')
			.set('Cookie', [cookie])
			.send({ 
				CSRF_token: CSRF_token, 
				row_uuid: null, 
				card_uuid: '61621a51-3ae1-4b87-b7de-42261cf174ec'
			});
			
		expect(res.status).toEqual(200);

		res = await request(app).get('/recipes').set('Cookie', [cookie]);
		expect(res.status).toEqual(204)
	});
});
