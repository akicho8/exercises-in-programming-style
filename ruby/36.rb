require "pycall/import"
include PyCall::Import

pyimport "keras"
pyfrom "keras.datasets", import: "mnist"
pyfrom "keras.models", import: "Sequential"
pyfrom "keras.layers", import: ["Dense", "Dropout", "Flatten"]
pyfrom "keras.layers", import: ["Conv2D", "MaxPooling2D"]

# pyimport "numpy", as: "np"
require "numpy"

printable = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"\#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\v\f"
Characters = printable.chars                     # => 
CharIndices = Characters.collect.with_index.to_h # => 
IndicesChar = CharIndices.invert                 # => 

INPUT_VOCAB_SIZE = Characters.length # => 
BATCH_SIZE = 200

def encode_one_hot(line)
  x = Numpy.zeros([line.length, INPUT_VOCAB_SIZE])
  line.chars.each.with_index do |c, i|
    if Characters.include?(c)
      index = CharIndices[c]
    else
      index = CharIndices[" "]
    end
    x[i][index] = 1
  end
  x
end

def decode_one_hot(x)
  s = []
  PyCall.len(x).times do |i|    # x.each は使えない
    onehot = x[i]
    one_index = Numpy.argmax(onehot)
    one_index = one_index.to_i  # one_index は Object 型になっているため to_i が必要
    s << IndicesChar[one_index]
  end
  s.join
end

def build_model
  model = Sequential.new
  dense_layer = Dense.new(INPUT_VOCAB_SIZE, input_shape: [INPUT_VOCAB_SIZE], activation: "softmax")
  model.add(dense_layer)
  model
end

PyCall.exec(<<~CODE)
import string, random
import numpy as np

characters = string.printable
characters = string.printable
char_indices = dict((c, i) for i, c in enumerate(characters))
indices_char = dict((i, c) for i, c in enumerate(characters))

INPUT_VOCAB_SIZE = len(characters)
BATCH_SIZE = 200

def encode_one_hot(line):
    x = np.zeros((len(line), INPUT_VOCAB_SIZE))
    for i, c in enumerate(line):
        if c in characters:
            index = char_indices[c]
        else:
            index = char_indices[' ']
            x[i][index] = 1
    return x

def input_generator(nsamples):
    def generate_line():
        inline = []; outline = []
        for _ in range(nsamples):
            c = random.choice(characters)
            expected = c.lower() if c in string.ascii_letters else ' '
            inline.append(c); outline.append(expected)
        return ''.join(inline), ''.join(outline)

    while True:
        input_data, expected = generate_line()
        data_in = encode_one_hot(input_data)
        data_out = encode_one_hot(expected)
        yield data_in, data_out
CODE

# def input_generator(nsamples)
#   loop do
#     input_data, expected = generate_line(nsamples)
#     data_in = encode_one_hot(input_data)
#     data_out = encode_one_hot(expected)
#     yield data_in, data_out
#   end
# end
#
# def generate_line(nsamples)
#   inline = []
#   outline = []
#   nsamples.times do
#     c = Characters.sample
#     if c.match?(/\p{Alpha}/)
#       expected = c.downcase
#     else
#       expected = " "
#     end
#     inline << c
#     outline << expected
#   end
#   [inline.join, outline.join]
# end

def train(model)
  model.compile(loss: "categorical_crossentropy", optimizer: "adam", metrics: ["accuracy"])
  input_gen = PyCall.eval("input_generator(#{BATCH_SIZE})")
  validation_gen = PyCall.eval("input_generator(#{BATCH_SIZE})")
  model.fit(input_gen, epochs: 50, workers: 1, steps_per_epoch: 20, validation_data: validation_gen, validation_steps: 10)
end

model = build_model
model.summary
train(model)

# 動作検証
batch = encode_one_hot("Hello, world!")
preds = model.predict(batch)
normal = decode_one_hot(preds)          # => 
p normal
