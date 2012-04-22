require 'spec_helper'

describe SeedOMatic::Seeder do
  let(:seeder) { described_class.new(data) }
  let(:data) { { :model_name => model_name, :items => items, :match_on => match_on } }
  let(:model_name) { "MyModel" }
  let(:items) {
    [{'name' => 'foo', 'code' => 'uniquecode', 'code_category' => 'more_unique'} ]
  }
  let(:match_on) { nil }

  describe "import" do
    subject { seeder.import }

    describe "creating records" do
      context "single item" do
        let(:items) { [{'name' => 'foo'}] }
        specify {
          MyModel.should_receive(:create).with(hash_including('name' => 'foo'))
          subject
        }
      end

      context "multiple items" do
        let(:items) { [{'name' => 'foo'}, {'name' => 'bar'} ] }
        specify {
          MyModel.should_receive(:create).with(hash_including('name' => 'foo'))
          MyModel.should_receive(:create).with(hash_including('name' => 'bar'))
          subject
        }
      end
    end

    describe "checking uniqueness on a specified field" do
      context "single field" do
        let(:match_on) { 'code' }

        specify {
          MyModel.should_receive(:find_or_create_by_code).with('uniquecode')
          subject
        }
      end
      context "multiple fields" do
        let(:match_on) { ['code', 'code_category'] }

        specify {
          MyModel.should_receive(:find_or_create_by_code_and_code_category).with('uniquecode', 'more_unique')
          subject
        }
      end
    end
  end

  describe "model class" do
    subject { seeder.send(:model_class) }

    ["MyModel", MyModel, :my_model, 'my_model'].each do |name|
      describe name do
        let(:model_name) { name }
        it { should == MyModel }
      end
    end

    ["Blah", "blah", :not_a_model].each do |name|
      describe name do
        let(:model_name) { name }
        specify { expect { subject }.to raise_error }
      end
    end
  end
end