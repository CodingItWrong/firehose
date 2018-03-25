import { describe, it } from 'mocha';
import { expect } from 'chai';
import { visit, fillIn, click, find } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-mocha';
import setupMirage from 'ember-cli-mirage/test-support/setup-mirage';

describe('auth', function() {
  let hooks = setupApplicationTest();
  setupMirage(hooks);

  it('can sign in and sign out', async function() {
    await visit('/');

    await click('[data-test-login-link]');

    await fillIn('[data-test-email-field]', 'example@example.com');
    await fillIn('[data-test-password-field]', 'password');
    await click('[data-test-login-button]');

    expect(find('[data-test-logout-button]')).to.exist;

    await click('[data-test-logout-button]');

    expect(find('[data-test-logout-button]')).not.to.exist;

    await click('[data-test-login-link]');

    expect(find('[data-test-email-field]').value).to.eq('');
  });
});
