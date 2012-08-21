Dir.chdir File.dirname(__FILE__) 
@word_counts = {
    :spam => {},
    :ham => {}
}

@label_totals = {
    :spam => 0.0,
    :ham => 0.0
}

@word_spammicity = {}

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
        @word_spammicity[word] ||= calc_spammicity(word)
    end
    @word_counts[:ham].each do |word, count|
        @word_spammicity[word] ||= calc_spammicity(word)
    end
end

def classify(email)

end

spam_files = load_files 'spam'
ham_files = load_files 'easy_ham'
spam_files.each do |file|
    train file, :spam
end
ham_files.each do |file|
    train file, :ham
end
build_spammicity_hash
