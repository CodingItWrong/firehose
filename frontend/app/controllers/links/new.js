import Controller from '@ember/controller';

export default Controller.extend({
  resetForm() {
    this.set('url', '');
  },

  actions: {
    async handleSave() {
      let link = this.store.createRecord('link', { url: this.url });
      await link.save();
      this.transitionToRoute('index');
    },
  },
});
