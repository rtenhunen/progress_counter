#!/usr/bin/env ruby
# 
# Rainer, 2016-11-01
# Progress counter 

class String
	def convert_base(from, to)
		self.to_i(from).to_s(to)
	end
	def to_emoji # -> String

		if ( self =~ /\b\d+\b/ )
			return "#{[self.to_i].pack('U*')}"
		elsif ( self =~ /\b[0-9A-F]+\b/i )
			return "#{[self.convert_base(16, 10).to_i].pack('U*')}"
		else
			raise "TypeError: #{self} is not a valid code point for Emoji. Needs to be a valid Int or Hex!"
		end
	end
end

class Progress
	@current_count, @max_count, @current_percentage_int, @current_percentage = nil
	
	def initialize(count) # (Int) -> Object
		@max_count = count
		@current_count = 0
		@current_percentage = 0.0
		@current_percentage_int = 0
	end

	def increment # (Nil) -> Int
		# Increments current progress by one 
		@current_count += 1
		update_percentage()

		return @current_count
	end

	def increment_by(i) # (Int) -> Int
		# Increments current progress by given increment
		@current_count += i
		update_percentage()

		return @current_count
	end

	def percent(*args) # (Opt) -> $stdout.String
		# Clears current row and writes a percentage of current progress to it
		# If a string is passed 
		$stdout.flush
		$stdout.write "\r#{args[0]}#{(args.count>0)?(" "):("")}#{(@current_percentage * 100).round}%"
		done?
	end

	# def draw # (Nil) -> $stdout.String

	# 	if @current_percentage_int < 10
	# 		pad = 3
			
	# 	else
	# 		pad = 4
	# 	end

	# 	spacing = ENV["COLUMNS"].to_i - pad - 2 - @current_percentage_int


	# 	$stdout.write "\r#{@current_percentage_int}% #{hash_pad(@current_percentage_int)}#{white_pad(spacing)} #"
	# 	$stdout.flush
	# 	done?
	# end

	private
	def update_percentage() # Nil -> Nil
		@current_percentage = (@current_count / @max_count.to_f)
		@current_percentage_int = (@current_percentage * 100).round
	end

	def white_pad(padding) # (Int) -> String
		pad_string = ""
		padding.times {
			pad_string = pad_string + " "
		}
		return pad_string
	end
	def hash_pad(hashes) # (Int) -> String
		hash_string = ""
		hashes.times {
			hash_string = hash_string + "#"
		}
		return hash_string

	end
	def done? # (Nil) -> String
		# When 100% is reached prints out 🍻
		if @current_percentage_int == 100
			# 🍻
			# Unicode: U+1F37B, UTF-8: F0 9F 8D BB
			puts "\n#{[127867].pack('U*')}"
		end
	end

end


# n = 100
# test = Progress.new(n)
# n.times { test.increment ; test.percent("Processing…") ; sleep 0.01 }
