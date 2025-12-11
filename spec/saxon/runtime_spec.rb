# frozen_string_literal: true

RSpec.describe Saxon::Runtime do
  before(:each) do
    Saxon::Runtime.reset!
  end

  describe '.edition' do
    context 'when not set' do
      it 'returns the default edition' do
        expect(Saxon::Runtime.edition).to be_a(Saxon::Runtime::HE)
      end
    end

    context 'when set' do
      before do
        Saxon::Runtime.edition = Saxon::Runtime::EE.new
        end 
      it 'returns the current edition' do
        expect(Saxon::Runtime.edition).to be_a(Saxon::Runtime::EE)
      end
    end
  end
end
