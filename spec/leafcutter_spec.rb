require 'spec_helper'
require 'json'

require_relative '../lib/leafcutter.rb'

describe Leafcutter do
  describe '#validate' do
    context 'with valid data' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/data.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return valid status object' do
        expect(@status[:valid]).to be_truthy
      end

      it 'should return status object with no errors' do
        expect(@status[:errors]).to be_empty
      end
    end

    context 'with invalid data due to multiple roots' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_multiple_roots.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with multiple_conditions error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('multiple_conditions')
      end
    end

    context 'with invalid data due to multiple conditions' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_multiple_conditions.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with multiple_conditions error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('multiple_conditions')
      end
    end

    context 'with invalid data due to non-array leaf node' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_non_array_leaf.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with non_array_leaf error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('non_array_leaf')
      end
    end

    context 'with invalid data due to empty leaf node' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_empty_leaf.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with empty_leaf error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('empty_leaf')
      end
    end

    context 'with invalid data due to empty string in leaf node' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_empty_string_leaf.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with empty_leaf error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('empty_leaf')
      end
    end

    context 'with invalid data due to single entry in option node' do
      before :each do
        json = JSON.parse(File.read('./spec/fixtures/invalid_single_option.json'))

        leafcutter = Leafcutter.new json
        @status = leafcutter.validate
      end

      it 'should return invalid status object' do
        expect(@status[:valid]).to be_falsey
      end

      it 'should return status object with single_option error' do
        expect(@status[:errors]).not_to be_empty
        expect(@status[:errors].length).to eq(1)
        expect(@status[:errors][0]).to eq('single_option')
      end
    end
  end

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
