require 'spec_helper'
require 'ffi/bit_field'

describe FFI::BitField do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end
