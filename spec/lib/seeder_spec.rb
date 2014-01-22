require 'spec_helper'

describe SeedOMatic::Seeder do

  before { MyModel.reset }

  let!(:mock_model) { mock(MyModel).as_null_object }
  let(:existing_mock) { MyModel.create(:name => 'Existing') }
  let(:new_mock) { MyModel.new(:name => 'New') }

  let(:seeder) { described_class.new(data) }
  let(:data) { { :model_name => model_name, :items => items, :seed_mode => seed_mode, :match_on => match_on } }
  let(:model_name) { "MyModel" }
  let(:items) {
    [{'name' => 'foo', 'code' => 'uniquecode', 'code_category' => 'more_unique'} ]
  }
  let(:seed_mode) { nil }
  let(:match_on) { nil }

  describe "import" do
    subject { seeder.import }

    describe "creating records" do
      context "single item" do
        let(:items) { [{'name' => 'foo'}] }
        specify {
          MyModel.should_receive(:new).and_return(mock_model)
          subject
        }
      end

      context "multiple items" do
        let(:items) { [{'name' => 'foo'}, {'name' => 'bar'} ] }
        specify {
          MyModel.should_receive(:new).twice.and_return(mock_model)
          subject
        }
        it "should set fields properly" do
          subject
          MyModel[0].name.should == 'foo'
          MyModel[1].name.should == 'bar'
        end
      end

      context "lookup fields" do
        let(:items) { [{'name' => 'foo', 'category_lookup' => { 'code' => 'bar' }}]}
        let(:category) { MyCategory.new }
        specify {
          MyModel.should_receive(:reflect_on_association).with(:category).and_return(OpenStruct.new(:klass => MyCategory))
          MyCategory.should_receive(:where).with(hash_including('code' => 'bar')).and_return(OpenStruct.new(:first => category))
          subject
          MyModel[0].category.should == category
          MyModel[0].category_lookup.should be_nil
        }
      end
    end

    describe "checking uniqueness on a specified field" do
      context "single field" do
        let(:match_on) { 'code' }

        specify {
          MyModel.should_receive(:find_or_initialize_by).with('code' => 'uniquecode').and_return(MyModel.new)
          subject
        }
      end
      context "multiple fields" do
        let(:match_on) { ['code', 'code_category'] }

        specify {
          MyModel.should_receive(:find_or_initialize_by).with('code' => 'uniquecode', 'code_category' => 'more_unique').and_return(MyModel.new)
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
      it { should == 'find_or_initialize_by' }
    end

    context "multiple matching fields" do
      let(:match_on) { ['code', 'code_category'] }
      it { should == 'find_or_initialize_by' }
    end
  end

  describe "seed_mode" do
    subject { seeder.import }

    let(:items) {
      [{'name' => 'foo', 'code' => 'existing'}, {'name' => 'bar', 'code' => 'new'} ]
    }
    let(:match_on) { 'code' }
    before {
      MyModel.stub(:find_or_initialize_by).with('code' => 'existing').and_return(existing_mock)
      MyModel.stub(:find_or_initialize_by).with('code' => 'new').and_return(new_mock)
    }

    context "once" do
      let(:seed_mode) { 'once' }

      it "should only save new models" do
        existing_mock.should_not_receive(:save!)
        new_mock.should_receive(:save!)
        subject
      end

      describe "nested associations" do
        let(:items) {
          [{'name' => 'foo', 'code' => 'existing', 'foos_attributes' => [{'a' => 1}]}]
        }

        it "should not destroy existing ones" do
          mock_association = mock('foos')

          MyModel.stub(:reflect_on_association).and_return(stub('association', collection?: true))
          existing_mock.stub(:foos).and_return(mock_association)
          mock_association.should_not_receive(:destroy_all)

          subject
        end
      end
   end
    context "always" do
      let(:seed_mode) { 'always' }

      it "should save multiple models" do
        existing_mock.should_receive(:save!)
        new_mock.should_receive(:save!)
        subject
      end

      describe "nested associations" do
        let(:items) {
          [{'name' => 'foo', 'code' => 'existing', 'foos_attributes' => [{'a' => 1}]}]
        }

        it "should destroy previously existing ones" do
          mock_association = mock('foos')

          MyModel.stub(:reflect_on_association).and_return(stub('association', collection?: true))
          existing_mock.stub(:foos).and_return(mock_association)
          mock_association.should_receive(:destroy_all)

          subject
        end
      end
    end
  end

  describe "create_args" do
    subject { seeder.send(:create_args, {'code' => 1, 'code_category' => 2}) }

    context "no matching fields" do
      let(:match_on) { nil }
      it { should == {} }
    end

    context "one matching field" do
      let(:match_on) { 'code' }
      it { should == {'code' => 1} }
    end

    context "multiple matching fields" do
      let(:match_on) { ['code', 'code_category'] }
      it { should == {'code' => 1, 'code_category' => 2} }
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
