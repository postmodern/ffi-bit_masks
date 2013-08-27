require 'ffi/bit_masks/field'

module FFI
  module BitMasks
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
    def bit_field(name,fields,type=:uint)
      field = Field.new(type,fields)

      typedef(name,field)
      return field
    end
  end
end
