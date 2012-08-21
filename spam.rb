Dir.chdir File.dirname(__FILE__) 
@word_counts = {
    :spam => {},
    :ham => {}
}

@label_totals = {
    :spam => 0,
    :ham => 0
}

@spam_hash = {}
@spam_count = 0

@ham_hahs = {}
@ham_count = 0

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

puts @word_counts[:ham]
