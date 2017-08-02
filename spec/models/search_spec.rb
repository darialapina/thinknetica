require 'rails_helper'

RSpec.describe Search do
  describe '.find' do
    it "gets common search" do
      expect(ThinkingSphinx::Query).to receive(:escape).with('test').and_call_original
      expect(ThinkingSphinx).to receive(:search).with('test')
      Search.find('test')
    end

    %w(Answer Question User Comment).each do |attr|
      it "gets #{attr} in 'for' param" do
        expect(ThinkingSphinx::Query).to receive(:escape).with('test').and_call_original
        expect(attr.classify.constantize).to receive(:search).with('test')
        Search.find('test', attr)
      end
    end
  end
end
