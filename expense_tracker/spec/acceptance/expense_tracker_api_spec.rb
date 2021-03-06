require 'rack/test'
require 'json'
require_relative '../../app/api'

RSpec.shared_context 'API helpers' do
  include Rack::Test::Methods

  #Rack::Test documentation say you need an app method. Where else can you define it?
  def app 
    ExpenseTracker::Api.new
  end
  
  before do
    basic_authroize 'test_user', 'test_password'
  end
end




  RSpec.describe 'Expense Tracker API', :db do
    include_context 'API helpers'
    
    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)      
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end
    

    it 'records submitted expense' do
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10',
      )
      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'  
      )
      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'  
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
