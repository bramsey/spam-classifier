Dir.chdir File.dirname(__FILE__) 
@word_counts = {
    :spam => {},
    :ham => {}
}

@label_totals = {
    :spam => 0.0,
    :ham => 0.0
}

@spammicity = {}

@spam_hash = {}
@spam_count = 0.0

@ham_hahs = {}
@ham_count = 0.0

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

def tokenize(email)
    words = email.split(/[\s\n;".,;:()\[\]\\]/)
end

def train(email, label)
    words = tokenize email
    
    words.each do |word|
        @word_counts[label][word] ||= 0
        @word_counts[label][word] += 1
    end

    @label_totals[label] += 1
end

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

def build_spammicity_hash 
    @word_counts[:spam].each do |word, count|
        @spammicity[word] ||= calc_spammicity(word)
    end
    @word_counts[:ham].each do |word, count|
        @spammicity[word] ||= calc_spammicity(word)
    end
end

def get_interesting_words(words)
    seen, interesting_words = {}, []

    interest_scores = words.map do |word|
        return {:word => word, :prob => 0, :score => 0} if seen[word]
        seen[word] = true
        prob = @spammicity[word] || 0.4
        score = prob > 0 ? (prob - 0.5).abs : 0
        {:word => word, :prob => prob, :score => score}
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

def initialize
    spam_files = load_files 'spam'
    ham_files = load_files 'easy_ham'
    spam_files.each {|file| train file, :spam}
    ham_files.each {|file| train file, :ham}
    build_spammicity_hash
end
