// ================================================================================
// Dependencias | librerías
// ================================================================================ 
#include "ESPMax.h"
#include "_espmax.h"
#include "LobotSerialServoControl.h"
#include "SuctionNozzle.h"
#include "ESP32PWMServo.h"
#include <WiFi.h>
#include <ArduinoJson.h>
//#include <esp_task_wdt.h>
//#define WDT_TIMEOUT 10
// ================================================================================
// Declaración de variables
// =====================xz===========================================================
// WiFi + TCP
const char* ssid = "Robotat";
const char* password =  "iemtbmcit116";
String currentLine = ""; 
String previousLine = ""; 
//const char* ssid = "ARRIS-9FA1";
//const char* password =  "BUL647378585";
WiFiServer wifiServer(8116);
volatile float angulos[4] = {120.36,89.16,1.57,0};
bool pump = false;
float pulsePumpPrevious = 0;
bool previousPump = false;
int flagValve;

// ================================================================================
// Definición de funciones
// ================================================================================


// ================================================================================
// Definición de tareas
// ================================================================================
void
tcp_comms_task(void * p_params)
{
  // setup() de la tarea 
  
  while(1) // loop() de la tarea
  {
    WiFiClient client = wifiServer.available();
    if (client) {
      Serial.println("New client connected");
      bool reading = false;
      while (client.connected()) {
        if (client.available()) {;
          char c = client.read();
          Serial.print(c);
          // Comienza a leer cuando se encuentra el '{'
          if (c == '{') {
            reading = true;
            currentLine = ""; // Limpiar la línea actual
            currentLine += c; // Incluir el '{'
          } 
          else if (reading) {
            currentLine += c;
            if (c == '}') { // Finaliza la lectura al encontrar '}'
              reading = false;
            }
          }
        }

        // Procesar el JSON recibido
        if (currentLine.length() > 0 && !reading) {
          Serial.print("JSON received: ");
          Serial.println(currentLine); 
          StaticJsonDocument<512> doc;
          DeserializationError error = deserializeJson(doc, currentLine);
          if (error) {
            Serial.print(F("deserializeJson() failed: "));
            Serial.println(error.f_str());
            client.println("Invalid JSON");
          } else {
            JsonArray cfg = doc["cfg"];
            for (int i = 0; i < 4; i++) {
              angulos[i] = cfg[i];
            }
            pump = doc["pmp"];
            //startEn = true;
            client.println("JSON received successfully");
          }
        }
        vTaskDelay(10/ portTICK_PERIOD_MS); 
      }

         
    }
  }
}


void
robot_control_task(void * p_params)
{

  while(1) // loop()
  {
      set_angles(angulos);
      int pulsePump = map(angulos[3], 0, 180, 500, 2500);
      if (pump != previousPump){
          flagValve = 1;
      }
      if (pump == true){
          if (flagValve = 1){
            Valve_off();
            flagValve = 0;
          }
          Pump_on();
          
      }
      else {
        if (flagValve = 1){
            Valve_on();
            flagValve = 0;
          }
        Pump_off();
      }
      if (pulsePump != pulsePumpPrevious){
        SetPWMServo(1, pulsePump, 500);
        pulsePumpPrevious = pulsePump;
      }
      
  
    vTaskDelay(500/portTICK_PERIOD_MS);   
  }
}


void 
setup() 
{
  ESPMax_init();
  Nozzle_init();
  PWMServo_init();
  Valve_off();
 // esp_task_wdt_init(WDT_TIMEOUT, false); //enable panic so ESP32 restarts
  //esp_task_wdt_add(NULL); //add current thread to WDT watch   
  // Setup de drivers y librerías
  Serial.begin(115200); 
  
  WiFi.begin(ssid, password);
 
  while (WiFi.status() != WL_CONNECTED) 
  {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }
 
  Serial.println("Connected to the WiFi network");
  Serial.println(WiFi.localIP());
  Serial.println(WiFi.macAddress());
 
  wifiServer.begin();

  // Creación de tareas
  xTaskCreate(robot_control_task, "robot_control_task", 1024*2, NULL,configMAX_PRIORITIES-1, NULL);
  xTaskCreate(tcp_comms_task, "tcp_comms_task", 1024*2, NULL, configMAX_PRIORITIES, NULL);
}
void 
loop() 
{

} 
