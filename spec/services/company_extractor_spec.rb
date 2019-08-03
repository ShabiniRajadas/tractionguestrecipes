require 'rails_helper'

describe CompanyExtractor do
  describe '#call' do
    subject(:extract_company) { described_class.new(headers).call }

    let(:uid) { 'qiygqgwyqu877656vbahvs' }

    context 'when partner present' do
      let!(:company) { create(:company, uid: uid) }

      context 'when header present' do
        let(:headers) { { 'COMPANY' => uid } }

        it 'finds company' do
          expect(extract_company).to eq company
        end
      end

      context 'when no header' do
        let(:headers) { {} }

        it 'returns nil' do
          expect(extract_company).to be_nil
        end
      end
    end

    context 'when partner not found' do
      let(:headers) { { 'COMPANY' => uid } }

      it 'returns nil' do
        expect(extract_company).to be_nil
      end
    end
  end
end
