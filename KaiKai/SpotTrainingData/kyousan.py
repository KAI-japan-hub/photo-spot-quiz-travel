import coremltools as ct
import tensorflow as tf

# 1. トレーニング済みのTensorFlow/Kerasモデルをロード
# 例: model = tf.keras.models.load_model('your_keras_model.h5')
# または、TensorFlow Liteモデルの場合
# converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
# tflite_model = converter.convert()

# ここでは仮のシンプルなKerasモデルを作成（実際のモデルに置き換える）
model = tf.keras.Sequential([
    tf.keras.layers.InputLayer(input_shape=(224, 224, 3)), # モデルの入力サイズとチャンネル数に合わせる
    tf.keras.layers.Conv2D(32, 3, activation='relu'),
    tf.keras.layers.MaxPool2D(),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(10, activation='softmax') # 出力層は分類したいクラス数に合わせる
])
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
# モデルのダミー入力を定義（モデルの入力形状に合わせる）
input_shape = (1, 224, 224, 3) # バッチサイズ、高さ、幅、チャンネル
input_data = tf.random.uniform(input_shape, minval=0., maxval=1.)

# 2. Core ML形式に変換
# ct.convert() の引数はモデルの種類によって異なる
# 例: Keras HDF5ファイルの場合
# mlmodel = ct.convert(
#     'your_keras_model.h5',
#     inputs=[ct.ImageInput(shape=(1, 224, 224, 3), bias=[-1,-1,-1], scale=1/127.5)], # モデルの正規化に合わせて調整
#     classifier_output_labels=['label1', 'label2', 'label3', ...], # 分類ラベルのリスト
#     minimum_deployment_target=ct.target.iOS13 # iOSの最小バージョン
# )

# 上で作成したダミーモデルを変換する場合
mlmodel = ct.convert(
    model,
    inputs=[ct.ImageInput(shape=input_data.shape, # (1, 224, 224, 3)
                          scale=1/255.0)], # 0-255の画像を0-1に正規化する場合
    convert_to="mlprogram", # 最新のCore MLフォーマット
    compute_units=ct.ComputeUnit.ALL,
    classifier_output_labels=['清水寺', '嵐山の竹林', '東本願寺', 'その他のスポット'], # 実際のスポット名に置き換える
    minimum_deployment_target=ct.target.iOS15 # iOSの最小バージョン
)

# 3. .mlmodelファイルとして保存
mlmodel.save('SpotClassifier.mlmodel')
print("SpotClassifier.mlmodel has been created.")