require_relative '../../../app/api'

require 'rack/test'
require 'pry'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    def parsed_response_expect_to_include(test_data)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include(test_data)
    end

    let (:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST / expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } }
        #uses rspec mock to say that :record with the arguments of expense and returns out the new RecordResult. 
          #Returns to #app calling API.new
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true,417,nil))
        end
        
        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
         parsed_response_expect_to_include('expense_id' => 417)
        end
        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end
      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }
        #uses rspec mock to say that :record with the arguments of expense and returns out the new RecordResult. 
          #Returns to #app calling API.new
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false,417,'Expense incomplete'))
        end
        it 'returns an error message' do

          post '/expenses', JSON.generate(expense)
          
          parsed_response_expect_to_include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON'
        it 'responds with a 200 (OK)'
      end
      context 'when there are no expenses on the given date' do
        it 'returns an empty array as JSON'
        it 'responds with a 200(OK)'
      end
    end
  end
end