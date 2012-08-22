# Bayesian Spam Classifier

A ruby spam classifier using [Paul Graham's method for classification](http://www.paulgraham.com/spam.html)

## Installation

1. Clone this repository
2. Obtain the corpus data from [Spam Assassin's public corpus](http://spamassassin.apache.org/publiccorpus/)
3. Place the data in the following director structure in the root directory of the main script:
```
spam files => spam/
easy_ham files => easy_ham/
hard_ham files => hard_ham/
```
4. Create the following empty directories in the root directory of the script:
```
test/spam
test/easy_ham
test/hard_ham
```
4. Run the mover.rb script for each sub_folder to move a random 20% of the corpus data to the test directories.

## How to use

Simply run the spam.rb, then view the accuracy stats when the script completes.

## License

(The MIT License)

Copyright (c) 2012 Bill Ramsey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
