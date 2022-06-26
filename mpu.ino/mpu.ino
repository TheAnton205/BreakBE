/*
A modified version from the MPU6050 example from the MPU6050 library by Electronic Cats
https://github.com/ElectronicCats/mpu6050/blob/master/examples/MPU6050_raw/MPU6050_raw.ino
*/

#include "I2Cdev.h"
#include "MPU6050.h"


#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif


MPU6050 accelgyro;

int16_t ax, ay, az;
int16_t gx, gy, gz;

int prevy = 300;


#define OUTPUT_READABLE_ACCELGYRO


void setup() {
    delay(5000); //wait for user to begin!
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(115200);


    accelgyro.initialize();


}

void loop() {
    accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
    gy = abs(gy);
    #ifdef OUTPUT_READABLE_ACCELGYRO
        int change = gy-prevy;
        //if (change > 100) {
          //Serial.println(change);
          Serial.print(gx); Serial.print("\t");
          Serial.print(", ");
          Serial.print(gy); Serial.println("\t");
        //}
        
       // Serial.print(gy);
       // Serial.println(gz);
        delay(200);
    #endif

}
