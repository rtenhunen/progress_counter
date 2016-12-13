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
	@processing_message = "Processing…" # Default processing message
	
	def initialize(args) # (Hash) -> Object
		@max_count = args[:count]
		@processing_message = args[:process_message] if args[:process_message]
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

	def percent() # (Opt) -> $stdout.String
		# Clears current row and writes a percentage of current progress to it
		# If a string is passed 
		$stdout.flush
		$stdout.write "\r#{@processing_message}#{(@processing_message)?(" "):("")}#{(@current_percentage * 100).round}%"
		done?
	end

	def draw # (Nil) -> $stdout.String

		if @current_percentage_int < 10
			pad = 3
			
		else
			pad = 4
		end

		spacing = ENV["COLUMNS"].to_i - pad - 2 - @current_percentage_int


		$stdout.write "\r#{@current_percentage_int}% [#{progress_bar(@current_percentage_int)}#{white_pad(spacing)} ]"
		$stdout.flush
		done?
	end

	private
	def update_percentage() # Nil -> Nil
		@current_percentage 	= (@current_count / @max_count.to_f)
		@current_percentage_int = (@current_percentage * 100).floor # This way 100% is always actually complete
	end

	def white_pad(padding) # (Int) -> String
		pad_string = ""
		padding.times {
			pad_string = pad_string + " "
		}
		return pad_string
	end
	def progress_bar(iterations) # (Int) -> String
		bar = ""
		iterations.times {
			bar = bar + "="
		}
		return bar

	end
	def done? # (Nil) -> String
		# When 100% is reached prints out 🍻
		if @current_count == @max_count
			# 🍻
			# Unicode: U+1F37B, UTF-8: F0 9F 8D BB
			puts "\n#{[127867].pack('U*')}"
		end
	end

end


n = 100
test = Progress.new({count: n})
n.times { test.increment ; test.percent ; test.draw ; sleep 0.01 }
