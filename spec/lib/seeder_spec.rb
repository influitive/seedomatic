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
          MyModel.should_receive(:new).and_return(MyModel.new)
          subject
        }
      end

      context "multiple items" do
        let(:items) { [{'name' => 'foo'}, {'name' => 'bar'} ] }
        specify {
          MyModel.should_receive(:new).twice.and_return(MyModel.new)
          subject
        }
        it "should set fields properly" do
          subject
          MyModel[0].name.should == 'foo'
          MyModel[1].name.should == 'bar'
        end
      end
    end

    describe "checking uniqueness on a specified field" do
      context "single field" do
        let(:match_on) { 'code' }

        specify {
          MyModel.should_receive(:find_or_initialize_by_code).with('uniquecode').and_return(MyModel.new)
          subject
        }
      end
      context "multiple fields" do
        let(:match_on) { ['code', 'code_category'] }

        specify {
          MyModel.should_receive(:find_or_initialize_by_code_and_code_category).with('uniquecode', 'more_unique').and_return(MyModel.new)
          subject
        }
      end
    end
  end

  describe "create_method" do
    subject { seeder.send(:create_method) }

    context "no matching fields" do
      let(:match_on) { nil }
      it { should == 'new' }
    end

    context "one matching field" do
      let(:match_on) { 'code' }
      it { should == 'find_or_initialize_by_code' }
    end

    context "multiple matching fields" do
      let(:match_on) { ['code', 'code_category'] }
      it { should == 'find_or_initialize_by_code_and_code_category' }
    end
  end

  describe "create_args" do
    subject { seeder.send(:create_args, {'code' => 1, 'code_category' => 2}) }

    context "no matching fields" do
      let(:match_on) { nil }
      it { should == [] }
    end

    context "one matching field" do
      let(:match_on) { 'code' }
      it { should == [1] }
    end

    context "multiple matching fields" do
      let(:match_on) { ['code', 'code_category'] }
      it { should == [1,2] }
    end

    context "order sensitivity" do
      let(:match_on) { ['code_category', 'code'] }
      it { should == [2,1] }
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