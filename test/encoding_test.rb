require 'test_helper'
require 'rbencode'

class EncodingTest < Minitest::Test
  def test_encoding_numbers
    assert_equal('i10e', Rbencode.encode(10))
    assert_equal('i0e', Rbencode.encode(0))
    assert_equal('i-10e', Rbencode.encode(-10))
  end

  def test_encoding_arrays
    assert_equal('li1ei2ei3ee', Rbencode.encode([1, 2, 3]))
    assert_equal('li3ei2ei1ee', Rbencode.encode([3, 2, 1]))
  end

  def test_encoding_unknown
    assert_raises UnsupportedDataError do
      Rbencode.encode(1.0)
    end
  end
end
