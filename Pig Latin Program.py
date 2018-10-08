pyg = 'ay'

print ('Enter a word with only alpha characters.')

original = input()

if len(original) > 0 and original.isalpha():
    word = original.lower()
    first = word[0]
    new_word = word[1:] + first + pyg
    print ('Your word in pig latin is ' + new_word)
else:
    print ('empty')
