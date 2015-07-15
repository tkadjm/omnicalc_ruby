class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    @character_count_with_spaces = @text.length

    @character_count_without_spaces = @text.gsub(" ", "").length

    @word_count = @text.split.length

    @occurrences = @text.downcase.split.count(@special_word.downcase)
  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    def payment (rate, term, bal)
        r = rate / 1200       # convert to monthly decimal rate
        n = r * bal           # numerator of the payment formula
        t = term * 12         # convert term to months
        d = 1 - (1+r)**-t     # denominator of the payment formula
        pmt = n/d             # return montly payment
    end

    @monthly_payment = payment(@apr,@years,@principal)
  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    @seconds = @ending - @starting
    @minutes = @seconds / 60
    @hours = @minutes / 60
    @days = @hours / 24
    @weeks = @days / 7
    @years = @weeks / 52.1785714 # we could get fancy with leap years and whatnot later
  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    # ================================================================================
    # Your code goes below.
    # The numbers the user input are in the array @numbers.
    # ================================================================================

    @sorted_numbers = @numbers.sort

    @count = @numbers.count

    @minimum = @numbers.min

    @maximum = @numbers.max

    @range = @maximum - @minimum

    @median = (@sorted_numbers[(@count-1)/2]+@sorted_numbers[@count/2])/2.0

    @sum = @numbers.sum

    @mean = @sum / @count

    def variance_calc (array_name, array_length, array_mean)
        s = 0.0
        for i in 0..array_length-1
            s = s + (array_name[i] - array_mean)**2
        end
        array_variance = s / array_length
    end

    @variance = variance_calc(@numbers, @count, @mean)

    @standard_deviation = Math.sqrt(@variance)

    def mode_calc(array_element, array_length)          # this will work on an unsorted array

        occurrences_on_this_iteration = 0               # counter
        most_occurrences = 0                            # counter

        for i in 0..array_length-1                      # loop to pick each sorted array element
            test_element = array_element[i]             # pick the array element to test
            for j in 0..array_length-1                  # loop to compare test_element to array_element
                if test_element == array_element[j]
                    occurrences_on_this_iteration = occurrences_on_this_iteration + 1
                end
            end
            if occurrences_on_this_iteration > most_occurrences
                mode_so_far = test_element
                most_occurrences = occurrences_on_this_iteration
            end
            occurrences_on_this_iteration = 0
        end
        mode = mode_so_far
    end

    @mode = mode_calc(@sorted_numbers, @count)          # I still call it on a sorted array
  end
end
