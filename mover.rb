# this script moves a random 20% of the training data
# into the appropriate test folder
def move_random(dir)
    d = Dir.open(Dir.pwd + '/' + dir)
    files = d.each.to_a.shuffle
    files[1..(files.length/5)].each do |file|
        if file != '.' && file != '..'
            path = dir + '/' + file
            %x[mv ./#{path} ./test/#{path}]
        end
    end
end

# call the script with the director to move from as the
# only argument
move_random(ARGV[0]) if ARGV[0]
