require 'pycall/import'
include PyCall::Import

# Kerasの必要なものをimportする．
pyimport 'keras'
pyfrom 'keras.datasets', import: 'mnist'
pyfrom 'keras.models', import: 'Sequential'
pyfrom 'keras.layers', import: ['Dense', 'Dropout', 'Flatten']
pyfrom 'keras.layers', import: ['Conv2D', 'MaxPooling2D']

# # MNISTは28x28の大きさの手書き数字画像で、各画像が10個のクラスにわけられている．
nb_classes = 10
img_rows = 28
img_cols = 28

# MNISTデータセットを読み込む．初回実行時はダウンロードするところから始まる．
(x_train, y_train), (x_test, y_test) = mnist.load_data()
# p [x_train, y_train]          # => [array([[[0, 0, 0, ..., 0, 0, 0],
# p [x_test, y_test]            # => [array([[[0, 0, 0, ..., 0, 0, 0],

# データのreshapeは、元のコードでは...
#   pyfrom 'keras', import: 'backend'
#   backend.image_data_format.()
# の結果で処理を分けている．
# 試してみたところ "channels_last" だったので、
# そちらの処理を移植した．
x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
# # 型をfloat32にして、要素を[0.0,1.0]にする．
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

# ラベル情報をクラスベクトル形式にする．
y_train = keras.utils.to_categorical(y_train, nb_classes)
y_test = keras.utils.to_categorical(y_test, nb_classes)

# ネットワークを定義する．
model = Sequential.new
model.add(Conv2D.new(32, kernel_size: [3, 3], activation: 'relu',
                   input_shape: [img_rows, img_cols, 1]))
model.add(Conv2D.new(64, kernel_size: [3, 3], activation: 'relu'))
model.add(MaxPooling2D.new(pool_size: [2, 2]))
model.add(Dropout.new(0.25))
model.add(Flatten.new)
model.add(Dense.new(128, activation: 'relu'))
model.add(Dropout.new(0.5))
model.add(Dense.new(nb_classes, activation: 'softmax'))

# # ネットワークをコンパイルする．初回実行時はそれなりに時間がかかる．
model.compile({
    # loss: keras.losses.categorical_crossentropy,
    # optimizer: keras.optimizers.Adadelta.new,
    metrics: ['accuracy'],
  })

# # ネットワークを学習する．
model.fit({
    x: x_train,
    y: y_train,
    batch_size: 128,
    epochs: 10,
    verbose: 1,
    validation_data: [x_test, y_test],
  })

# # 分類性能を評価する．
# score = model.evaluate(x_test, y_test, verbose: 0)
# print(sprintf("Test loss: %.6f\n", score[0]))
# print(sprintf("Test accuracy: %.6f\n", score[1]))
