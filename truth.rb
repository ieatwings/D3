# Brandon La - bnl22
# CS 1632 - D3
# Automated Web Testing

require 'sinatra'
require 'sinatra/reloader'

# Pages:
########
# 1. main '/'
# 2. error '/error'
# 3. table '/results'

# Steps:
###########
# 1. generate main page
# => a. going anywhere else generates '/error' page

# 2. accept true/false symbols & table size
# => a. check for invalid values
# => b. check for identical true/false values
# => c. table size must be >= 2

# 3. generate table
# => a. displays specified symbols for true/false
# => b. displays descending values by size
# => c. displays 'AND', 'OR', 'NAND', 'NOR'
# => d. displays results of those operations

# 4. DEFAULT VALUES
# => a. true = T
# => b. false = F
# => c. size = 3


# Function: checks validity of inputs:
# => t = truth symbol
# => f = false symbol
# => s = size
# Equivalence classes:
# t/f = [Any Symbole] -> return true
# t/f = [> 1 character] -> return false
# t == f -> return false
# s = [2..INIFINITY] -> return true
# s = [-INFINITY..2] -> return false
# s = [Non-Integer] -> return false

def check_validity(t, f, s)
	puts "checkin validity"
	if t.length > 1 || f.length > 1
		return false
	elsif t == f
		return false
	elsif(s.is_a?(Integer) == false || s.to_i < 2)
		return false
	else
		return true
	end
end

# Function that initializes truth table and creates binary representation of the symbols
def create_table(t, f, s)
	output_size = 2 ** s
	output = Array.new(output_size)
	temp_string = "%0#{s}b"
	0.upto(output_size - 1).each { |n| output[n] = temp_string % n}

	#test
	# for binary in output
	# 	puts binary
	# end

	for binary in output
		curr = binary.to_i(2)

		for x in 0..s-1
			if binary[x] == '0'
				binary[x] = f
			else
				binary[x] = t
			end
		end
		output[curr] = "#{binary}"
	end
	return output
end


################
# GET REQUESTS #
################

not_found do
	status 404
	body '404 Error'
	erb :error
end

# GET request for /results:
get '/results' do

	error = nil
    checky = false

    # These will check for default values
	pg_truth = params['truthy']
	if pg_truth == ""
		pg_truth = 'T'
	end
	pg_truth = pg_truth.to_s

	pg_false = params['falsy']
	if pg_false == ""
		pg_false = 'F'
	end
	pg_false = pg_false.to_s

	pg_size = params['size']
	if pg_size == ""
		pg_size = 3
	end
	pg_size = pg_size.to_i

	# validate any non-default symbols
	if check_validity(pg_truth, pg_false, pg_size)
		error = false
	else
		error = true
	end

	# create table 
	table = create_table(pg_truth, pg_false, pg_size)

	table_size = 2 ** pg_size

	# hard-coding in the numbers we're working with
	table_nums = ""
	while pg_size > 0
		pg_size -= 1
		table_nums += pg_size.to_s
	end

	erb :results, :locals => { pg_truth: pg_truth, pg_false: pg_false, pg_size: pg_size, error: error, table_nums: table_nums, table_size: table_size, table: table, checky: checky }
end

# GET request for /:
get '/' do

	# additional check for default values.... i think
	pg_truth = params['truthy']
	pg_truth ||= 'T'
	pg_truth = pg_truth.to_s

	pg_false = params['falsy']
	pg_false ||= 'F'
	pg_false = pg_false.to_s

	pg_size = params['size']
	pg_size ||= 3
	pg_size = pg_size.to_i

	erb :index, :locals => { truthy: pg_truth, pg_false: pg_false, pg_size: pg_size }

end

