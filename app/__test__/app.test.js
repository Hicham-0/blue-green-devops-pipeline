const request = require('supertest');
const app = require('../index');

describe('Portfolio app - integration tests', () => {

  describe('GET /health', () => {
    it('should return 200 and status healthy', async () => {
      const res = await request(app).get('/health');
      expect(res.statusCode).toBe(200);
      expect(res.body).toEqual({ status: 'healthy' });
    });
  });

  describe('GET /info', () => {
    it('should return the app name and a defined version', async () => {
      const res = await request(app).get('/info');
      expect(res.statusCode).toBe(200);
      expect(res.body.app).toBe('portfolio-app');
      expect(res.body.version).toBeDefined();
      expect(typeof res.body.version).toBe('string');
    });
  });

  describe('GET / (static portfolio)', () => {
    it('should serve the portfolio HTML page', async () => {
      const res = await request(app).get('/');
      expect(res.statusCode).toBe(200);
      expect(res.headers['content-type']).toMatch(/html/);
      expect(res.text).toContain('<!DOCTYPE html>');
    });

    it('should include the expected page title', async () => {
      const res = await request(app).get('/');
      expect(res.text).toContain('Cloud & DevOps Engineer');
    });
  });

  describe('GET /route-inconnue', () => {
    it('should return 404 for a non-existent route', async () => {
      const res = await request(app).get('/route-inconnue');
      expect(res.statusCode).toBe(404);
    });
  });

});