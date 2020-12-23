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
        #the expense has isn't valid, but that's ok. We just need to pass some data and get the canned return back no matter the input.
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
        before do
          # This really is just a mock version. If you try and call the get route with a different date the test won't function, and will tell you to either stub another date or use the one already stubbed in the allow statement
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-12')
            .and_return(['expense_1', 'expense_2'])
        end

        it 'returns the expense records as JSON' do
          #What's interesting is there is no actual method body in the #expense_on in the ledger class.  In your stub you act like you call it so it needs to exist, but the stub itself returns the information you would expect to get back if the method body in #expnse_on was actually defined. 
          get '/expenses/2017-06-12'

          expenses = JSON.parse(last_response.body)
          expect(expenses).to eq(['expense_1', 'expense_2'])
        end
        it 'responds with a 200 (OK)' do

          get '/expenses/2017-06-12'
          
          expect(last_response.status).to eq(200)
        end
      end
      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-12')
            .and_return([])
        end
        it 'returns an empty array as JSON' do
          get '/expenses/2017-06-12'

          expenses = JSON.parse(last_response.body)
          expect(expenses).to eq([])
        end
        it 'responds with a 200(OK)' do
          get 'expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end