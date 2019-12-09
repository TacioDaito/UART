//Sensor de luz com LDR
int sinal_rx = 0;
int ldrPin = 0; //LDR no pino analógico 0
int ldrValor = 0; //Valor lido do LDR
int somPin = 1; //Sensor de som no pino analógico 1
int somValor = 0; //Valor lido do sensor de som

void setup() {
  Serial.begin(9600); //Inicia a comunicação serial
}

void loop() {

  sinal_rx = Serial.read();

  if (sinal_rx = 1) { //Ativa o sensor de luz caso receba 1

    //ler o valor do LDR
    ldrValor = analogRead(ldrPin); //O valor lido será entre 0 e 1023

    if (ldrValor <= 1023 && ldrValor >= 930) {
      delay(100);
      Serial.write(0);
      if (ldrValor < 930 && ldrValor >= 840) {
        delay(100);
        Serial.write(1);
        if (ldrValor < 840 && ldrValor >= 750) {
          delay(100);
          Serial.write(2);
          if (ldrValor < 750 && ldrValor >= 660) {
            delay(100);
            Serial.write(3);
            if (ldrValor < 660 && ldrValor >= 570) {
              delay(100);
              Serial.write(4);
              if (ldrValor < 570 && ldrValor >= 480) {
                delay(100);
                Serial.write(5);
                if (ldrValor < 480 && ldrValor >= 390) {
                  delay(100);
                  Serial.write(6);
                  if (ldrValor < 390 && ldrValor >= 300) {
                    delay(100);
                    Serial.write(7);
                    if (ldrValor < 300 && ldrValor >= 210) {
                      delay(100);
                      Serial.write(8);
                      if (ldrValor < 210 && ldrValor >= 120) {
                        delay(100);
                        Serial.write(9);
                        if (ldrValor < 120 && ldrValor >= 0) {
                          delay(100);
                          Serial.write(10);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

  }

  else { //Muda pro sensor de som caso receba outro valor além de 1
    somValor = analogRead(somPin); //O valor lido será entre 0 e 1023

    if (somValor < 120 && somValor >= 0) {
      delay(100);
      Serial.write(0);
      if (somValor < 210 && somValor >= 120) {
        delay(100);
        Serial.write(1);
        if (somValor < 300 && somValor >= 210) {
          delay(100);
          Serial.write(2);
          if (somValor < 390 && somValor >= 300) {
            delay(100);
            Serial.write(3);
            if (somValor < 480 && somValor >= 390) {
              delay(100);
              Serial.write(4);
              if (somValor < 570 && somValor >= 480) {
                delay(100);
                Serial.write(5);
                if (somValor < 660 && somValor >= 570) {
                  delay(100);
                  Serial.write(6);
                  if (somValor < 750 && somValor >= 660) {
                    delay(100);
                    Serial.write(7);
                    if (somValor < 840 && somValor >= 750) {
                      delay(100);
                      Serial.write(8);
                      if (somValor < 930 && somValor >= 840) {
                        delay(100);
                        Serial.write(9);
                        if (somValor <= 1023 && somValor >= 930) {
                          delay(100);
                          Serial.write(10);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

  }


}
