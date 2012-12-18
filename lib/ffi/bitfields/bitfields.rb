require 'ffi/bitfields/field'

module FFI
  module Bitfields
    #
    # Defines a new bit-field.
    #
    # @param [Symbol] name
    #
    # @param [Hash{Symbol => Integer}] fields
    #
    # @param [Symbol] type
    #   The underlying type.
    #
    # @return [Field]
    #   The new bit-field.
    #
    def bitfield(name,fields,type=:uint)
      field = Field.new(type,fields)

      typedef(name,field)
      return field
    end
  end
end
