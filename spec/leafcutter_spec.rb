require 'spec_helper'
require 'json'

require_relative '../lib/leafcutter.rb'

describe Leafcutter do
  describe '#run' do
    before :all do
      json = JSON.parse(File.read('./spec/fixtures/data.json'))

      @leafcutter = Leafcutter.new json
    end

    context 'with query for untagged, local, unowned, unpromoted item' do
      it 'should find ["A", "B", "C", "D", "E"]' do
        query = { 'tag' => '', 'international' => 'false', 'owner' => '', 'promoted' => 'false' }

        result = @leafcutter.run query

        expect(result).to eq ["A", "B", "C", "D", "E"]
      end
    end

    context 'with query for upcoming, international, unowned, promoted item' do
      it 'should find ["C", "D", "A", "B"]' do
        query = { 'tag' => 'upcoming', 'international' => 'true', 'owner' => '', 'promoted' => 'true' }

        result = @leafcutter.run query

        expect(result).to eq ["C", "D", "A", "B"]
      end
    end

    context 'with partial query' do
      it 'should raise exception' do
        query = { 'tag' => '' }

        expect { @leafcutter.run(query) }.to raise_error("Error on international. Expecting to explore [\"international\"] on branch ''")
      end
    end

    context 'with unlisted branches' do
      it 'should raise exception' do
        query = { 'tag' => 'unlisted', 'international' => 'true', 'owner' => '', 'promoted' => 'true' }

        expect { @leafcutter.run(query) }.to raise_error("Error on tag. Expecting to explore [\"tag\"] on branch 'unlisted'")
      end
    end
  end
end
