import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),

  actions: {
    signIn() {
      let { email, password } = this.getProperties('email', 'password');
      return this.get('session')
        .authenticate('authenticator:application', email, password)
        .catch((response) => {
          if (response && response.error) {
            this.set('errorMessage', this.get('i18n').t(response.error));
          } else {
            Ember.onerror(response);
          }
        });
    }
  }
});
