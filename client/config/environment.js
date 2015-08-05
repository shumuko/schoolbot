/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'client',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    i18n: { defaultLocale: 'en' },
    'simple-auth': {
      authorizer: 'simple-auth-authorizer:devise',
      authenticationRoute: 'sign-in'
    },
    'simple-auth-devise': {
      serverTokenEndpoint: '/api/users/sign_in'
    },
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      },
      LOG_VERSION: false
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (['production', 'staging'].indexOf(environment) > -1) {
    if (!process.env.AIRBRAKE_ID || !process.env.AIRBRAKE_KEY) {
      throw new Error('AIRBRAKE_ID and AIRBRAKE_KEY must be defined in .env!');
    }

    ENV.airbrake = {
      projectId: process.env.AIRBRAKE_ID,
      projectKey: process.env.AIRBRAKE_KEY
    };
  }

  return ENV;
};
