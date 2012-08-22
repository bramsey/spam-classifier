# Initialize data structures
@word_counts = {
    :spam => {},
    :ham => {}
}

@label_totals = {
    :spam => 0.0,
    :ham => 0.0
}

@spammicity = {}

# load the files from the specified director into an array
# and return the array.
def load_files(dir)
    files = []
    d = Dir.open(Dir.pwd + '/' + dir)
    d.each do |file|
        if file != '.' && file != '..'
            files << File.open(dir + '/' + file, 'r').read.unpack('C*').pack('U*') 
        end
    end
    files
end

# generate the words array from the given email
def tokenize(email)
    words = email.split(/[\s\n;".,;:()\[\]\\]/)
end

# populate the count data structures for each word in the given email
def train(email, label)
    words = tokenize(email)
    
    words.each do |word|
        @word_counts[label][word] ||= 0
        @word_counts[label][word] += 1
    end

    @label_totals[label] += 1
end

# calculate the spammicity of the given word
def calc_spammicity(word)
    spam_count = @word_counts[:spam][word] || 0.0
    ham_count = @word_counts[:ham][word] || 0.0
    spam_total = @label_totals[:spam]
    ham_total = @label_totals[:ham]


    unless spam_count + ham_count < 5
        p_spam = [1.0, spam_count / spam_total].min
        p_ham = [1.0, ham_count / ham_total].min

        if (p_spam + p_ham) > 0
            spammicity = 
                [0.01,
                    [0.99,
                        p_spam / (p_spam + p_ham) 
                    ].min
                ].max
        else
            puts "#{p_spam} | #{p_ham}"
            spammicity = 0.5
        end
    else
        spammicity = 0.5
    end
end

# populate the spammicity hash with the spammicity of each word
# in the data structures
def build_spammicity_hash 
    @word_counts[:spam].each do |word, count|
        @spammicity[word] ||= calc_spammicity(word)
    end
    @word_counts[:ham].each do |word, count|
        @spammicity[word] ||= calc_spammicity(word)
    end
end

# find the index of the highest value in the scores array
def index_of_highest(scores)
    high_index, highest = 0, 0

    scores.each_index do |index|
        if scores[index][:score] > highest
            highest = scores[index][:score]
            high_index = index
        end
    end

    high_index
end

# get an array of the 15 most interesting words
# interestingness is ranked by spammicity probablity
# farthest from a neutral 0.5
def get_interesting_words(words)
    seen = {}
    interesting_words = []

    interest_scores = words.map do |word|
        if seen[word]
            {:word => word, :prob => 0.0, :score => 0.0} if seen[word]
        else
            seen[word] = true
            prob = @spammicity[word] || 0.4
            score = prob > 0.0 ? (prob - 0.5).abs : 0.0
            {:word => word, :prob => prob, :score => score}
        end
    end

    15.times do
        len = interest_scores.length
        break unless len > 0
        high_index = index_of_highest(interest_scores)
        swap_holder = interest_scores[len-1]
        interest_scores[len-1] = interest_scores[high_index]
        interest_scores[high_index] = swap_holder
        interesting_words.push(interest_scores.pop)
    end

    interesting_words
end

# classify the given email as spam or ham
def classify(email)
    words = tokenize(email)
    interesting = get_interesting_words(words)
    product, alt_product = 1, 1

    interesting.each do |word|
        if word[:prob] > 0
            product *= word[:prob]
            alt_product *= (1 - word[:prob])
        end
    end
    score = product / (product + alt_product)

    score > 0.9 ? :spam : :ham
end

# initialize the data structures
def init
    spam_files = load_files('spam')
    ham_files = load_files('easy_ham')
    ham_files.concat(load_files('hard_ham'))

    spam_files.each {|file| train file, :spam}
    ham_files.each {|file| train file, :ham}
    build_spammicity_hash
end

init

# calculate the accuracy stats for the given files
# with the expected label
def stats_for(files, expected_label)
    misses = 0.0
    classifications = files.each do |email|
        classification = classify(email)
        misses += 1 if classification != expected_label
    end
    [misses, misses/files.length]
end

# print the stats for the corpus test data
def stats
    easy_ham_files = load_files('easy_ham')
    hard_ham_files = load_files('hard_ham')
    spam_files = load_files('spam')

    easy_stats = stats_for(easy_ham_files, :ham)
    hard_stats = stats_for(hard_ham_files, :ham)
    spam_stats = stats_for(spam_files, :spam)

    puts "easy ham: #{easy_stats[0]} misses at #{easy_stats[1]}%"
    puts "hard ham: #{hard_stats[0]} misses at #{hard_stats[1]}%"
    puts "spam: #{spam_stats[0]} misses at #{spam_stats[1]}%"
end

stats
