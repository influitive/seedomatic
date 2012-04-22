require 'spec_helper'

describe SeedOMatic::Seeder do
  let(:seeder) { described_class.new(data) }
  let(:data) { { :model_name => model_name, :items => items } }
  let(:model_name) { "MyModel" }
  let(:items) { [{'name' => 'foo'}] }

  describe "import" do
    subject { seeder.import }

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