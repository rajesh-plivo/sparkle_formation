require_relative '../spec'

describe SparkleFormation::SparkleStruct do

  before do
    @struct = SparkleFormation::SparkleStruct.new
    @struct._set_self(
      SparkleFormation.new(:stub,
        :parameters => {
          :foobar => {
            :type => :number
          },
          :defaulter => {
            :type => :number,
            :default => 42
          }
        }
      )
    )
  end

  describe 'Nested creation' do

    it 'should automatically set self on nested structs' do
      @struct.new_struct._self.must_equal @struct._self
    end

  end

  describe 'Behavior' do

    it 'should error when compile parameter is not within state' do
      ->{ @struct.state!(:foobar) }.must_raise ArgumentError
    end

    it 'should provide default compile time parameter value when not in state' do
      @struct.state!(:defaulter).must_equal 42
    end

    it 'should load Hash values as structs' do
      @struct.my_key :value1 => {:value2 => true}
      @struct.my_key.value1.value3 true
      @struct._dump.must_equal(
        'MyKey' => {
          'Value1' => {
            'Value2' => true,
            'Value3' => true
          }
        }
      )
    end

    it 'should force root on FunctionStruct instances' do
      @struct.my_key SparkleFormation::FunctionStruct.new(:foobar).chained.method_value(42)
      @struct._dump.must_equal(
        'MyKey' => '[foobar.chained.method_value(42)]'
      )
    end

  end

end