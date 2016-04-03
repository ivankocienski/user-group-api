require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'name' do
    it 'can be saved' do
      expect {
        Group.create do |g|
          g.name = 'group'
        end
      }.to change( Group, :count ).by(1)
    end

    it 'must be valid' do
      g = Group.new

      # ni;
      g.name = ''
      expect(g.valid?).to be_falsey

      err = g.errors[:name]
      expect(err).to include("can't be blank")
      
      # wrong length
      g.name = 'x'
      expect(g.valid?).to be_falsey

      err = g.errors[:name]
      expect(err).to include("is too short (minimum is 3 characters)")
      
      g.name = 'x' * 1000
      expect(g.valid?).to be_falsey

      err = g.errors[:name]
      expect(err).to include("is too long (maximum is 100 characters)")

      # bad format
      g.name = '-? ^#@&^('
      expect(g.valid?).to be_falsey

      err = g.errors[:name]
      expect(err).to include("Contains bad characters")

      # must be unique
      Group.create(name: 'group')
      g.name = 'group'
      expect(g.valid?).to be_falsey

      err = g.errors[:name]
      expect(err).to include("has already been taken")
    end
  end
end
