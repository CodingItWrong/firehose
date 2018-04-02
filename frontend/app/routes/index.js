import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default Route.extend({
  session: service(),

  model() {
    let options = { include: 'tags' };

    if (this.get('session').get('isAuthenticated')) {
      options.filter = { read: false };
    }

    return this.store.findAll('link', options);
  },
});
