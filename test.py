from keras.models import Sequential
from keras.layers import LSTM, Dense, Activation



emb=11
hidden=15

model = Sequential()
model.add(LSTM(input_shape = (emb,), input_dim=emb, output_dim=hidden, return_sequences=True))
model.add(LSTM(input_shape = (emb,), input_dim=emb, output_dim=hidden, return_sequences=False))
model.add(Dense(3))
model.add(Activation('softmax'))
model.compile(loss='mse', optimizer='adam')

model.save_weights('weights.hdf5')