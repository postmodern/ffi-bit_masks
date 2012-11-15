require 'ffi/bitfields/field'

module FFI
  module Bitfields
    #
    # Defines a new bit-field.
    #
    # @param [Symbol] name
    #
    # @param [Array<(Symbol, Integer)>] fields
    #
    # @return [Field]
    #   The new bit-field.
    #
    def bitfield(name,fields)
      field = Field.new(fields)

      typedef(name,field)
      return field
    end
  end
end
