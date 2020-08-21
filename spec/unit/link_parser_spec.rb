# frozen_string_literal: true

require 'link_parser'

RSpec.describe LinkParser, :vcr do
  class NullLogger
    def error(*args); end
  end

  subject(:link) { described_class.process(url: url, logger: NullLogger.new) }

  describe '#canonical' do
    context 'when there are no redirects' do
      let(:url) { 'https://codingitwrong.com/' }
      it 'returns the passed-in url' do
        expect(link.canonical).to eq(url)
      end
    end

    context 'when there are redirects' do
      let(:url) { 'http://bit.ly/jay-is-great' }
      it 'follows redirects' do
        expect(link.canonical).to eq(
          'https://www.bignerdranch.com/blog/testing-external-dependencies-with-fakes/',
        )
      end
    end
  end

  describe '#title' do
    context 'when there are no redirects' do
      let(:url) do
        'http://codingitwrong.com/2017/07/24/letting-people-learn.html'
      end
      it 'loads the URL and returns the title tag text' do
        expect(link.title).to eq('Letting People Learn | CodingItWrong.com')
      end
    end

    context 'when there are redirects' do
      let(:url) { 'https://google.com' }
      it 'follows redirects' do
        expect(link.title).to eq('Google')
      end
    end

    context 'when there are spaces in the title' do
      let(:url) { 'https://www.destroyallsoftware.com/talks/ideology' }
      it 'trims spaces' do
        expect(link.title).to eq('Ideology')
      end
    end

    context 'when there are entities in the title' do
      let(:url) do
        'http://confreaks.tv/videos/rubyconf2017-keynote-you-re-insufficiently-persuasive'
      end
      it 'decodes entities' do
        expect(link.title).to eq(
          "Confreaks TV | Keynote: You're Insufficiently Persuasive - Ruby Conference 2017",
        )
      end
    end

    context 'when the title is somehow not detected in the head' do
      let(:url) { 'https://leanpub.com/mobprogramming' }
      it 'detects the title' do
        expect(link.title).to eq(
          'Mob Programming  by Woody Zuill et al. [Leanpub PDF/iPad/Kindle]',
        )
      end
    end

    context 'when there is a meta refresh' do
      let(:url) do
        'http://www.adequatelygood.com/2010/2/JavaScript-Scoping-and-Hoisting/'
      end
      it 'follows the refresh' do
        expect(link.title).to eq('JavaScript Scoping and Hoisting')
      end
    end

    context 'when the title tag is absent until JS runs' do
      let(:url) { 'https://google.github.io/styleguide/javascriptguide.xml' }
      it 'uses the title tag added by JS' do
        expect(link.title).to eq('Google JavaScript Style Guide')
      end
    end

    context 'when the page load fails' do
      let(:url) {
        'https://www.washingtonpost.com/sports/2020/08/20/if-colleges-prioritize-football-during-this-pandemic-their-true-sickness-will-be-revealed/?utm_source=rss&utm_medium=referral&utm_campaign=wp_homepage'
      }
      it 'uses the last URL segment, titleized' do
        expect(link.title).to eq(
          'If Colleges Prioritize Football During This Pandemic Their True Sickness Will Be Revealed',
        )
      end
    end

    # no longer have a test case, as we now execute JS
    # context "when there just isn't a title tag at all" do
    #   let(:url) { 'https://google.github.io/styleguide/javascriptguide.xml' }
    #   it 'uses the last path segment as the title' do
    #     expect(link.title).to eq('javascriptguide.xml')
    #   end
    # end

    # original has been fixed
    # context 'when there are multiple title tags foolishly' do
    #   let(:url) { 'https://babeljs.io/docs/usage/polyfill/' }
    #   it 'uses only the first as the title' do
    #     expect(link.title).to eq('Polyfill · Babel')
    #   end
    # end
  end
end
