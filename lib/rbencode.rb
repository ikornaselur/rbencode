require 'rbencode/version'

class UnsupportedDataError < StandardError
end

# A bencoding module to serialize to and from the bit torrent bencoding spec
module Rbencode
  def self.encode(data)
    Encoder.encode(data)
  end

  def self.decode(data)
    decoder = Decoder.new(data)
    decoder.decode
  end
end

# The encoding class, to encapsulate all encoding behaviour in one module
module Encoder
  module_function

  def self.encode(data)
    if data.is_a? Integer
      encode_int(data)
    elsif data.is_a? Array
      encode_array(data)
    else
      raise UnsupportedDataError
    end
  end

  def encode_int(data)
    "i#{data}e"
  end

  def encode_array(data)
    "l#{data.collect { |x| encode(x) }.join}e"
  end
end

# Decoder for a bencoded string
class Decoder
  def initialize(encoded)
    @encoded_buffer = encoded.chars
  end

  def decode
    type = @encoded_buffer[0]
    if /[\d]/.match? type
      parse_string
    elsif type == 'i'
      parse_int
    elsif type == 'l'
      parse_array
    elsif type == 'd'
      parse_hash
    else
      raise UnsupportedDataError
    end
  end

  def parse_string
    count_chars = []
    count_chars.push(@encoded_buffer.shift) while @encoded_buffer[0] != ':'
    @encoded_buffer.shift  # Drop the colon
    count = count_chars.join.to_i
    @encoded_buffer.shift(count).join
  end

  def parse_int
    @encoded_buffer.shift  # drop the i
    int_chars = []
    int_chars.push(@encoded_buffer.shift) while @encoded_buffer[0] != 'e'
    @encoded_buffer.shift  # drop the e
    int_chars.join.to_i
  end

  def parse_array
    @encoded_buffer.shift  # drop the l
    array = []
    array.push(decode) while @encoded_buffer[0] != 'e'
    @encoded_buffer.shift  # drop the e
    array
  end

  def parse_hash
    @encoded_buffer.shift  # drop the l
    hash = {}
    while @encoded_buffer[0] != 'e'
      key = decode
      value = decode
      hash[key] = value
    end
    @encoded_buffer.shift  # drop the e
    hash
  end
end
