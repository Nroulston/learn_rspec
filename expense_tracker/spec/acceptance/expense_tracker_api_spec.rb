require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods
    
    #Rack::Test documentation say you need an app method. Where else can you define it?
    def app
      ExpenseTracker::API.new
    end
    it 'records submitted expense' do
      coffee = { 
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }

      post '/expenses', JSON.generate(coffee)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)      
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end
  end
end