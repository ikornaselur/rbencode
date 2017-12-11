require 'test_helper'
require 'rbencode'

class EncodingTest < Minitest::Test
  def test_encoding_number
    assert_equal('i10e', Rbencode.encode(10))
    assert_equal('i0e', Rbencode.encode(0))
    assert_equal('i-10e', Rbencode.encode(-10))
  end

  def test_encoding_string
    assert_equal('3:foo', Rbencode.encode('foo'))
    assert_equal('6:foobar', Rbencode.encode('foobar'))
  end

  def test_encoding_simple_array
    assert_equal('li1ei2ei3ee', Rbencode.encode([1, 2, 3]))
    assert_equal('li3ei2ei1ee', Rbencode.encode([3, 2, 1]))
  end

  def test_encoding_nested_array
    assert_equal('lli1ei2eeli3ei4eee', Rbencode.encode([[1, 2], [3, 4]]))
  end

  def test_encoding_simple_hash
    assert_equal('d3:fooi10ee', Rbencode.encode('foo' => 10))
    assert_equal('d3:bar3:bar3:baz3:baze',
                 Rbencode.encode('bar' => 'bar', 'baz' => 'baz'))
  end

  def test_encoding_nested_hash
    assert_equal('d3:food3:bar3:bazee',
                 Rbencode.encode('foo' => { 'bar' => 'baz' }))
  end

  def test_encoding_complex_object
    # Test an object with everything
    expected = 'ld3:food3:barli1ei2e3:bazee3:quxi10ee3:hehi1ei2ei3eli4ei5ei6eee'
    decoded = [
      {
        'foo' => {
          'bar' => [1, 2, 'baz']
        },
        'qux' => 10
      },
      'heh',
      1,
      2,
      3,
      [4, 5, 6]
    ]
    assert_equal(expected, Rbencode.encode(decoded))
  end

  def test_encoding_unknown
    assert_raises UnsupportedDataError do
      Rbencode.encode(1.0)
    end
  end
end
