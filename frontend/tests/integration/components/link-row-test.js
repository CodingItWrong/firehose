import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import Service from '@ember/service';

module('Integration | Component | link-row', function(hooks) {
  setupRenderingTest(hooks);

  test('it does not display action buttons when signed out', async function(assert) {
    let session = Service.extend({ isAuthenticated: () => false });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page'
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link session=session}}`);

    assert.notOk(find('[data-test="button-mark-read'));
    assert.notOk(find('[data-test="button-edit'));
    assert.notOk(find('[data-test="button-delete'));
  });

  test('it displays action buttons when signed in', async function(assert) {
    let session = Service.extend({ isAuthenticated: () => true });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page'
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link}}`);

    assert.ok(find('[data-test="button-mark-read'));
    assert.ok(find('[data-test="button-edit'));
    assert.ok(find('[data-test="button-delete'));
  });

  test('it displays Mark Unread when read', async function(assert) {
    let session = Service.extend({ isAuthenticated: () => true });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page',
      read: true,
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link}}`);

    assert.ok(find('[data-test="button-mark-unread'));
    assert.notOk(find('[data-test="button-mark-read'));
  });
});
