# Example follows the Arrange/Act/Assert pattern
# Set up and object, do something with it, check it's behavior

#Initial failing test

# RSpec.describe 'An ideal sandwich' do ## This is called an example group it defines what you are testing
#   it 'is delicious' do #creates and example/instance/individual test
#     sandwich =Sandwich.new('delcicious', [])

#     taste = sandwich.taste
#     expect(taste).to eq('delicious') #asserts/verifies expected outcome

#   end
# end

#A test valdiates that a bit of code is working properly.
#A spec describes the desired behavior of a bit of code.
#An example shows how a particular API is inteded to be used.

#passing the test by adding a Struct
# Sandwich = Struct.new(:taste, :toppings)

# RSpec.describe 'An ideal sandwich' do 
#   it 'is delicious' do 
#     sandwich =Sandwich.new('delicious', [])

#     taste = sandwich.taste
#     expect(taste).to eq('delicious') 

#   end
# end

#Example 3

# Sandwich = Struct.new(:taste, :toppings)

# RSpec.describe 'An ideal sandwich' do 
#   it 'is delicious' do 
#     sandwich =Sandwich.new('delicious', [])

#     taste = sandwich.taste
#     expect(taste).to eq('delicious') 

#   end

#   it 'lets me add toppings' do
#     sandwich = Sandwich.new('delicious', [])
#     sandwich.toppings << 'cheese'
#     toppings = sandwich.toppings
    
#     expect(toppings).not_to be_empty
#   end
# end

#Refactor with example 3 with a before hook
  #Upsides to this approach
    #clear out a test database before each example
    #great for running real world set up code 
  #Downsides to using an instance variable
    #mispelled instance variable return nill - hard to debug that
    #to refactor you needed to change every variable to an instance
    #potentially isn't used in all the code - inefficient

# Sandwich = Struct.new(:taste, :toppings)

# RSpec.describe 'An ideal sandwich' do 
#   before { @sandwich = Sandwich.new('delicious', []) 
#   }
#   it 'is delicious' do 
#     taste = @sandwich.taste

#     expect(taste).to eq('delicious') 

#   end

#   it 'lets me add toppings' do
#     @sandwich.toppings << 'cheese'
#     toppings = @sandwich.toppings
    
#     expect(toppings).not_to be_empty
#   end
# end

#Refactor Example 3 with helper method

# Sandwich = Struct.new(:taste, :toppings)

# def sandwich
#   #Memoize sandwich variable. Created if it doesn't exist, return if it does.
#   @sandwich ||= Sandwich.new('delicious', [])
# end
# RSpec.describe 'An ideal sandwich' do 
#   it 'is delicious' do 
   

#     taste = sandwich.taste
#     expect(taste).to eq('delicious') 

#   end

#   it 'lets me add toppings' do

#     sandwich.toppings << 'cheese'
#     toppings = sandwich.toppings
    
#     expect(toppings).not_to be_empty
#   end
# end

# Refactor Example 3 with let


Sandwich = Struct.new(:taste, :toppings)

RSpec.describe 'An ideal sandwich' do 
  let(:sandwich) {Sandwich.new('delicious', [])}
  it 'is delicious' do
    taste = sandwich.taste
    expect(taste).to eq('delicious') 

  end

  it 'lets me add toppings' do
  
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings
    
    expect(toppings).not_to be_empty
  end
end