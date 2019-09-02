#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
 
const char* ssid = "Wifi_SSID";
const char* password = "Wifi_Password";

int BUTTON_PIN = D1;
int BUTTON2 = D2;

int buttonState;
int buttonState2;
int lastButtonState = LOW;
int lastButtonState2 = LOW;

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers
unsigned long lastDebounceTime2 = 0;  // the last time the output pin was toggled

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);     // Initialize the LED_BUILTIN pin as an output
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(BUTTON2, INPUT_PULLUP);
  Serial.begin(115200);
  digitalWrite(LED_BUILTIN, LOW);
  WiFi.begin(ssid, password);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print("Connecting..");
  }
}

// the loop function runs over and over again forever
void loop() {
  int reading = digitalRead(BUTTON_PIN);
  int reading2 = digitalRead(BUTTON2);
   if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
  if (reading2 != lastButtonState2) {
    lastDebounceTime2 = millis();
  }
   if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;
      if (buttonState == LOW) {
        Serial.print("Bucket full.");
        if (WiFi.status() == WL_CONNECTED) { 
          HTTPClient http;  //Declare an object of class HTTPClient
          http.begin("http://IP.DOMOTICZ:PORT/json.htm?type=command&param=switchlight&idx=IDX&switchcmd=On");
          int httpCode = http.GET();
          if (httpCode > 0) { //Check the returning code
            String payload = http.getString();   //Get the request response payload
            Serial.println(payload);                     //Print the response payload
          }
          http.end();   //Close connection
        }
      }
    }
  }
     if ((millis() - lastDebounceTime2) > debounceDelay) {
    if (reading2 != buttonState2) {
      buttonState2 = reading2;
      if (buttonState2 == LOW) {
        if (WiFi.status() == WL_CONNECTED) { 
          HTTPClient http;  //Declare an object of class HTTPClient
          http.begin("http://IP.DOMOTICZ:PORT/json.htm?type=command&param=switchlight&idx=IDX&switchcmd=On");
          int httpCode = http.GET();
          if (httpCode > 0) { //Check the returning code
            String payload = http.getString();   //Get the request response payload
            Serial.println(payload);                     //Print the response payload
          }
          http.end();   //Close connection
        }
      }
    }
  }
  // save the reading. Next time through the loop, it'll be the lastButtonState:
  lastButtonState = reading;
  lastButtonState2 = reading2;
}
