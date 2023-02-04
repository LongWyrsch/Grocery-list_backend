const app = require('../../app');

const request = require('supertest');

let cookie;
let user;
let CSRF_token;

beforeEach(async () => {
	// Authenticate to get cookie
	let res = await request(app).post('/auth/local/signin').send({ email: process.env.TESTUSER_USERNAME, password: process.env.TESTUSER_PASSWORD });
	cookie = res.headers['set-cookie'];

	// Get CSRF_token
	res = await request(app).get('/users').set('Cookie', [cookie]);
	user = res.body;
	CSRF_token = user.CSRF_token;
});

afterEach(async () => {
	res = await request(app).get('/users/signout').set('Cookie', [cookie]);
});

describe('GET /users', () => {
	it('rejects unauthenticated requests', async () => {
		let res = await request(app).get('/users').send({ email: process.env.TESTUSER_USERNAME });
		expect(res.status).toEqual(401);
	});
	it('returns a user with object CSRF token upon successfull authentication', async () => {
		// Authenticate to get cookie
		res = await request(app).get('/users').set('Cookie', [cookie]);
		expect(res.status).toEqual(200);
		expect(res.body.email).toEqual(process.env.TESTUSER_USERNAME);
		expect(res.body.language).toEqual('en');
		expect(res.body.theme).toEqual('light');
		expect(res.body.CSRF_token).toBeDefined;
	});
});

describe('GET /users/signout', () => {
	it('rejects unauthenticated requests', async () => {
		let res = await request(app).get('/users/signout');
		expect(res.status).toEqual(401);
	});
	it('signs an authenticated user out', async () => {
		res = await request(app).get('/users/signout').set('Cookie', [cookie]);
		expect(res.status).toEqual(200);
	});
});

describe('PUT /users', () => {
	it('rejects unauthenticated requests', async () => {
		// PUT request without cookie
		res = await request(app)
			.put('/users')
			.send({ CSRF_token: CSRF_token, updatedUser: { avatar_variant: 'pixel' } });
		expect(res.status).toEqual(401);
	});

	it('rejects authenticated requests without CSRF token', async () => {
		// PUT request without CSRF token
		res = await request(app)
			.put('/users')
			.set('Cookie', [cookie])
			.send({ updatedUser: { avatar_variant: 'pixel' } });
		expect(res.status).toEqual(401);
	});

	it('rejects requests with valid credentials and invalid updatedUser values', async () => {
		// PUT request with invalid user input
		res = await request(app)
			.put('/users')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, updatedUser: { avatar_variant: 'invalidValue' } });
		expect(res.status).toEqual(400);
	});

	it('rejects requests with valid credentials updating email to already-existing one', async () => {
		// PUT request to change email to an already existing one
		res = await request(app)
			.put('/users')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, updatedUser: { email: process.env.REACT_APP_ADMINEMAIL } });
		expect(res.status).toEqual(403);
	});

	it('updates the user info successfully', async () => {
		// PUT request to change avatar variant
		res = await request(app)
			.put('/users')
			.set('Cookie', [cookie])
			.send({ CSRF_token: CSRF_token, updatedUser: { avatar_variant: 'sunset' } });
		expect(res.status).toEqual(200);

		// Check that avatar variant has been changed
		res = await request(app).get('/users').set('Cookie', [cookie]);
		expect(res.body.avatar_variant).toEqual('sunset');
	});
});
