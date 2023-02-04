const app = require('../../app');

const request = require('supertest');

describe('user signin process', () => {
	it('rejects signin requests with missing credentials', async () => {
		let res = await request(app)
			.post('/auth/local/signin')
			// .set('Access-Control-Allow-Credentials', 'true')
			// .set('Origin', 'http://localhost:3001/signin')
			// .set('Content-Type', 'application/json')
			.send({ email: process.env.TESTUSER_USERNAME });
		expect(res.status).toEqual(400);
	});
	it('rejects signin requests with empty credentials', async () => {
		let res = await request(app).post('/auth/local/signin').send({ email: '', password: process.env.TESTUSER_PASSWORD });
		expect(res.status).toEqual(400);
	});
	it('rejects signin requests with credentials shorter than 6 characters', async () => {
		let res = await request(app).post('/auth/local/signin').send({ email: '1234', password: process.env.TESTUSER_PASSWORD });
		expect(res.status).toEqual(400);
	});
	it('rejects signin requests with an unknown email', async () => {
		let res = await request(app).post('/auth/local/signin').send({ email: 'inexistentEmail', password: process.env.TESTUSER_PASSWORD });
		expect(res.status).toEqual(403);
	});
	it('rejects signin requests with an unmatched password', async () => {
		let res = await request(app).post('/auth/local/signin').send({ email: process.env.TESTUSER_USERNAME, password: 'inexistentPassword' });
		expect(res.status).toEqual(403);
	});
	it('successfully sign in user with valid credentials', async () => {
		let res = await request(app).post('/auth/local/signin').send({ email: process.env.TESTUSER_USERNAME, password: process.env.TESTUSER_PASSWORD })
        expect(res.status).toEqual(200)
	});
});

describe('user signup process', () => {
	it('rejects signup requests with invalid language or theme', async () => {
		let res = await request(app)
            .post('/auth/local/signup')
            .send({ 
                email: 'validUsername', 
                password: 'validPassword',
                language: 'invalidLanguage',
                theme: 'invalidTheme' 
            });
            expect(res.status).toEqual(400)
    });
	it('rejects signup requests with already-existing email', async () => {
        let res = await request(app)
        .post('/auth/local/signup')
        .send({ 
            email: process.env.TESTUSER_USERNAME, 
            password: 'validPassword',
            language: 'en',
            theme: 'light' 
        });
        expect(res.status).toEqual(403)
    });
	it('successfully sign up user with valid credentials', async () => {
        let res = await request(app)
        .post('/auth/local/signup')
        .send({ 
            email: 'validUsername', 
            password: 'validPassword',
            language: 'en',
            theme: 'light' 
        });
        expect(res.status).toEqual(201)
    });
	
});
