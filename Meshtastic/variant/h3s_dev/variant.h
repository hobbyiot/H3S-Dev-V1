// https://github.com/hobbyiot/H3S-Dev-V1

// H3S-Dev I2C bus
#undef I2C_SDA
#undef I2C_SCL
#define I2C_SDA 1
#define I2C_SCL 2

// No GPS (GNSS support planned for a future release)
#undef GPS_RX_PIN
#undef GPS_TX_PIN

#define HAS_SCREEN 0

#define USE_SX1262

#define LORA_SCK 5
#define LORA_MISO 3
#define LORA_MOSI 6
#define LORA_CS 7

#define LORA_DIO0 -1
#define LORA_RESET 8
#define LORA_DIO1 16
#define LORA_DIO2 17
#define LORA_DIO3

#define SX126X_CS LORA_CS
#define SX126X_DIO1 LORA_DIO1
#define SX126X_BUSY LORA_DIO2
#define SX126X_RESET LORA_RESET
#define SX126X_POWER_EN 13

#define SX126X_DIO2_AS_RF_SWITCH
#define SX126X_DIO3_TCXO_VOLTAGE 1.8

#define LED_POWER 4

#define BATTERY_PIN 10
#define ADC_CHANNEL ADC1_GPIO10_CHANNEL

#define EXT_PWR_DETECT 9

#undef EXT_NOTIFY_OUT
