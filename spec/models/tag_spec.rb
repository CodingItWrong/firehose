# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  describe '#used' do
    it 'does not return unused tags' do
      unused_tag = FactoryBot.create(:tag)
      used_tag = FactoryBot.create(:tag)
      FactoryBot.create(:link, tags: [used_tag])

      results = Tag.used.to_a

      expect(results).to eql([used_tag])
    end

    it 'removes duplicates' do
      tag = FactoryBot.create(:tag)
      FactoryBot.create_list(:link, 2, tags: [tag])

      results = Tag.used.to_a

      expect(results).to eql([tag])
    end
  end
end
