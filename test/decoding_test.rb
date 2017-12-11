require 'test_helper'
require 'rbencode'

class EncodingTest < Minitest::Test
  def test_decoding_numbers
    assert_equal(10, Rbencode.decode('i10e'))
    assert_equal(0, Rbencode.decode('i0e'))
    assert_equal(-10, Rbencode.decode('i-10e'))
  end

  def test_decoding_strings
    assert_equal('foo', Rbencode.decode('3:foo'))
    assert_equal('bazqux', Rbencode.decode('6:bazqux'))
  end

  def test_decoding_simple_arrays
    assert_equal([1, 2, 3], Rbencode.decode('li1ei2ei3ee'))
    assert_equal([3, 2, 1], Rbencode.decode('li3ei2ei1ee'))
  end

  def test_decoding_nested_arrays
    assert_equal([[1, 2], [3, 4]], Rbencode.decode('lli1ei2eeli3ei4eee'))
  end

  def test_decoding_simple_hash
    assert_equal({ 'foo' => 10 }, Rbencode.decode('d3:fooi10ee'))
    assert_equal({ 'bar' => 'bar', 'baz' => 'baz' },
                 Rbencode.decode('d3:bar3:bar3:baz3:baze'))
  end

  def test_decoding_nested_hash
    assert_equal({ 'foo' => { 'bar' => 'baz' } },
                 Rbencode.decode('d3:food3:bar3:bazee'))
  end

  def test_decoding_complex_object
    # Test an object with everything
    expected = [
      {
        'foo' => {
          'bar' => [1, 2, 'baz']
        },
        'qux' => 10
      },
      'norf',
      1,
      2,
      3,
      [4, 5, 6]
    ]
    encoded = 'ld3:food3:barli1ei2e3:bazee3:quxi10ee4:norfi1ei2ei3eli4ei5ei6eee'
    assert_equal(expected, Rbencode.decode(encoded))
  end
end
