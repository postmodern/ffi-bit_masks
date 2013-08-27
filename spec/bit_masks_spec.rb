require 'spec_helper'
require 'ffi/bit_masks'

describe FFI::BitMasks do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end

  describe "#bit_mask" do
    subject do
      mod = Module.new
      mod.extend FFI::Library
      mod.extend described_class
    end

    let(:flags) { {foo: 0x1, bar: 0x2, baz: 0x4} }

    it "should return a BitMask object" do
      subject.bit_mask(:flags,flags).flags.should == flags
    end

    it "should define a typedef for the bitmask" do
      bitmask = subject.bit_mask(:flags,flags)

      subject.find_type(:flags).should be_kind_of(FFI::Type::Mapped)
    end
  end
end
