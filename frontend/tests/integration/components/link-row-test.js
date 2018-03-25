import { describe, it } from 'mocha';
import { expect } from 'chai';
import { setupRenderingTest } from 'ember-mocha';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import Service from '@ember/service';

describe('{{link-row}}', () => {
  setupRenderingTest();

  it('does not display action buttons when signed out', async function() {
    let session = Service.extend({ isAuthenticated: () => false });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page',
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link session=session}}`);

    expect(find('[data-test-button-mark-read]')).not.to.exist;
    expect(find('[data-test-button-edit]')).not.to.exist;
    expect(find('[data-test-button-delete]')).not.to.exist;
  });

  it('it displays action buttons when signed in', async function() {
    let session = Service.extend({ isAuthenticated: () => true });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page',
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link}}`);

    expect(find('[data-test-button-mark-read]')).to.exist;
    expect(find('[data-test-button-edit]')).to.exist;
    expect(find('[data-test-button-delete]')).to.exist;
  });

  it('it displays Mark Unread when read', async function() {
    let session = Service.extend({ isAuthenticated: () => true });
    this.owner.register('service:session', session);

    let link = {
      title: 'My Title',
      url: 'https://www.example.com/page',
      read: true,
    };
    this.set('link', link);

    await render(hbs`{{link-row link=link}}`);

    expect(find('[data-test-button-mark-unread]')).to.exist;
    expect(find('[data-test-button-mark-read]')).not.to.exist;
  });
});
