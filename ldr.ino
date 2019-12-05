//Sensor de luz com LDR

byte sinal_tx = 0;
int ldrPin = 0; //LDR no pino analígico 8
int ldrValor = 0; //Valor lido do LDR

void setup() {
  Serial.begin(9600); //Inicia a comunicação serial
}

void loop() {
  ///ler o valor do LDR
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
