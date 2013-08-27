require 'spec_helper'
require 'ffi/bit_masks/bit_mask'

describe FFI::BitMasks::BitMask do
  let(:flags) { {foo: 0x1, bar: 0x2, baz: 0x4} }

  subject { described_class.new(flags) }

  describe "#initialize" do
    subject { described_class.new(flags) }

    it "should initialize the flags" do
      subject.flags.should == flags
    end

    it "should invert the flags into bitmasks" do
      subject.bitmasks.should == flags.invert
    end

    it "should default type to uint" do
      subject.native_type.should == FFI::Type::UINT
    end

    context "when given a custom type" do
      subject { described_class.new(flags,:ushort) }

      it "should set native type" do
        subject.native_type.should == FFI::Type::USHORT
      end
    end
  end

  describe "#symbols" do
    it "should return the names of the flags" do
      subject.symbols.should == flags.keys
    end
  end

  describe "#symbol_map" do
    it "should return the flags" do
      subject.symbol_map.should == flags
    end
  end

  describe "#to_h" do
    it "should return the flags" do
      subject.to_h.should == flags
    end
  end

  describe "#to_hash" do
    it "should return the flags" do
      subject.to_hash.should == flags
    end
  end

  describe "#[]" do
    context "when given a Symbol" do
      it "should lookup the bitmask" do
        subject[:bar].should == flags[:bar]
      end
    end

    context "when given an Integer" do
      it "should lookup the flag" do
        subject[flags[:bar]].should == :bar
      end
    end

    context "otherwise" do
      it "should return nil" do
        subject[Object.new].should be_nil
      end
    end
  end

  describe "#to_native" do
    context "when given a Hash" do
      it "should bitwise or together the flag masks" do
        subject.to_native({foo: true, bar: true, baz: false}).should == (
          flags[:foo] | flags[:bar]
        )
      end

      context "when one of the keys does not correspond to a flag" do
        it "should ignore the key" do
          subject.to_native({foo: true, bug: true, baz: true}).should == (
            flags[:foo] | flags[:baz]
          )
        end
      end
    end

    context "when an Object that respnds to #to_int" do
      let(:int) { 0x3 }

      it "should call #to_int" do
        subject.to_native(int).should == 0x3
      end
    end

    context "when given an Object that does not respond to #to_int" do
      it "should raise an ArgumentError" do
        lambda {
          subject.to_native(Object.new)
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#from_native" do
    let(:value) { flags[:foo] | flags[:baz] }

    it "should set the flags from the value" do
      subject.from_native(value).should == {foo: true, bar: false, baz: true}
    end

    context "when one flag is a combination of other flags" do
      let(:flags) { {foo: 0x1, bar: 0x2, baz: 0x3} }
      let(:value) { flags[:foo] | flags[:bar]      }

      it "should set all flags whose bitmasks are present" do
        subject.from_native(value).should == {foo: true, bar: true, baz: true}
      end
    end

    context "when given a value that contains unknown masks" do
      let(:value) { flags[:foo] | flags[:baz] | 0x8 | 0x10 }

      it "should ignore the unknown flags" do
        subject.from_native(value).should == {foo: true, bar: false, baz: true}
      end
    end
  end
end
